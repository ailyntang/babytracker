//
//  HomeViewModel.swift
//  babytracker
//
//  Created by Ai-Lyn Tang on 11/9/20.
//  Copyright © 2020 WhimLyn. All rights reserved.
//

import UIKit

struct HomeViewModel {
    
    private(set) lazy var cellViewModels = [sleepingCellViewModel,
                                            feedingCellViewModel,
                                            diaperCellViewModel]
    
    private let sleepingCellViewModel = HomeCellViewModel(icon: UIImage(named: "Moon"),
                                                          titleLabel: "Sleeping",
                                                          detailLabel: "2h 38m - 3h 02m ago",
                                                          durationLabel: "00:46:23",
                                                          viewController: SleepViewController())
    
    private let feedingCellViewModel = HomeCellViewModel(icon: UIImage(named: "Moon"),
                                                         titleLabel: "Feeding",
                                                         detailLabel: "(L) 0m, (R*) 3m - 1h 02m ago",
                                                         durationLabel: "00:06:23",
                                                         viewController: SleepViewController())
    
    private let diaperCellViewModel = HomeCellViewModel(icon: UIImage(named: "Moon"),
                                                        titleLabel: "Diaper",
                                                        detailLabel: "Both - 0h 02m ago",
                                                        durationLabel: "",
                                                        viewController: SleepViewController())
}
