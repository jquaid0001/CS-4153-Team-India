//
//  HomeViewController.swift
//  Team_India
//
//  Created by Josh Quaid on 3/4/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    // keep track of all focus sessions (Date, Time)
    var focusSessions: [(String, Float)] = []
    
    // Outlets to communicate with the timer elements on the screen
    @IBOutlet weak var timerDisplay: UILabel!
    @IBOutlet weak var hoursInput: UITextField!
    @IBOutlet weak var minutesInput: UITextField!
    @IBOutlet weak var secondsInput: UITextField!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    // the timer running on the screen
    var timer:Timer = Timer()
    // the time for which the timer will be runnning
    var count:Int = 0
    // stores whether the timer is ongoing or not
    var isTimerRunning:Bool = false
    // use this to allow user to set time of focus session
    var timeLeft:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        #warning("remove back button and show Logout in top right")
        // change the color of the start button to green
        startStopButton.setTitleColor(UIColor.green, for: .normal)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    
    @IBAction func startStopTapped(_ sender: Any) {
        // if the timer is running at the moment
        if isTimerRunning {
            // stop the timer
            timer.invalidate()
            
            // TODO: change the value of the text field whenever
            // user pauses timer mid way
            // TODO: update the time spent area every second
            
            // reflect the state of the timer in the boolean variable
            isTimerRunning = false
            // change the color back to green
            startStopButton.setTitleColor(UIColor.green, for: .normal)
            // change the text of the button back to START
            startStopButton.setTitle("START", for: .normal)
        }
        
        else {
            // change the boolean value to reflect the running timer
            isTimerRunning = true
            // change the text of the button
            startStopButton.setTitle("STOP", for: .normal)
            // change the color of the button to red while timer is running
            startStopButton.setTitleColor(UIColor.red, for: .normal)
            
            // reset the contents of the count variable whenever the start
            // button is clicked
            count = 0
            count += Int(hoursInput.text!)! * 3600
            count += Int(minutesInput.text!)! * 60
            count += Int(secondsInput.text!)!
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeCounter), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Reset Timer?", message: "Are you sure you want to reset the timer?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            // do nothing
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            self.count = 0
            self.timer.invalidate()
            // set the current text in the label to all zeroes
            self.timerDisplay.text = self.convertTimeToString(hours: 0, minutes: 0, seconds: 0)
            // change the color back to green
            self.startStopButton.setTitleColor(UIColor.green, for: .normal)
            // change the text of the button back to START
            self.startStopButton.setTitle("START", for: .normal)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func userTimeInput(_ sender: Any) {
        let hours: String = hoursInput.text!
        let minutes: String = minutesInput.text!
        let seconds: String = secondsInput.text!
        
        // reset the value of the counter if new input is registered
        count = 0
        
        // check if input can be converted to an int
        // conver the integer to the huor equivalent in seconds
        if let hrs = Int(hours) {
            count += hrs * 3600
        }
        
        if let mins = Int(minutes) {
            count += mins * 60
        }
        
        if let secs = Int(seconds) {
            count += secs
        }
    }
    
    
    @objc func timeCounter() -> Void {
        count = count - 1
        // pass the count value to the function to break up into time displayed
        let currTime = convertToHrsMinsSecs(seconds: count)
        let currTimeString = convertTimeToString(hours: currTime.0, minutes: currTime.1, seconds: currTime.2)
        timerDisplay.text = currTimeString
        
        // check if the timer is done
        if count == 0 {
            // stop the timer when it gets to zero
            timer.invalidate()
            
            // send an alert to the user
            let alert = UIAlertController(title: "Focus session finished", message: "Time to take a break!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (_) in
                // do nothing
            }))
            self.present(alert, animated: true, completion: nil)
            
            // store the current date
            let currDate = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .short, timeStyle: .none)
            // store the current inputs of the textFields (asuming this is the timer that just finished)
            // convert into hours equivalent for simplicity in graphing
            var totalTime = Float(hoursInput.text!)! * 3600
            totalTime += Float(minutesInput.text!)! * 60
            totalTime += Float(secondsInput.text!)!
            totalTime = Float(totalTime/3600)
            
            focusSessions.append((String(currDate), totalTime))
        }
    }
    
    func convertToHrsMinsSecs(seconds: Int) -> (Int, Int, Int) {
        return ((seconds / 3600), ((seconds % 3600)/60), ((seconds % 3600)%60))
    }
    
    func convertTimeToString(hours: Int, minutes:Int, seconds:Int) -> String {
        // holds the final result of the time conversion
        var answer = ""
        answer += String(format: "0%2d", hours)
        answer += " : "
        answer += String(format: "0%2d", minutes)
        answer += " : "
        answer += String(format: "0%2d", seconds)
        
        return answer
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
