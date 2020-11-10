//
//  UIColor+Extensions.swift
//  babytracker
//
//  Created by Ai-Lyn Tang on 28/10/20.
//  Copyright © 2020 WhimLyn. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let customCyan = UIColor.fromRGBValues(red: 105, green: 207, blue: 231, alpha: 1)
    static let customGreen = UIColor.fromRGBValues(red: 138, green: 183, blue: 75, alpha: 1)
}

extension UIColor {
    
    static func fromRGBValues(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        let newRed = red / 255
        let newGreen = green / 255
        let newBlue = blue / 255
        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: alpha)
    }
}
