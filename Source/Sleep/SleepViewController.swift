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
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    
    // MARK: Properties
    
    private let viewModel: SleepViewModel
    
    private var timePicker: DateTimePicker = DateTimePicker()
    private var timer: Timer? = nil
    private var seconds: Int = 0
    private var minutes: Int = 0
    private var hours: Int = 0
    private var shouldUpdateMinutes: Bool = false
    private var shouldUpdateHours: Bool = false
    private var startTime: Date? = nil
    private var endTime: Date? = nil
    
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

// MARK: - Private methods

private extension SleepViewController {
    
    // MARK: UI
    
    func setupUI() {
        
        let attributedString = NSAttributedString(string: Text.setTime, attributes: viewModel.buttonTitleAttributes)
        selectStartTimeButton.setAttributedTitle(attributedString, for: .normal)
        selectEndTimeButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    // MARK: Time Picker
    
    func presentTimePicker(for button: UIButton) {
        
        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        let timePickerViewController = UIViewController()
        timePickerViewController.view.addSubview(timePicker)
        timePickerViewController.view.backgroundColor = .white
        
        let title = button == selectStartTimeButton ? Text.startTime : Text.endTime
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
    
    // MARK: Timer
    
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
    
    func setTime(for button: UIButton, to time: Date? = nil) {
        
        // Date formatting
        
        func useRelativeDateFormatting() -> Bool {
            guard let time = time else { return true }
            
            return Calendar.current.isDateInYesterday(time)
                || Calendar.current.isDateInToday(time)
                || Calendar.current.isDateInTomorrow(time)
        }
        
        let dateFormatter = DateFormatter()
        
        if useRelativeDateFormatting() {
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            dateFormatter.doesRelativeDateFormatting = true
        } else {
            dateFormatter.dateFormat = "EEEE, h:mm a"
        }
        
        // Save time stamp
        
        let selectedTime: Date = time ?? Date()
        
        if button == selectStartTimeButton {
            startTime = selectedTime
        } else {
            endTime = selectedTime
        }
        
        // Update button title
        
        let timeStamp = dateFormatter.string(from: selectedTime)
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
            endTime != "" {
            updateDuration(useTimer: false)
        }
    }
    
    func updateDuration(useTimer: Bool = true) {
        
        if useTimer {
            updateSeconds()
            updateMinutes()
            updateHours()
            
        } else if let startTime = startTime,
            let endTime = endTime {
            
            // This should never occur as the user is not allowed to enter an end time before the start time
            guard startTime < endTime else { return }
            let durationInSeconds: Int = Int(DateInterval(start: startTime, end: endTime).duration)
            
            seconds = durationInSeconds % 60

            let totalMinutes = durationInSeconds / 60
            minutes = totalMinutes % 60
            
            let totalHours = totalMinutes / 60
            hours = totalHours % 60
            
        } else {
            fatalError("Programmer error: unexpectedly nil for start or end time")
        }
        
        hoursLabel.text = viewModel.convertTimeComponentToString(hours)
        minutesLabel.text = viewModel.convertTimeComponentToString(minutes)
        secondsLabel.text = viewModel.convertTimeComponentToString(seconds)
    }
    
    func updateSeconds() {
        
        if seconds == 59 {
            shouldUpdateMinutes = true
            if minutes == 59 {
                shouldUpdateHours = true
            }
        }
        viewModel.updateTimeComponent(&seconds)
    }
    
    func updateMinutes() {
        if shouldUpdateMinutes {
            viewModel.updateTimeComponent(&minutes)
            shouldUpdateMinutes = false
        }
    }

    func updateHours() {
        if shouldUpdateHours {
            viewModel.updateTimeComponent(&hours)
            shouldUpdateHours = false
        }
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
        let time = timePicker.dateTimePicker.date
        
        if timePicker.titleLabel.text == Text.startTime {
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
    static let startTime = "Start Time"
    static let endTime = "End Time"
}
