//
//  TimePicker.swift
//  babytracker
//
//  Created by Empower on 27/9/20.
//  Copyright © 2020 WhimLyn. All rights reserved.
//

import UIKit

final class TimePickerViewController: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        view.backgroundColor = .systemPink
        
        let customView = TimePicker()
        view.addSubview(customView)
        customView.backgroundColor = .blue
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        customView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        customView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        customView.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
