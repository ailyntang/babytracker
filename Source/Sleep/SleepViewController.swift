//
//  SleepViewController.swift
//  babytracker
//
//  Created by Ai-Lyn Tang on 19/9/20.
//  Copyright © 2020 WhimLyn. All rights reserved.
//

import UIKit

// MARK: - SleepViewController

final class SleepViewController: UIViewController, StartDateTimeSelector, EndDateTimeSelector {
    
    // MARK: Outlets
    
    @IBOutlet private weak var selectStartTimeButton: UIButton!
    @IBOutlet private weak var selectEndTimeButton: UIButton!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    
    // MARK: Properties
    
    private let viewModel: SleepViewModel
    
    // Conformance to DateTimeSelector
    
    private(set) var dateTimePicker: DateTimePicker = DateTimePicker()
    private(set) var startDate: Date? = nil
    private(set) var endDate: Date? = nil
    
    // Conformance to Timeable
    
    private(set) var timer: Timer? = nil
    var seconds: Int = 0
    var minutes: Int = 0
    var hours: Int = 0
    var shouldUpdateMinutes: Bool = false
    var shouldUpdateHours: Bool = false
    
    // MARK: Lifecycle
    
    init?(coder: NSCoder, viewModel: SleepViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Programmer error: SleepViewController initialised without a view model")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add a sleep session"
        dateTimePicker.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: Actions
    
    @IBAction func selectStartTime(_ sender: UIButton) {
        dateTimePicker.isStartTime = true
        presentPicker(for: selectEndTimeButton,
                      view: view,
                      viewController: self)
    }
    
    @IBAction func selectEndTime(_ sender: UIButton) {
        dateTimePicker.isStartTime = false
        presentPicker(for: selectEndTimeButton,
                      view: view,
                      viewController: self)
    }
    
    @IBAction func tapStartButton(_ sender: Any) {
        
        if selectStartTimeButton.titleLabel?.text == Text.setTime {
            setTime(for: selectStartTimeButton)
        }
        
        if startButton.currentTitle == "START" {
            startTimer()
        } else {
            stopTimer()
        }
    }
}

extension SleepViewController: Timeable {

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        startButton.setTitle("START", for: .normal)
        setTime(for: selectEndTimeButton)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            self?.updateDuration()
        })
        timer?.tolerance = 0.2
        startButton.setTitle("STOP", for: .normal)
        
        let attributedString = NSAttributedString(string: "")
        selectEndTimeButton.setAttributedTitle(attributedString, for: .normal)
    }
}

// MARK: - Private methods

private extension SleepViewController {
    
    // MARK: UI
    
    func setupUI() {
        
        let attributedString = NSAttributedString(string: Text.setTime, attributes: viewModel.buttonTitleAttributes)
        selectStartTimeButton.setAttributedTitle(attributedString, for: .normal)
        selectEndTimeButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    // MARK: Timer
    
    // move this to date time selector
    func setTime(for button: UIButton, to time: Date? = nil) {
        
        // Save time stamp
        
        let selectedTime: Date = time ?? Date()
        
        if dateTimePicker.isStartTime {
            startDate = selectedTime
        } else {
            endDate = selectedTime
        }
        
        // Update button title
        
        let timeStamp = makeFormattedDateString(from: selectedTime)
        let attributedString = NSAttributedString(string: timeStamp,
                                                  attributes: viewModel.buttonTitleAttributes)
        
        UIView.performWithoutAnimation {
            button.setAttributedTitle(attributedString, for: .normal)
            button.layoutIfNeeded()
        }
        
        // Update duration label
        
        
        if let startTime = selectStartTimeButton.titleLabel?.text,
            startTime != Text.setTime,
            let endTime = selectEndTimeButton.titleLabel?.text,
            endTime != Text.setTime,
            endTime != "",
            endDate != nil {
            updateDuration(useTimer: false)
        }
    }
    
    func updateDuration(useTimer: Bool = true) {
        
        if useTimer {
            updateTimeComponents()
        } else {
            updateTimeComponents(startDate: startDate, endDate: endDate)
        }
        
        hoursLabel.text = convertTimeComponentToString(hours)
        minutesLabel.text = convertTimeComponentToString(minutes)
        secondsLabel.text = convertTimeComponentToString(seconds)
    }
}

// MARK: - Conformance to TimePickerDelegate

extension SleepViewController: DateTimePickerDelegate {
    
    func cancel() {
        view.backgroundColor = UIColor.white.withAlphaComponent(1)
        dismiss(animated: true, completion: nil)
    }
    
    func save() {
        
        // TODO: don't let user save if the start date is after end date, or if duration is more than 99 hours
        let time = dateTimePicker.dateTimePicker.date
        
        if dateTimePicker.isStartTime {
            setTime(for: selectStartTimeButton, to: time)
        } else {
            setTime(for: selectEndTimeButton, to: time)
        }
        
        cancel()
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

// MARK: - Constants

private enum Text {
    static let setTime = "Set time"
}
