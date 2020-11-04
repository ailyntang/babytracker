//
//  ErrorMessageView.swift
//  babytracker
//
//  Created by Ai-Lyn Tang on 1/11/20.
//  Copyright © 2020 WhimLyn. All rights reserved.
//

import UIKit

protocol ErrorMessageViewDelegate: AnyObject {
    func dismiss()
}

final class ErrorMessageView: UIView {
    
    // MARK: Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet private weak var primaryActionButton: UIButton!
    @IBOutlet private weak var lineView: UIView!
    
    // MARK: Properties
    
    weak var delegate: ErrorMessageViewDelegate?
    
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
        let bundle = Bundle.init(for: ErrorMessageView.self)
        if let viewsToAdd = bundle.loadNibNamed(String(describing: Self.self), owner: self, options: nil),
           let contentView = viewsToAdd.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
    }
    
    // MARK: Methods
    
    @IBAction func tapPrimaryActionButton(_ sender: UIButton) {
        delegate?.dismiss()
    }
    
    func updateMessage(to message: String) {
        titleLabel.text = message
    }
}
