//
//  RegistrationViewController.swift
//  Team_India
//
//  Created by Josh Quaid on 3/4/22.
//

import UIKit
import FirebaseAuth
import Firebase

class RegistrationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailAddrField: UITextField!
    @IBOutlet weak var password1Field: PasswordTextField!
    @IBOutlet weak var password2Field: PasswordTextField!
    
    
    // MARK: - View Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the color of the back button to white for visibility
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        // Set the VC as the TextField delegate
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailAddrField.delegate = self
        password1Field.delegate = self
        password2Field.delegate = self

        
        // Set the LOG IN button's background color so it's visible even when disabled
        signUpButton.configuration?.background.backgroundColor = .systemBlue
        // Disable the LOG IN button until fields are populated
        signUpButton.isEnabled = false
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Observers
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        
        // If the password visibility is toggled on either password field, turn it off when user begins typing in any field
        if let password = password1Field.text,
           let password2 = password2Field.text {
            if !password.isEmpty || !password2.isEmpty {
                // If the password visibility is toggled, turn it off when user begins typing in any field again
                if !password1Field.isSecureTextEntry && !password.isEmpty {
                    password1Field.togglePassVis()
                }
                if !password2Field.isSecureTextEntry && !password2.isEmpty{
                    password2Field.togglePassVis()
                }
            } else {
                // No need to check if the fields are empty, just exit the DidChange just make sure log in is disabled
                signUpButton.isEnabled = false
                return
            }
        }
        
        // Get the fields and check if they are both not empty
        guard let firstName = firstNameField.text,
              !firstName.isEmpty,
              let lastName = lastNameField.text,
              !lastName.isEmpty,
              let email = emailAddrField.text,
              !email.isEmpty
        else {
            // If any fields becomes empty or is empty, make sure the LOG IN button is disabled
            signUpButton.isEnabled = false
            return
        }
        // If both fields contain data, enable the LOG IN button else, leave it disabled
        signUpButton.isEnabled = true

    }
    
    // MARK: - Handlers
    
    @IBAction func signUpButtonHandler(_ sender: UIButton) {
        // Do some form validation before sending to the authentication server for sign up
        
        // Get the form fields' text, trim the whitespace from first, last and email and check if empty
        guard let firstName = firstNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !firstName.isEmpty,
              let lastName = lastNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !lastName.isEmpty,
              let email = emailAddrField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !email.isEmpty,
              let password1 = password1Field.text,
              !password1.isEmpty,
              let password2 = password2Field.text,
              !password2.isEmpty
            else {
                showErrorMessage(message: "Please complete all fields.")
                return
            }
        
        if !FormValidationUtil.isEmailFormatted(emailField: email) {
            // show error and highlight email field
            showErrorMessage(message: "Email is not formatted properly.")
            return
        } else if !FormValidationUtil.doPasswordsMatch(password1: password1, password2: password2) {
            showErrorMessage(message: "Passwords do not match.")
            return
        } else if !FormValidationUtil.isPasswordComplex(password: password1) {
            showErrorMessage(message: "Password must meet complexity requirements: \n-8 characters long\n-1 upper case\n-1 lower case\n-1 special character (!@#$%^&*)")
            return
        } else {
            // Send the user registration to Firebase to create or error on duplicate
            Auth.auth().createUser(withEmail: email, password: password1) { result, error in
                
                // Check for any errors
                if error != nil {
                    self.showErrorMessage(message: error?.localizedDescription ?? "Error creating user, please contact support.")
                } else {
                    // User creation successfull, save the first and last name in the Firestore DB and then unwind back to Log In View may want to retry on failure.
                    let fireDB = Firestore.firestore()
                    fireDB.collection("users").document(result!.user.uid).setData([
                        "uid": result!.user.uid,
                        "firstname": firstName,
                        "lastname": lastName,
                        "email": email]) { dbError in
                            if dbError != nil {
                                self.showErrorMessage(message: "Failed to store DB info, please contact support.")
                                print("Saving user to DB failed for reason: \(dbError?.localizedDescription ?? "Unknown DB save error, plese contact support.")")
                            }
                    }
                    
                    // User is registered, send them to the Home View Controller
                    self.goToHome()
                }
            }
        }
        
    }
    
    
    // MARK: - Funcs
    
    // Keyboard flow control for textFields
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Transfer control to the next field in line as the user uses the "return" key
        switch textField {
        case firstNameField:
            lastNameField.becomeFirstResponder()
            return true
        case lastNameField:
            emailAddrField.becomeFirstResponder()
            return true
        case emailAddrField:
            password1Field.becomeFirstResponder()
            return true
        case password1Field:
            password2Field.becomeFirstResponder()
            return true
        case password2Field:
            if signUpButton.isEnabled == true {
                // Close the keyboard
                password2Field.resignFirstResponder()
                // Simulate the LOG IN button press if the done button is pressed on the keyboard
                self.signUpButtonHandler(signUpButton)
                return true
            } else {
                return false
            }
        default:
            showErrorMessage(message: "Please complete the missing fields.")
            return false
        }
    }
    
    // Shows error messages in an AlertController
    func showErrorMessage(message : String) {
        // Show an AlertController
        let alertController = UIAlertController(title: "Error Registering User",
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
            showErrorMessage(message: "Unable to log in, please try again.")
            return
        }
        
        // Set up the navigation bar for the HomeViewController to
        //     show "logout"
        let backBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
        // Change the root VC to the homeVC
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
}

