//
//  LoginViewController.swift
//  Team_India
//
//  Created by Josh Quaid on 3/4/22.
//

import UIKit

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
            #warning("Add authentication here and perform segue based on success")
            performSegue(withIdentifier: "Logged In", sender: self)
        }
        
        
        
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
