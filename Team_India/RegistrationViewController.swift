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
        
        if !formValidation.isEmailFormatted(emailField: email) {
            // show error and highlight email field
            showErrorMessage(message: "Email is not formatted properly.")
            return
        } else if !formValidation.doPasswordsMatch(password1: password1, password2: password2) {
            showErrorMessage(message: "Passwords do not match.")
            return
        } else if !formValidation.isPasswordComplex(password: password1) {
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
                    fireDB.collection("users").addDocument(data: [
                        "firstname": firstName,
                        "lastname": lastName,
                        "uid": result!.user.uid]) { dbError in
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
        
        // Change the root VC to the homeVC
        view.window?.rootViewController = homeVC
        view.window?.makeKeyAndVisible()
    }
}

