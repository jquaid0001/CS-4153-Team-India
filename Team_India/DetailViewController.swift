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
    @IBOutlet weak var startDatePicker: UIDatePicker!
    
    // The outlets to select the bar type
    @IBOutlet weak var selectBarButton: UIButton!
    @IBOutlet weak var selectLineButton: UIButton!
    
    
    // Array of focusSession tuples for graph display
    private var focusSessions: [(date: String, workingOn: String, time:(hours: Int, minutes: Int, seconds: Int ))] = []
    
    // The vars needed to create graphs
    lazy var barGraph: BarChartView = {
        let barChart = ChartMaker.makeBarChart()
        barChart.data = setBarGraphData(fromDate: startDatePicker.date, toDate: startDatePicker.date)
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

        // Get the data from Firestore
        getFirestoreData()
        
        // Show the bar graph as the default graph
        
        self.barGraph.rightAxis.enabled = false
        self.barGraph.frame = self.graphViewPlaceholder.frame
        self.view.addSubview(self.barGraph)

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
    
    func setBarGraphData(fromDate: Date, toDate: Date) -> BarChartData {
        // Get the number of days to display. Pass the from and to date to Calendar, grab the number of days
        //      from the result, then add 1 since we always want to include the start date.
        let numDays = (Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day!) + 1
        print(numDays)
        
        let filteredArray = [(date: "4/14/2022", workingOn: "setting up stuff", time:(4, 3, 2))]
        
        var entries: [[BarChartDataEntry]] = [[BarChartDataEntry]]()
        
        // Create BarCharDataEntry arrays inside of entries prior to populating with focusSessions
        for _ in 0..<numDays {
            entries.append([BarChartDataEntry]())
        }
        
        print(entries.count)
        // **FIXME** The method in which to pull data; here are two dataSets atm
        // Format [(date:String, time:(hours:Int, minutes: Int, seconds:Int ))]
        /*for x in 0..<7 {
            entries.append(BarChartDataEntry(x: Double(x), y: 5))
            entries2.append(BarChartDataEntry(x: Double(x), y: 10))
        }
       
        */
        
        var dataSets = [BarChartDataSet]()
        
        var labels: [String] = []
        for i in 1...entries.count {
            labels[i] = filteredArray[i].date
        }
        
        // Initialize the dataSets array with the needed number of BarCharDataSets
        for i in 1...numDays {
            dataSets[i] = BarChartDataSet(label: labels[i])
        }
        
        // Build each of the data sets with the entries
        for i in 1...entries.count {
            for entry in entries[i] {
                dataSets[i].append(entry)
            }
        }
        
        for entry in dataSets[1] {
            print(entry)
        }
        
        // Data set build
        //let set = BarChartDataSet(entries: entries[0], label: "Session 1")
        //let set2 = BarChartDataSet(entries: entries2[1], label: "Session 2")
        
        
        //set.setColor(UIColor(red: 0.0, green: 0.42, blue: 0.46, alpha: 1.0))  // **FIXME**
        //set2.setColor(UIColor(red: 0.75, green: 0.85, blue: 0.86, alpha: 1.0))
        
        let data = BarChartData(dataSets: dataSets)
        
        return data
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
