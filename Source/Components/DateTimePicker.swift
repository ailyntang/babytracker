//
//  DateTimePicker.swift
//  babytracker
//
//  Created by Ai-Lyn Tang on 27/9/20.
//  Copyright © 2020 WhimLyn. All rights reserved.
//

import UIKit

// MARK: - TimePickerDelegate

protocol DateTimePickerDelegate: AnyObject {
    func cancel()
    func save()
}

// MARK: - TimePicker

final class DateTimePicker: UIView {
    
    // MARK: Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    
    // MARK: Properties
    
    weak var delegate: DateTimePickerDelegate?
    var isStartTime: Bool = true
    
    // MARK: Initialisation
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {

        let bundle = Bundle.init(for: DateTimePicker.self)
        if let viewsToAdd = bundle.loadNibNamed(String(describing: Self.self), owner: self, options: nil),
            let contentView = viewsToAdd.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
    }
    
    // MARK: Methods
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        delegate?.cancel()
    }
    
    @IBAction func tapSaveButton(_ sender: UIButton) {
        delegate?.save()
    }
    
    func updateTitle(to title: String) {
        titleLabel.text = title
    }
}

// MARK: - Constants

enum Layout {
    static let timePickerHeight: CGFloat = 350.0
}
