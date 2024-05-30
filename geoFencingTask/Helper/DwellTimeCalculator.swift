//
//  DwellTimeCalculator.swift
//  geoFencingTask
//
//  Created by Aitazaz on 29/05/2024.
//

import Foundation

class DwellTimeCalculator {
    private var startTime: Date?
    private var exitTime: Date?
    
    // Method to set the start time
    func setStartTime(_ startTime: Date) -> String {
        self.startTime = startTime
        let msg = "Entered geofence area at \(startTime)."
        return msg
    }
    
    // Method to set the exit time
    func setExitTime(_ exitTime: Date) -> String {
        self.exitTime = exitTime
        var msg = "Exited geofence area at \(exitTime). "
        
        if let dwellTime = calculateDwellTime() {
            let msg2 = "Dwell Time: \(dwellTime) seconds"
            msg += msg2
            return msg
        } else {
            let msg2 = "Start time not set."
            msg += msg2
            return msg
        }
    }
    
    // Method to calculate the dwell time in seconds
    private func calculateDwellTime() -> TimeInterval? {
        guard let start = startTime, let exit = exitTime else {
            return nil // Return nil if either time is not set
        }
        return exit.timeIntervalSince(start)
    }
}
