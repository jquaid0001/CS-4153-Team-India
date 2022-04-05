//
//  LoginViewController.swift
//  Team_India
//
//  Created by Josh Quaid on 3/4/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailAddrField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    
    var visibilityButton = UIButton()
    
    // MARK: - View Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        visibilityButton = setupPasswordVisibilityButton()
        let visButtonContainer = UIView(frame: visibilityButton.frame)
        visButtonContainer.backgroundColor = .clear
        visButtonContainer.addSubview(visibilityButton)
        
        // Set the VC as the delegate for the textFields
        emailAddrField.delegate = self
        passwordField.delegate = self
        // Set up the props for the textFields keyboards
        emailAddrField.keyboardType = .emailAddress
        emailAddrField.returnKeyType = .next
        passwordField.returnKeyType = .done
        // Set the visibility button to show on the right of passwordField
        passwordField.rightViewMode = .always
        passwordField.rightView = visButtonContainer
        
        // Set the LOG IN button's background color so it's visible even when disabled
        logInButton.configuration?.background.backgroundColor = .systemBlue
        // Disable the LOG IN button until fields are populated
        logInButton.isEnabled = false
    }
    

    // MARK: - Observers
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        
        // If the password visibility is toggled, turn it off when user begins typing in the password field again
        if sender == passwordField && !passwordField.isSecureTextEntry {
            togglePassVis()
        }
        
        // Get the fields and check if they are both not empty
        guard let email = emailAddrField.text,
              !email.isEmpty,
              let passwordField = passwordField.text,
              !passwordField.isEmpty
        else {
            // If any fields becomes empty or is empty, make sure the LOG IN button is disabled
            logInButton.isEnabled = false
            return
        }
        // If both fields contain data, enable the LOG IN button else, leave it disabled
        logInButton.isEnabled = true
    }
    
    // MARK: - Handlers
    
    @IBAction func buttonHandler(_ sender: UIButton) {
        
        switch sender {
        case forgotButton :
            showPassReset()
        case logInButton :
            // Get the text field data and verify they are non-nil and populated for safety
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
    
    func setupPasswordVisibilityButton() -> UIButton {
        let visButton = UIButton(type: .custom)
        visButton.frame = CGRect(x: 0, y: 0, width: 50, height: passwordField.frame.height)
        // Try to get the system image for eye slash and set the visibilityButton's image to it
        if let visImage = UIImage(systemName: "eye.slash") {
            visButton.setImage(visImage, for: .normal)
        }
        visButton.addTarget(self, action: #selector(self.togglePassVis), for: .touchUpInside)
        
        return visButton
    }
    
    // Keyboard flow control for textFields
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // If user hits "next" in the emailAddrField, send the kayboard control to the passwordField
        if textField == emailAddrField {
            passwordField.becomeFirstResponder()
            return true
        } else {
            // If both fields are populated, the LOG IN button will be enabled in the textFieldDidChange func, so we are good to go for log in.
            if logInButton.isEnabled == true {
                // Close the keyboard
                passwordField.resignFirstResponder()
                // Simulate the LOG IN button press if the done button is pressed on the keyboard
                self.buttonHandler(logInButton)
                return true
            }
            // If the LOG IN button isn't enabled, do nothing when the user taps the "done" button on the keyboard.
            return false
        }
    }
    
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
    
    @IBAction func togglePassVis() {
        passwordField.isSecureTextEntry.toggle()
        // Set the image to the opposite of what is displayed for the visibilityButton
        if !passwordField.isSecureTextEntry {
            if let visImage = UIImage(systemName: "eye") {
                visibilityButton.setImage(visImage, for: .normal)
            }
        } else {
            if let existingPassText = passwordField.text {
                passwordField.deleteBackward()
                if let passwordTextRange = passwordField.textRange(from: passwordField.beginningOfDocument, to: passwordField.endOfDocument) {
                passwordField.replace(passwordTextRange, withText: existingPassText)
                }
            }
            
            if let visImage = UIImage(systemName: "eye.slash") {
                visibilityButton.setImage(visImage, for: .normal)
            }
            
            if let existingSelectedRange = passwordField.selectedTextRange {
                passwordField.selectedTextRange = nil
                passwordField.selectedTextRange = existingSelectedRange
            }
        }
    }
}
