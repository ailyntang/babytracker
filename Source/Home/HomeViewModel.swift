//
//  HomeViewModel.swift
//  babytracker
//
//  Created by Ai-Lyn Tang on 11/9/20.
//  Copyright © 2020 WhimLyn. All rights reserved.
//

import Foundation

struct HomeViewModel {
    
    private(set) lazy var cellViewModels = [sleepingCellViewModel]
    
    private let sleepingCellViewModel = HomeCellViewModel(titleLabel: "Sleeping",
                                                          detailLabel: "2h 38m - 3h 02m ago",
                                                          durationLabel: "00:46:23")
}
