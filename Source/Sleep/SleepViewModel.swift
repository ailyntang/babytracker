//
//  SleepViewModel.swift
//  babytracker
//
//  Created by Ai-Lyn Tang on 24/10/20.
//  Copyright © 2020 WhimLyn. All rights reserved.
//

import UIKit

struct SleepViewModel {
    
    let buttonTitleAttributes: [NSAttributedString.Key : Any] =
        [NSAttributedString.Key.foregroundColor: UIColor.black,
         NSAttributedString.Key.underlineColor: UIColor.black,
         NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
    
    func updateTimeComponent(_ component: inout Int) {
        switch component {
        case 59: component = 0
        default: component += 1
        }
    }
}
