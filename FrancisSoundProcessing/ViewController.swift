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

class ViewController: UIViewController {

    @IBOutlet private var amplitudeLabel: UILabel!
    @IBOutlet private var amplitudeThresholdTextField: UITextField!
    @IBOutlet weak var lookbackMsTextField: UITextField!
    @IBOutlet weak var countAboveThresholdTextField: UITextField!
    
    var mic: AKMicrophone!
    var oscillator: AKOscillator!
    var tracker: AKFrequencyTracker!
    var micBooster: AKBooster!
    var mainMixer: AKMixer!
    var amplitudeHistory = RollingWindow(windowSize: 100)
    let intervalLength = 0.3
    let alarmLength = 4.2
    var alarmLeft: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AKAudioFile.cleanTempDirectory()
        
        AKSettings.bufferLength = .medium
        
        do {
            try AKSettings.setSession(category: .playAndRecord, with: .allowBluetoothA2DP)
        } catch {
            print("FAILED to set playAndRecord Session")
        }
        
        AKSettings.defaultToSpeaker = true
        
        AKSettings.audioInputEnabled = true
        mic = AKMicrophone()
        
        oscillator = AKOscillator()
        oscillator.frequency = 500
        oscillator.amplitude = 4.0
        
        tracker = AKFrequencyTracker(mic)
        micBooster = AKBooster(tracker, gain: 0)
        
        // The mixer allows both listening and playing sounds.
        mainMixer = AKMixer(oscillator, micBooster)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AudioKit.output = mainMixer
        try! AudioKit.start()
        
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
        
        let amplitudeThreshold = Double(amplitudeThresholdTextField.text ?? "") ?? 0.05
        let lookbackMs = Int(lookbackMsTextField.text ?? "") ?? 7
        let countAboveThreshold = Int(countAboveThresholdTextField.text ?? "") ?? 5
        
        print("Threshold: \(amplitudeThreshold) lookbackMs: \(lookbackMs) countAboveThreshold: \(countAboveThreshold) alarmLeft: \(alarmLeft), amp: \(tracker.amplitude)")
        
        amplitudeHistory.updateRollingWindow(val: tracker.amplitude)
        amplitudeLabel.text = String(format: "%0.2f", tracker.amplitude)
        
        let hist = amplitudeHistory.rollingWindowExtract(lookback: lookbackMs)
        
        var aboveCount: Int = 0
        
        for i in stride(from: 0, to: lookbackMs, by:1) {
            if hist[i] > amplitudeThreshold {
                aboveCount += 1
            }
        }
        
        if (aboveCount > countAboveThreshold && alarmLeft <= 0.0) {
            toggleSound()
            alarmLeft = alarmLength
        } else if (alarmLeft > 0.0) {
            alarmLeft -= intervalLength
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showMessage() {
        let engageController = UIAlertController(title: "Enage", message: "Listening is engaged", preferredStyle: UIAlertController.Style.alert)
        
        engageController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:nil))
                
        present(engageController, animated: true, completion: nil)
    }
    
    @IBAction func toggleSound() {
        
        if (!oscillator.isPlaying) {
            oscillator.start()
        } else {
            oscillator.stop()
        }
    }
    
    // Displays Audio Inputs and Outputs Routes for debugging purposes.
    func displayAudioRoutes() {
        let session = AVAudioSession.sharedInstance()
        
        for output in session.currentRoute.outputs {
            print("   Output: \(output)")
        }
        
        for input in session.currentRoute.inputs {
            print("     Input: \(input)")
        }
    }
}
