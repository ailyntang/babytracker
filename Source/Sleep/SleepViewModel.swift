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
    
    func save() {
        database.createTable()
        database.insert(id: 1, start: 2, end: 3)
        database.insert(id: 11, start: 21, end: 31)
        let sleepSessions = database.read()
        print(sleepSessions)
    }
}

struct SleepSession {
    let id: Int
    let start: Int
    let end: Int
}
