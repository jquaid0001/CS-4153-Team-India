//
//  LoginViewController.swift
//  Team_India
//
//  Created by Josh Quaid on 3/4/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailAddrField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    
    
    // MARK: - View Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    // MARK: - Handlers

    @IBAction func buttonHandler(_ sender: UIButton) {
        
        switch sender {
        case forgotButton :
            showPassReset()
        case logInButton :
            // Get the text field data and verify they are non-empty
            guard let email = emailAddrField.text,
                  !email.isEmpty,
                  let password = passwordField.text,
                  !password.isEmpty
            else {
                showErrorMessage(message: "Please complete all fields.")
                return
            }
            
            // if email is formatted improperly, don't send the data to authentication just post an error
            if !FormValidationUtil.isEmailFormatted(emailField: email) {
                // show error and highlight email field
                showErrorMessage(message: "Email is not formatted properly.")
                return
            } else {
                // send email and password to authentication server and process
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
                    
                    if error != nil {
                        // Show the error from Firebase
                        self?.showErrorMessage(message: error?.localizedDescription ?? "Unknown login error")
                    } else {
                        // User succesfully logged in, go to Home
                        self?.goToHome()
                    }
                }
            }
        default :
            return
        }
    }
    
    // MARK: - Funcs
    
    // Shows error messages in an AlertController
    func showErrorMessage(message : String) {
        
        // Create an AlertController
        let alertController = UIAlertController(title: "Error Logging In",
                                          message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        // Add the action to the alertController
        alertController.addAction(okAction)
        
        // Show the alert controller
        self.present(alertController, animated: true)
    }
    
    
    // Show the password reset Alert Controller
    func showPassReset() {
        // Create an AlertController
        let passAlertController = UIAlertController(title: "",
                                                message: "Please enter your email to continue.",
                                                preferredStyle: .alert)
        // Add a text field to get the user's email address and add a callback to "alertTextFieldDidChange" to only enable the sendAction button if the email entered is formatted properly
        passAlertController.addTextField { forEmail in
            forEmail.placeholder = "Email address"
            forEmail.addTarget(self, action: #selector(self.alertTextFieldDidChange), for: .editingChanged)
        }
        
        // Set up the action buttons
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        // Set up the send reset link to call the sendPasswordReset method with the provided email address. We know there is an email if the button is enabled since we check with the callback for the forEmail text field.
        let sendAction = UIAlertAction(title: "Send Reset Link", style: .default) { _ in
            let email = passAlertController.textFields?[0].text
            Auth.auth().sendPasswordReset(withEmail: email!) { errorResettingEmail in
                if errorResettingEmail != nil {
                    self.showErrorMessage(message: errorResettingEmail!.localizedDescription)
                }
            }
        }
        
        // Add the actions to the alertController
        passAlertController.addAction(cancelAction)
        passAlertController.addAction(sendAction)
        // Disable the send reset link action until user types a good email address
        sendAction.isEnabled = false
        
        // Show the alert controller
        self.present(passAlertController, animated: true)

        
    }
    
    // Sends the user to the home page upon successful registration/log in
    func goToHome() {
        
        // Get the Home View Controller storyboard
        guard let homeVC = storyboard?.instantiateViewController(withIdentifier: "Home") as? HomeViewController else {
            showErrorMessage(message: "Unable to log in")
            return
        }
        
        // Change the root VC to the homeVC
        view.window?.rootViewController = homeVC
        view.window?.makeKeyAndVisible()
    }
        
       
    // The func to check if a good email is entered into the password reset alertController
    @objc func alertTextFieldDidChange(sender : UITextField) {
        
        // Get the alertController, the email address field, and the send reset action button
        guard let alertController = self.presentedViewController as? UIAlertController,
              let emailField = alertController.textFields?[0],
              let sendAction = alertController.actions.last else {
            return
        }
        
        // Only enable the send reset button if the email is formatted properly
        if let emailAddress = emailField.text {
            sendAction.isEnabled = FormValidationUtil.isEmailFormatted(emailField: emailAddress)
        }
        
    }

}
