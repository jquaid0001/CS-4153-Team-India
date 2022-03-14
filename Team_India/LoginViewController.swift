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
    
    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    

    // MARK: - Handlers

    @IBAction func logInButtonHandler(_ sender: UIButton) {
        // Set up a FormValidationUtil var
        let formValidation = FormValidationUtil()
        
        // Get the text field data and verify they are non-empty
        guard let email = emailAddrField.text,
              !email.isEmpty,
              let password = passwordField.text,
              !password.isEmpty
        else {
            // add code to highlight field(s) that's empty
            return
        }
        
        // if email is formatted improperly, don't send the data to authentication just post an error
        if !formValidation.isEmailFormatted(emailField: email) {
            // show error and highlight email field
            print("Email is not formatted properly.")
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
    }
    
    
    // MARK: - Funcs
    
    
    func showErrorMessage(message : String) {
        
        // Show an AlertController
        let alertController = UIAlertController(title: "Error Logging In",
                                          message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        // Add the action to the alertController
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    // Sends the user to the hoome page upon successful registration/log in
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
        
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
