//
//  ErrorMessage.swift
//  babytracker
//
//  Created by Ai-Lyn Tang on 1/11/20.
//  Copyright © 2020 WhimLyn. All rights reserved.
//

import UIKit

final class ErrorMessage: UIView {
    
    // MARK: Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet private weak var primaryActionButton: UIButton!
    
    // MARK: Methods
    
    @IBAction func tapPrimaryActionButton(_ sender: UIButton) {
    }
}
