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
        timePickerViewController.view.backgroundColor = .white
        
        let title = dateTimePicker.isStartTime ? Text.startTime : Text.endTime
        dateTimePicker.updateTitle(to: title)
        dateTimePicker.translatesAutoresizingMaskIntoConstraints = false
        dateTimePicker.topAnchor.constraint(equalTo: timePickerViewController.view.topAnchor).isActive = true
        dateTimePicker.leadingAnchor.constraint(equalTo: timePickerViewController.view.leadingAnchor).isActive = true
        dateTimePicker.trailingAnchor.constraint(equalTo: timePickerViewController.view.trailingAnchor).isActive = true
        dateTimePicker.heightAnchor.constraint(equalTo: timePickerViewController.view.heightAnchor).isActive = true
        
        timePickerViewController.modalPresentationStyle = .custom
        timePickerViewController.transitioningDelegate = viewController as? UIViewControllerTransitioningDelegate
        viewController.present(timePickerViewController, animated: true, completion: nil)
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
}

// MARK: - Constants

private enum Text {
    static let setTime = "Set time"
    static let startTime = "Start Time"
    static let endTime = "End Time"
}


//class Timer {
//
//}

/*
 
 - HasDuration
     - hours, minutes, seconds
     - a way to calculate the duration, i.e. start date / time, end date /time
 
 
 
 - DateTimeSelectorDelegate
      - cancel()
      - save()
 
 - Timeable
      - variable timer: Timer
    
 */
