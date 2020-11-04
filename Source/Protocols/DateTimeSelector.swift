//
//  DateTimeSelector.swift
//  babytracker
//
//  Created by Ai-Lyn Tang on 26/10/20.
//  Copyright © 2020 WhimLyn. All rights reserved.
//

import UIKit

protocol DateTimeSelector: AnyObject {
    var dateTimePicker: DateTimePicker { get }
    var errorMessageView: ErrorMessageView { get }
}

protocol StartDateTimeSelector: DateTimeSelector {
    var startDate: Date? { get }
}

protocol EndDateTimeSelector: DateTimeSelector {
    var endDate: Date? { get }
}

extension DateTimeSelector {
    
    func presentPicker(for button: UIButton,
                       view: UIView,
                       viewController: UIViewController) {
        
        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        let timePickerViewController = UIViewController()
        timePickerViewController.view.addSubview(dateTimePicker)
        timePickerViewController.view.backgroundColor = .clear
        
        let title = dateTimePicker.isStartTime ? Text.startTime : Text.endTime
        dateTimePicker.updateTitle(to: title)
        
        dateTimePicker.translatesAutoresizingMaskIntoConstraints = false
        dateTimePicker.leadingAnchor.constraint(equalTo: timePickerViewController.view.leadingAnchor).isActive = true
        dateTimePicker.trailingAnchor.constraint(equalTo: timePickerViewController.view.trailingAnchor).isActive = true
        dateTimePicker.bottomAnchor.constraint(equalTo: timePickerViewController.view.bottomAnchor).isActive = true
        dateTimePicker.heightAnchor.constraint(equalToConstant: Layout.timePickerHeight).isActive = true
        
        timePickerViewController.modalPresentationStyle = .overCurrentContext
        viewController.present(timePickerViewController, animated: true, completion: nil)
    }
    
    func presentErrorMessage(view: UIView,
                             viewController: UIViewController) {
        
        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        let errorMessageViewController = UIViewController()
        errorMessageViewController.view.addSubview(errorMessageView)
        errorMessageViewController.view.backgroundColor = .clear
        
        errorMessageView.translatesAutoresizingMaskIntoConstraints = false
        errorMessageView.clipsToBounds = true
        errorMessageView.layer.cornerRadius = 20
        
        errorMessageView.centerYAnchor.constraint(equalTo: errorMessageViewController.view.centerYAnchor).isActive = true
        errorMessageView.leadingAnchor.constraint(equalTo: errorMessageViewController.view.leadingAnchor, constant: 48).isActive = true
        errorMessageView.trailingAnchor.constraint(equalTo: errorMessageViewController.view.trailingAnchor, constant: -48).isActive = true
        errorMessageView.heightAnchor.constraint(equalToConstant: Layout.errorMessageHeight).isActive = true
        
        errorMessageViewController.modalPresentationStyle = .overCurrentContext
        viewController.present(errorMessageViewController, animated: true, completion: nil)
    }
    
    func makeFormattedDateString(from date: Date? = nil) -> String {
        
        func useRelativeDateFormatting() -> Bool {
            guard let date = date else { return true }
            
            return Calendar.current.isDateInYesterday(date)
                || Calendar.current.isDateInToday(date)
                || Calendar.current.isDateInTomorrow(date)
        }
        
        let dateFormatter = DateFormatter()
        
        if useRelativeDateFormatting() {
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            dateFormatter.doesRelativeDateFormatting = true
        } else {
            dateFormatter.dateFormat = "EEEE, h:mm a"
        }
        
        return dateFormatter.string(from: date ?? Date())
    }
    
    func isValidDate(startDate: Date?, endDate: Date?) -> Bool {
        
        if let startDate = startDate,
            let endDate = endDate,
            startDate > endDate {
            return false
        }
        
        if let startDate = startDate,
            let endDate = endDate {
            let timeInterval = Int(DateInterval(start: startDate, end: endDate).duration)
            let maximumTimeInterval: Int = 24 * 60 * 60 // 24 hours
            return timeInterval < maximumTimeInterval
        }
        
        if let startDate = startDate,
            startDate > Date() {
            return false
        }
        
        return true
    }
}

// MARK: - Constants

private enum Text {
    static let startTime = "Start Time"
    static let endTime = "End Time"
}
