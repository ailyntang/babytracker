//
//  HomeTableViewCell.swift
//  babytracker
//
//  Created by Ai-Lyn Tang on 11/9/20.
//  Copyright © 2020 WhimLyn. All rights reserved.
//

import UIKit

final class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    
    func render(with viewModel: HomeCellViewModel) {
        
        if let image = viewModel.icon {
            iconImageView.image = image
        }
        titleLabel.text = viewModel.titleLabel
        detailLabel.text = viewModel.detailLabel
        durationLabel.text = viewModel.durationLabel != nil
            ? viewModel.durationLabel
            : ""
    }
}

struct HomeCellViewModel {
    
    let icon: UIImage?
    let titleLabel: String
    let detailLabel: String
    let durationLabel: String?
    let viewController: UIViewController
}
