//
//  RollingWindow.swift
//  FrancisSoundProcessing
//
//  Created by rob on 11/11/17.
//  Copyright © 2017 KarmaHound. All rights reserved.
//

import Foundation

class RollingWindow {
    
    var index: Int = 0
    var rollingWindowSize: Int
    var rollingWindow: Array<Double>
    
    init(windowSize: Int) {
        rollingWindowSize = windowSize
        rollingWindow = Array(repeating: 0.0, count: rollingWindowSize)
    }
    
    func updateRollingWindow(val : Double) {
        rollingWindow[index] = val
        
        index += 1
        
        if index >= rollingWindowSize {
            index = 0
        }
    }
    
    func rollingWindowExtract(lookback : Int) -> Array<Double> {
        var ret = Array(repeating: 0.0, count: lookback)
        
        for i in stride(from: 0, to: lookback, by: 1) {
            var idx = index - i - 1
            if idx < 0 {
                idx = rollingWindowSize + idx // since index is negative add it.
            }
            
            ret[i] = rollingWindow[idx]
        }
        
        return ret
    }
}
