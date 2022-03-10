//
//  RegistrationViewController.swift
//  Team_India
//
//  Created by Josh Quaid on 3/4/22.
//

import UIKit

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    // Get a FormValidationUtil var
    let formValidation = FormValidationUtil()
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailAddrField: UITextField!
    @IBOutlet weak var password1Field: UITextField!
    @IBOutlet weak var password2Field: UITextField!
    
    
    // MARK: - View Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the errorLabel to invisible
        errorLabel.alpha = 0

        // Set the color of the back button to white for visibility
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        password1Field.delegate = self
        password2Field.delegate = self
        
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Handlers
    
    @IBAction func signUpButtonHandler(_ sender: UIButton) {
        // Do some form validation before sending to the authentication server for sign up
        
        // Get the form fields' text and check if empty
        guard let firstName = firstNameField.text,
              !firstName.isEmpty,
              let lastName = lastNameField.text,
              !lastName.isEmpty,
              let email = emailAddrField.text,
              !email.isEmpty,
              let password1 = password1Field.text,
              !password1.isEmpty,
              let password2 = password2Field.text,
              !password2.isEmpty
            else {
                // add code to highlight password field(s) that's empty
                return
            }
        
        if !formValidation.isEmailFormatted(emailField: email) {
            // show error and highlight email field
            #warning("add code to show email isn't formatted")
            print("email is formatted wrong")
            return
        } else if !formValidation.doPasswordsMatch(password1: password1, password2: password2) {
            #warning("add code to show passwords don't match")
            print("passwords don't match")
            return
        }
        
        #warning("add unwind segue here back to log in controller")
    }
}

