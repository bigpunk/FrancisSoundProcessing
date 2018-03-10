//
//  ViewController.swift
//  FrancisSoundProcessing
//
//  Created by rob on 10/23/17.
//  Copyright © 2017 KarmaHound. All rights reserved.
//

import UIKit

import AudioKit
import AudioKitUI
import SwiftySound

class ViewController: UIViewController {

    @IBOutlet private var amplitudeLabel: UILabel!
        
    //var mic: AKMicrophone!
    var mic: AKStereoInput!
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    var amplitudeWindow = RollingWindow(windowSize: 100)
    
    var threshold: Double = 0.3
    var frequency: Int = 2
    var period: Int = 10
    var alerting: Bool = false
    
    let csvFile = "data"
    
    // record the time of event, sound amplitude, alert threshold,
    // frequency threshold, period and if alerting now.
    var amplitudePersistentRecord = "Epoch,Amplitude,Threshold,Frequency,Period,Alert\n"
    
    func appendAmplitudeRecord(amplitude : Double) {
        
        let epoch = Int(Date().timeIntervalSince1970 * 1000)
        
        let newLine = "\(epoch),\(amplitude),\(threshold),\(frequency),\(period),\(alerting)\n"
        
        amplitudePersistentRecord.append(newLine)
    }
    
    func writeAmplitudeCSVFile(file:String) {
       /*
        let fileDir = try! FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: true)
        
        let file = fileDir.appendingPathComponent(csvFile)

        do {
            try csvFile.write(to: file, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create file")
        }
        */
        var fileName = file + ".csv"
        
        if let filePath = Bundle.main.path(forResource: file, ofType: "csv") {
            fileName = filePath
        } else {
            fileName = Bundle.main.bundlePath + "/" + fileName
        }
        
        do {
            try amplitudePersistentRecord.write(toFile: fileName, atomically: true, encoding: String.Encoding.utf8)
            print("wrote file: ", fileName)
        } catch {
            print("...failed to write file")
        }
    }
    
    func readDataFromFile(file:String) -> String! {
        if let filepath = Bundle.main.path(forResource: file, ofType: "csv") {
            print("Got it!!! filepath: ", filepath)
            
            do {
                let contents = try String(contentsOfFile: filepath)
                print("  GOT CONTENTS: ")
                print(contents)
                return contents
            } catch {
                print("File Read Error for: \(filepath) ")
                return nil
            }
            
        } else {
            print("...failed to get filepath file: ", file)
            print(Bundle.main.path(forResource: file, ofType: nil) as Any)
            print(".....blah")
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AKSettings.audioInputEnabled = true
        //mic = AKMicrophone()
        mic = AKStereoInput()
        tracker = AKFrequencyTracker(mic)
        silence = AKBooster(tracker, gain: 0)
        
        print("....done view did load.")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AudioKit.output = silence
        AudioKit.start()
        
        // setup timer to periodically call updateUI()
        
        amplitudeLabel.text = "started"
        print("In view did appear!!!")
        Timer.scheduledTimer(timeInterval: 0.1,
                             target: self,
                             selector: #selector(ViewController.updateUI),
                             userInfo: nil,
                             repeats: true)
    }
    
    @objc func updateUI() {
        print("in timer!!")

        amplitudeWindow.updateRollingWindow(val: tracker.amplitude)
        amplitudeLabel.text = String(format: "%0.2f", tracker.amplitude)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showMessage() {
        let engageController = UIAlertController(title: "Enage", message: "Listening is engaged", preferredStyle: UIAlertControllerStyle.alert)
        
        engageController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
                
        present(engageController, animated: true, completion: nil)
    }
    
    @IBAction func toggleSound() {
        print("toggling sound!!")
        
        if let filepath = Bundle.main.path(forResource: "robeep", ofType: "m4a") {
            print("Got Beep!!! filepath: ", filepath)
        } else {
            print("...failed to get filepath file: ", "robeep")
        }

        Sound.play(file: "robeep.m4a")
        
        if (!alerting) {
            alerting = true
        } else {
            alerting = false
        }
        
        writeAmplitudeCSVFile(file: csvFile)
        print("All files: ")
        if let files = try? FileManager.default.contentsOfDirectory(atPath: Bundle.main.bundlePath ){
            for file in files {
                print(file)
            }
        }
        //print("...")
        //let cont = readDataFromFile(file: csvFile) //"amplitudeRecords")
        // print(cont)
    }
    
    @IBAction func emailCSVData() {
        
    }
}

