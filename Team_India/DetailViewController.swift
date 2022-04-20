//
//  DetailViewController.swift
//  Team_India
//
//  Created by Josh Quaid on 3/4/22.
//

import UIKit
import Firebase
import Charts

class DetailViewController: UIViewController {

    // The outlet for the position of the graph view
    @IBOutlet weak var graphViewPlaceholder: UIImageView!
    
    // The outlets to select the bar type
    @IBOutlet weak var selectBarButton: UIButton!
    @IBOutlet weak var selectLineButton: UIButton!
    
    
    // Array of focusSession tuples for graph display
    private var focusSessions: [(date: String, workingOn: String, time:(hours: Int, minutes: Int, seconds: Int ))] = []
    
    // The vars needed to create graphs
    lazy var barGraph: BarChartView = {
        let barChart = ChartMaker.makeBarChart()
        return barChart
    }()
    
    lazy var lineGraph: LineChartView = {
        let lineChart = ChartMaker.makeLineChart()
        return lineChart
    }()
    
    // MARK: - View Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Set the color of the logout button to white for visibility
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        print(graphViewPlaceholder.frame)
        // Get the data from Firestore
        getFirestoreData()
        
        // Show the bar graph as the default graph
        
        self.barGraph.rightAxis.enabled = false
        self.barGraph.frame = self.graphViewPlaceholder.frame
        self.view.addSubview(self.barGraph)
        print(barGraph.frame)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    // MARK: - Handlers
    
    @IBAction func barTypeButtonHandler(_ sender: UIButton) {
        
        // Handle the button taps to select a graph type
        switch sender {
        case selectBarButton:
            // Show the bar graph
            DispatchQueue.main.async {
                // Remove the lineGraph from the view
                self.lineGraph.removeFromSuperview()
                // Add the barGraph to the view
                self.view.addSubview(self.barGraph)
                self.barGraph.rightAxis.enabled = false
                self.barGraph.frame = self.barGraph.frame
                // Reanimate the graph
                self.barGraph.animate(xAxisDuration: 2.5)
            }
        case selectLineButton:
            // Show the line graph
            DispatchQueue.main.async {
                // Remove the barGraph from the view
                self.barGraph.removeFromSuperview()
                // Add the lineGraph to the view
                self.view.addSubview(self.lineGraph)
                self.lineGraph.rightAxis.enabled = false
                self.lineGraph.frame = self.barGraph.frame
                // Reanimate the graph
                self.lineGraph.animate(xAxisDuration: 2.5)
            }
        default:
            // Do nothing
            return
        }
        
    }
    
    
    
    // MARK: - Funcs
    
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
                // Check if any errors in get
                if error == nil {
                    // unwrap the dbCollectioon returned from Firestore and append each session to the focusSession array
                    if let dbCollection = dbCollection {
                        // Put this in the main queue since it's UI related
                        DispatchQueue.main.async {
                            // Populate the array from the document collection
                            for session in dbCollection.documents {
                                self.focusSessions.append((date: session.get("date") as! String, workingOn: session.get("workingOn") as! String, time: (hours: session.get("timeHours") as! Int, minutes: session.get("timeMinutes") as! Int, seconds: session.get("timeSeconds") as! Int)))
                            }
                        }
                    }
                } else {
                    // Deal with the error
                    print("Error retrieving focusSession: \(String(describing: error))")
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
