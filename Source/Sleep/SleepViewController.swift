//
//  SleepViewController.swift
//  babytracker
//
//  Created by Ai-Lyn Tang on 19/9/20.
//  Copyright © 2020 WhimLyn. All rights reserved.
//

import UIKit

final class SleepViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var startTimeButton: UIButton!
    @IBOutlet private weak var endTimeButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add a sleep session"
    }
    
    // MARK: - Actions
    
    @IBAction func tapStartTimeButton(_ sender: UIButton) {

        let viewController = TimePickerViewController()
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func tapEndTimeButton(_ sender: UIButton) {
    }
    
}
