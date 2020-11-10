//
//  SleepViewModel.swift
//  babytracker
//
//  Created by Ai-Lyn Tang on 24/10/20.
//  Copyright © 2020 WhimLyn. All rights reserved.
//

import UIKit
import SQLite3

struct SleepViewModel {
    
    // MARK: - Properties
    
    let buttonTitleAttributes: [NSAttributedString.Key : Any] =
        [NSAttributedString.Key.foregroundColor: UIColor.black,
         NSAttributedString.Key.underlineColor: UIColor.customCyan,
         NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
    
    private let database: DatabaseManager = DatabaseManager()
    
    // MARK: - Methods
    
    func save(start: Date?, end: Date?) {
        guard let start = start, let end = end else {
            fatalError("Programmer error: Unable to save sleep session. Missing the start or end date")
        }
        
        database.createTable()
        database.insert(start: Int(start.timeIntervalSince1970),
                        end: Int(end.timeIntervalSince1970))
    }
    
    func clearSleepTable() {
        database.deleteAllRows()
    }
}

struct SleepSession {
    let start: Int
    let end: Int
}
