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
    
    @IBOutlet private weak var selectStartTimeButton: UIButton!
    @IBOutlet private weak var selectEndTimeButton: UIButton!
    @IBOutlet private weak var startButton: UIButton!
    
    // MARK: Properties
    
    private var timePicker: TimePicker = TimePicker()
    private var timer: Timer? = nil
    private var seconds: Int = 0
    private var minutes: Int = 0
    private var hours: Int = 0
    private var shouldUpdateMinutes: Bool = false
    private var shouldUpdateHours: Bool = false
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add a sleep session"
        timePicker.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: Actions
    
    @IBAction func selectStartTime(_ sender: UIButton) {
        presentTimePicker(for: selectStartTimeButton)
    }
    
    @IBAction func selectEndTime(_ sender: UIButton) {
        presentTimePicker(for: selectEndTimeButton)
    }
    
    @IBAction func tapStartButton(_ sender: Any) {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            self.updateDuration()
        })
        timer?.tolerance = 0.2
    }
}

// MARK: - Private methods

private extension SleepViewController {
    
    func presentTimePicker(for button: UIButton) {
        
        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        let timePickerViewController = UIViewController()
        timePickerViewController.view.addSubview(timePicker)
        timePickerViewController.view.backgroundColor = .white
        
        let title = button == selectStartTimeButton ? "Start Time" : "End Time"
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
    
    func updateDuration() {
        updateSeconds()
        updateMinutes()
        updateHours()
        print("********")
        print(hours)
        print(minutes)
        print(seconds)
        print("********")
    }
    
    func updateTimeComponent(_ component: inout Int) {
        switch component {
        case 59: component = 0
        default: component += 1
        }
    }
    
    func updateSeconds() {
        
        if seconds == 59 {
            shouldUpdateMinutes = true
            if minutes == 59 {
                shouldUpdateHours = true
            }
        }
        updateTimeComponent(&seconds)
    }
    
    func updateMinutes() {
        if shouldUpdateMinutes {
            updateTimeComponent(&minutes)
            shouldUpdateMinutes = false
        }
    }

    func updateHours() {
        if shouldUpdateHours {
            updateTimeComponent(&hours)
            shouldUpdateHours = false
        }
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
