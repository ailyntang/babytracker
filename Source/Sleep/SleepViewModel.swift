//
//  SleepViewModel.swift
//  babytracker
//
//  Created by Ai-Lyn Tang on 24/10/20.
//  Copyright © 2020 WhimLyn. All rights reserved.
//

import UIKit

struct SleepViewModel {
    
    // MARK: - Properties
    
    let buttonTitleAttributes: [NSAttributedString.Key : Any] =
        [NSAttributedString.Key.foregroundColor: UIColor.black,
         NSAttributedString.Key.underlineColor: UIColor.customCyan,
         NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
    
    private let maximumTimeInterval: Int = 24 * 60 * 60 // 24 hours
    
    // MARK: - Methods
    
    func isValidDate(startDate: Date?, endDate: Date?) -> Bool {
        
        if let startDate = startDate,
            let endDate = endDate,
            startDate > endDate {
            return false
        }
        
        if let startDate = startDate,
            let endDate = endDate {
            let timeInterval = Int(DateInterval(start: startDate, end: endDate).duration)
            return timeInterval < maximumTimeInterval
        }
        
        return true
    }
}
