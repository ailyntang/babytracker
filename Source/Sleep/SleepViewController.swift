//
//  SleepViewController.swift
//  babytracker
//
//  Created by Ai-Lyn Tang on 19/9/20.
//  Copyright © 2020 WhimLyn. All rights reserved.
//

import UIKit
import SQLite3

// MARK: - SleepViewController

final class SleepViewController: UIViewController, StartDateTimeSelector, EndDateTimeSelector {
    
    // MARK: Outlets
    
    @IBOutlet private weak var selectStartTimeButton: UIButton!
    @IBOutlet private weak var selectEndTimeButton: UIButton!
    @IBOutlet private weak var timerButton: UIButton!
    @IBOutlet private weak var hoursLabel: UILabel!
    @IBOutlet private weak var minutesLabel: UILabel!
    @IBOutlet private weak var secondsLabel: UILabel!
    @IBOutlet private weak var continueButton: UIButton!
    
    // MARK: Properties
    
    private let viewModel: SleepViewModel
    
    // Conformance to DateTimeSelector
    
    private(set) var dateTimePicker: DateTimePicker = DateTimePicker()
    private(set) var errorMessageView: ErrorMessageView = ErrorMessageView()
    private(set) var startDate: Date? = nil
    private(set) var endDate: Date? = nil
    
    // Conformance to Timeable
    
    private(set) var timer: Timer? = nil
    private(set) var timerStatus: TimerStatus = .off
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
        errorMessageView.delegate = self
        setupUI()
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
    
    @IBAction func tapTimerButton(_ sender: UIButton) {
        
        if selectStartTimeButton.titleLabel?.text == Text.setTime {
            setTime(for: selectStartTimeButton)
        }

        switch timerStatus {
        case .off: startTimer()
        case .on: stopTimer()
        case .save:
            // TODO: need to add this functionality
            print("save sleep session")
        }
    }
    
    @IBAction func tapContinueButton(_ sender: UIButton) {
        startTimer()
    }
}

extension SleepViewController: Timeable {

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerStatus = .save
                
        timerButton.setTitle(Text.save, for: .normal)
        timerButton.backgroundColor = .customGreen
        setTime(for: selectEndTimeButton)
        
        continueButton.isHidden = false
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            self?.updateDuration()
        })
        timer?.tolerance = 0.2
        timerStatus = .on
        
        timerButton.setTitle(Text.stop, for: .normal)
        timerButton.backgroundColor = .customCyan
        
        let attributedString = NSAttributedString(string: "")
        selectEndTimeButton.setAttributedTitle(attributedString, for: .normal)
        
        continueButton.isHidden = true
    }
}

// MARK: - Private methods

private extension SleepViewController {
    
    // MARK: UI
    
    func setupUI() {
        
        let attributedString = NSAttributedString(string: Text.setTime, attributes: viewModel.buttonTitleAttributes)
        selectStartTimeButton.setAttributedTitle(attributedString, for: .normal)
        selectEndTimeButton.setAttributedTitle(attributedString, for: .normal)
        
        timerButton.backgroundColor = .customCyan
        timerButton.layer.cornerRadius = timerButton.frame.width / 2
        
        continueButton.isHidden = true
        continueButton.tintColor = .customCyan
    }
    
    // MARK: Timer
    
    func saveTimeStamp(for button: UIButton, to time: Date? = nil) {
        let selectedTime: Date = time ?? Date()
        if button == selectStartTimeButton {
            startDate = selectedTime
        } else {
            endDate = selectedTime
        }
    }
    
    func updateButtonTitleTo(_ time: Date, for button: UIButton) {
        let timeStamp = makeFormattedDateString(from: time)
        let attributedString = NSAttributedString(string: timeStamp,
                                                  attributes: viewModel.buttonTitleAttributes)
        
        UIView.performWithoutAnimation {
            button.setAttributedTitle(attributedString, for: .normal)
            button.layoutIfNeeded()
        }
    }
    
    func setTime(for button: UIButton, to time: Date? = nil) {
        
        saveTimeStamp(for: button, to: time)
        
        updateButtonTitleTo(time ?? Date(), for: button)
        
        if startDate != nil, endDate != nil {
            updateDuration(useTimer: false)
        }
    }
    
    func updateDuration(useTimer: Bool = true) {
        
        if useTimer {
            updateTimeComponents(startDate: startDate, endDate: nil)
        } else {
            updateTimeComponents(startDate: startDate, endDate: endDate)
        }
        
        hoursLabel.text = convertTimeComponentToString(hours)
        minutesLabel.text = convertTimeComponentToString(minutes)
        secondsLabel.text = convertTimeComponentToString(seconds)
    }
    
    // MARK: Dismiss modal
    
    func dismissModal() {
        view.backgroundColor = UIColor.white.withAlphaComponent(1)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Conformance to TimePickerDelegate

extension SleepViewController: DateTimePickerDelegate {
    
    func cancel() {
        dismissModal()
    }
    
    func save() {
        let date = dateTimePicker.dateTimePicker.date
        var button: UIButton = dateTimePicker.isStartTime ? selectStartTimeButton : selectEndTimeButton
        
        saveTimeStamp(for: button, to: date)
        
        guard isValidDate(startDate: startDate, endDate: endDate) else {
            cancel()
            presentErrorMessage(view: view, viewController: self)
            return
        }
        updateButtonTitleTo(date, for: button)

        if startDate != nil, endDate != nil {
            updateDuration(useTimer: false)
        }
        cancel()
    }
}

// MARK: - Conformance to ErrorMessageViewDelegate

extension SleepViewController: ErrorMessageViewDelegate {
    
    func dismiss() {
        dismissModal()
    }
}

// MARK: - Constants

private enum Text {
    static let setTime = "Set time"
    static let save = "SAVE"
    static let start = "START"
    static let stop = "STOP"
}
