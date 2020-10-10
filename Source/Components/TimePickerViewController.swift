//
//  TimePickerViewController.swift
//  babytracker
//
//  Created by Ai-Lyn Tang on 28/9/20.
//  Copyright © 2020 WhimLyn. All rights reserved.
//

import UIKit

final class TimePickerViewController: UIViewController {
    
    private lazy var myLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello there moopie moopie moopie so lots of lines"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    override func loadView() {
        view = UIView()
        view.addSubview(myLabel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        setConstraints()
    }
    
    private func setConstraints() {
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        myLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 400).isActive = true
        myLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        myLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
