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
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailAddrField: UITextField!
    @IBOutlet weak var password1Field: UITextField!
    @IBOutlet weak var password2Field: UITextField!
    
    
    // MARK: - View Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
              let lastName = lastNameField.text,
              let email = emailAddrField.text,
              let password1 = password1Field.text,
              let password2 = password2Field.text,
              !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && !password1.isEmpty && !password2.isEmpty else {
                  // add code to highlight password field(s) that's empty
                  return
              }
        
        #warning("add code to check email addr format")
        
        // Edit to either display highlighted password field(s) that don't match, or error on screen or both
        print(formValidation.doPasswordsMatch(password1: password1, password2: password2))
    }
}

