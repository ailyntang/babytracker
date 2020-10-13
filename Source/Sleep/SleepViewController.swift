//
//  SleepViewController.swift
//  babytracker
//
//  Created by Ai-Lyn Tang on 19/9/20.
//  Copyright © 2020 WhimLyn. All rights reserved.
//

import UIKit

// MARK: - TimePickerViewControllerDelegate

protocol TimePickerViewControllerDelegate: AnyObject {
    func dismiss()
}

// MARK: - SleepViewController

final class SleepViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var startTimeButton: UIButton!
    @IBOutlet private weak var endTimeButton: UIButton!
    
    // MARK: Properties
    
    private var startTimePicker: TimePickerViewController?
    private var endTimePicker: TimePickerViewController?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add a sleep session"
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
        var timePickerViewController: TimePickerViewController?
        
        if button == endTimeButton, endTimePicker == nil {
            endTimePicker = TimePickerViewController(nibName: "TimePickerViewController", bundle: nil)
            endTimePicker?.delegate = self
            timePickerViewController = endTimePicker
            
        } else if button == startTimeButton, startTimePicker == nil {
            startTimePicker = TimePickerViewController(nibName: "TimePickerViewController", bundle: nil)
            startTimePicker?.delegate = self
            timePickerViewController = startTimePicker
        }
        
        guard let viewController = timePickerViewController else {fatalError()}
        
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        present(viewController, animated: true, completion: nil)
    }
}

// MARK: - Conformance to TimePickerViewControllerDelegate

extension SleepViewController: TimePickerViewControllerDelegate {
    
    func dismiss() {
        view.backgroundColor = UIColor.white.withAlphaComponent(1)
        dismiss(animated: true, completion: nil)
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
