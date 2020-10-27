//
//  Timeable.swift
//  babytracker
//
//  Created by Ai-Lyn Tang on 27/10/20.
//  Copyright © 2020 WhimLyn. All rights reserved.
//

import Foundation

protocol Timeable: AnyObject {
    var timer: Timer? { get }
    var seconds: Int { get set }
    var minutes: Int { get set }
    var hours: Int { get set }
    var shouldUpdateMinutes: Bool { get set }
    var shouldUpdateHours: Bool { get set }
    
    func startTimer()
    func stopTimer()
}

extension Timeable {

    func convertTimeComponentToString(_ timeComponent: Int) -> String {
        if timeComponent < 10 {
            return "0" + String(timeComponent)
        } else {
            return String(timeComponent)
        }
    }
    
    func updateTimeComponents(startDate: Date? = nil, endDate: Date? = nil) {
        
        switch (startDate, endDate) {
        case (.none, .none):
            updateSeconds()
            updateMinutes()
            updateHours()
            
        case (.some, .some):
            
            guard let startDate = startDate,
                let endDate = endDate,
                startDate < endDate else {
                    fatalError("Programmer error: unexpected inputs for start or end time")
            }
            
            let durationInSeconds: Int = Int(DateInterval(start: startDate, end: endDate).duration)
            seconds = durationInSeconds % 60
            
            let totalMinutes = durationInSeconds / 60
            minutes = totalMinutes % 60
            
            let totalHours = totalMinutes / 60
            hours = totalHours % 60
            
        default: return
        }
    }
}

private extension Timeable {
    
    func updateSeconds() {
        
        if seconds == 59 {
            shouldUpdateMinutes = true
            if minutes == 59 {
                shouldUpdateHours = true
            }
        }
        updateTimeComponent(&seconds)
    }
    
    func updateMinutes() {
        if shouldUpdateMinutes {
            updateTimeComponent(&minutes)
            shouldUpdateMinutes = false
        }
    }

    func updateHours() {
        if shouldUpdateHours {
            updateTimeComponent(&hours)
            shouldUpdateHours = false
        }
    }
    
    func updateTimeComponent(_ component: inout Int) {
        switch component {
        case 59: component = 0
        default: component += 1
        }
    }
}
