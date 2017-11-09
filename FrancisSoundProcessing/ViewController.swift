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
    var soundOn: Bool = false
    
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

        Sound.play(file: "robeep.m4a")
        
        if (!soundOn) {
            soundOn = true
        } else {
            soundOn = false
        }
    }
}

