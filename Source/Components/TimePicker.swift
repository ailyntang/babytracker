//
//  TimePicker.swift
//  babytracker
//
//  Created by Ai-Lyn Tang on 27/9/20.
//  Copyright © 2020 WhimLyn. All rights reserved.
//

import UIKit

final class TimePicker: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {

        let bundle = Bundle.init(for: TimePicker.self)
        if let viewsToAdd = bundle.loadNibNamed("TimePicker", owner: self, options: nil),
            let contentView = viewsToAdd.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
    }
}
