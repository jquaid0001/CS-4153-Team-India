//
//  DetailViewController.swift
//  Team_India
//
//  Created by Josh Quaid on 3/4/22.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {

    // Array of focusSession tuples for graph display
    private var focusSessions: [(date:String, time:(hours:Int, minutes: Int, seconds:Int ))] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Get the data from Firestore
        getFirestoreData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Check for data
        for session in focusSessions {
            print(session)
        }
    }
    
    
    // Gets the user's focusSession from the Firestore DB
    private func getFirestoreData() {
        
        print("getting data from firestore")
        
        // Get a reference to the Firestore DB
        let firestoreDB = Firestore.firestore()
        // Get the currently signed in user
        let user = Auth.auth().currentUser
        
        // make sure the user is signed in before trying to access the user information and store to the DB
        if let user = user {
            // Write the focusSession to Firestore
            // Get the collection of focusSessions from the Firestore DB, then populate the focusSessions array for graph display
            firestoreDB.collection("users").document(user.uid).collection("focusSessions").getDocuments { dbCollection, error in
                print("in the getDocuments closure")
                // Check if any errors in get
                if error == nil {
                    // unwrap the dbCollectioon returned from Firestore and append each session to the focusSession array
                    if let dbCollection = dbCollection {
                        // Put this in the main queue since it's UI related
                        DispatchQueue.main.async {
                            // Populate the array from the document collection
                            for session in dbCollection.documents {
                                self.focusSessions.append((date: session.get("date") as! String, time: (hours: session.get("timeHours") as! Int, minutes: session.get("timeMinutes") as! Int, seconds: session.get("timeSeconds") as! Int)))
                            }
                        }
                    }
                } else {
                    // Deal with the error
                    print("Error retrieving focusSession: \(error)")
                }
            }
        } else {
            print("user is not signed in")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
