//
//  SleepViewController.swift
//  babytracker
//
//  Created by Ai-Lyn Tang on 19/9/20.
//  Copyright © 2020 WhimLyn. All rights reserved.
//

import UIKit

// MARK: - SleepViewController

final class SleepViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var startTimeButton: UIButton!
    @IBOutlet private weak var endTimeButton: UIButton!
    
    // MARK: Properties
    
    private var timePicker: TimePicker = TimePicker()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add a sleep session"
        timePicker.delegate = self
    }
    
    // MARK: Actions
    
    @IBAction func tapStartTimeButton(_ sender: UIButton) {
        presentTimePicker(for: startTimeButton)
    }
    
    @IBAction func tapEndTimeButton(_ sender: UIButton) {
        presentTimePicker(for: endTimeButton)
    }
    
    private func presentTimePicker(for button: UIButton) {
        
        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        let timePickerViewController = UIViewController()
        timePickerViewController.view.addSubview(timePicker)
        timePickerViewController.view.backgroundColor = .white
        
        let title = button == startTimeButton ? "Start Time" : "End Time"
        timePicker.updateTitle(to: title)
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.topAnchor.constraint(equalTo: timePickerViewController.view.topAnchor).isActive = true
        timePicker.leadingAnchor.constraint(equalTo: timePickerViewController.view.leadingAnchor).isActive = true
        timePicker.trailingAnchor.constraint(equalTo: timePickerViewController.view.trailingAnchor).isActive = true
        timePicker.heightAnchor.constraint(equalTo: timePickerViewController.view.heightAnchor).isActive = true
        
        timePickerViewController.modalPresentationStyle = .custom
        timePickerViewController.transitioningDelegate = self
        self.present(timePickerViewController, animated: true, completion: nil)
    }
}

// MARK: - Conformance to TimePickerDelegate

extension SleepViewController: TimePickerDelegate {
    
    func cancel() {
        view.backgroundColor = UIColor.white.withAlphaComponent(1)
        dismiss(animated: true, completion: nil)
    }
    
    func save() {
        // Placeholder
    }
}

// MARK: - Conformance to UIViewControllerTransitioningDelegate

extension SleepViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - HalfSizePresentationController

final class HalfSizePresentationController: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        
        guard let containerView = containerView else {
            fatalError("Container view of presentation controller does not exist")
        }
        
        return CGRect(x: 0,
                      y: containerView.bounds.height - Layout.timePickerHeight,
                      width: containerView.bounds.width,
                      height: Layout.timePickerHeight)
    }
}
