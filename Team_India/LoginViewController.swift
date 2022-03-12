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
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the errorLabel to invisible
        errorLabel.alpha = 0

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
            print("email is formatted wrong")
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
        
        // Set the errorLabel
        errorLabel.text = message
        
        // Set the alpha to 1 to show the message
        errorLabel.alpha = 1
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
