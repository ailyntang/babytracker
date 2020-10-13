//
//  SleepViewController.swift
//  babytracker
//
//  Created by Ai-Lyn Tang on 19/9/20.
//  Copyright © 2020 WhimLyn. All rights reserved.
//

import UIKit

protocol TimePickerViewControllerDelegate: AnyObject {
    func dismiss()
}

final class SleepViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var startTimeButton: UIButton!
    @IBOutlet private weak var endTimeButton: UIButton!
    
    // MARK: - Properties
    
    private var startTimePicker: TimePickerViewController?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add a sleep session"
    }
    
    // MARK: - Actions
    
    @IBAction func tapStartTimeButton(_ sender: UIButton) {
        
        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        startTimePicker = TimePickerViewController(nibName: "TimePickerViewController", bundle: nil)
        startTimePicker?.delegate = self
        
        if let viewController = startTimePicker {
            viewController.modalPresentationStyle = .custom
            viewController.transitioningDelegate = self
            present(viewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func tapEndTimeButton(_ sender: UIButton) {
    }
}

extension SleepViewController: TimePickerViewControllerDelegate {
    
    func dismiss() {
        view.backgroundColor = UIColor.white.withAlphaComponent(1)
        dismiss(animated: true, completion: nil)
    }
}
extension SleepViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}

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
