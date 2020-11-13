//
//  HomeViewModel.swift
//  babytracker
//
//  Created by Ai-Lyn Tang on 11/9/20.
//  Copyright © 2020 WhimLyn. All rights reserved.
//

import UIKit

final class HomeViewModel {
    
    // MARK: - Properties
    
    private let database = DatabaseManager()
    
    private(set) lazy var cellViewModels = [sleepingCellViewModel,
                                            feedingCellViewModel,
                                            diaperCellViewModel]
    
    private lazy var sleepingCellViewModel: HomeCellViewModel = {
        
        return HomeCellViewModel(icon: UIImage(named: "Moon"),
                                 titleLabel: "Sleeping",
                                 detailLabel: makeDetailLabel(for: Event.sleep),
                                 // detailLabel: "2h 38m - 3h 02m ago",
            durationLabel: "00:46:23",
            storyboardID: "Sleep")
    }()
    
    private let feedingCellViewModel = HomeCellViewModel(icon: UIImage(named: "Moon"),
                                                         titleLabel: "Feeding",
                                                         detailLabel: "(L) 0m, (R*) 3m - 1h 02m ago",
                                                         durationLabel: "00:06:23",
                                                         storyboardID: "Sleep")
    
    private let diaperCellViewModel = HomeCellViewModel(icon: UIImage(named: "Moon"),
                                                        titleLabel: "Diaper",
                                                        detailLabel: "Both - 0h 02m ago",
                                                        durationLabel: "",
                                                        storyboardID: "Sleep")
    
    // MARK: - Methods
    
    private func makeDetailLabel(for event: Event) -> String {
        let sleepSession: SleepSession? = database.readMostRecent()
        
        guard let start = sleepSession?.start, let end = sleepSession?.end else { return "" }
        
        let timeNow = Int(Date().timeIntervalSince1970)
        print("time now: " + String(timeNow))
        
        database.readAll()
        return convertSecondsIntoHHMMSS(input: timeNow - end)
        
    }
    
    
    private func convertSecondsIntoHHMMSS(input: Int) -> String {
        let seconds = input % 60
        
        let totalMinutes = input / 60
        let minutes = totalMinutes % 60
        
        let totalHours = totalMinutes / 60
        let hours = totalHours % 60
        
        return "\(hours):\(minutes):\(seconds)"
    }
}
