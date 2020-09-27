//
//  TimePicker.swift
//  babytracker
//
//  Created by Ai-Lyn Tang on 27/9/20.
//  Copyright © 2020 WhimLyn. All rights reserved.
//

import UIKit

final class TimePicker: UIView {
    
    @IBOutlet var customView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("TimePicker", owner: self, options: nil)
        print("yup")
        customView.backgroundColor = .blue
        titleLabel.text = "YOYOYO"
    }
    
}
