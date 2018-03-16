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
    @IBOutlet private var amplitudeThresholdTextField: UITextField!
    @IBOutlet weak var lookbackMsTextField: UITextField!
    @IBOutlet weak var countAboveThresholdTextField: UITextField!
    
    //var mic: AKMicrophone!
    var mic: AKStereoInput!
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    var soundOn: Bool = false
    var amplitudeHistory = RollingWindow(windowSize: 100)
    let intervalLength = 0.3
    let alarmLength = 4.2
    var alarmLeft: Double = 0.0
    
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
        Timer.scheduledTimer(timeInterval: intervalLength,
                             target: self,
                             selector: #selector(ViewController.updateUI),
                             userInfo: nil,
                             repeats: true)
    }
    
    @objc func updateUI() {
        
        //var thres: Double = 0.0
        
        print("in timer!!")

        let amplitudeThreshold = Double(amplitudeThresholdTextField.text ?? "") ?? 0.05
        let lookbackMs = Int(lookbackMsTextField.text ?? "") ?? 7
        let countAboveThreshold = Int(countAboveThresholdTextField.text ?? "") ?? 5
        
        print("Hello thres: \(amplitudeThreshold) lookbackMs: \(lookbackMs) countAboveThreshold: \(countAboveThreshold) alarmLeft: \(alarmLeft)")
        
        amplitudeHistory.updateRollingWindow(val: tracker.amplitude)
        amplitudeLabel.text = String(format: "%0.2f", tracker.amplitude)
        
        let hist = amplitudeHistory.rollingWindowExtract(lookback: lookbackMs)
        
        var aboveCount: Int = 0
        
        for i in stride(from: 0, to: lookbackMs, by:1) {
            if hist[i] > amplitudeThreshold {
                aboveCount += 1
            }
        }
        
        print("......above count: \(aboveCount)")
        
        if (aboveCount > countAboveThreshold && alarmLeft <= 0.0) {
            toggleSound()
            alarmLeft = alarmLength
        } else if (alarmLeft > 0.0) {
            print("!!!!!!!!!!SOUND ON!!!!!!!!!!!!!!")
            alarmLeft -= intervalLength
        }
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

//Sound.play(file: "robeep.m4a")
        
        if (!soundOn) {
            soundOn = true
        } else {
            soundOn = false
        }
    }
}

