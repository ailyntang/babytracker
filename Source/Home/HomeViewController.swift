//
//  HomeViewController.swift
//  babytracker
//
//  Created by Ai-Lyn Tang on 10/9/20.
//  Copyright © 2020 WhimLyn. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let homeCell = "HomeTableViewCell"
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UINib.init(nibName: homeCell, bundle: nil), forCellReuseIdentifier: homeCell)
    }
}

extension HomeViewController: UITableViewDelegate {
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: homeCell, for: indexPath) as? HomeTableViewCell else {
            fatalError("Issue dequeuing \(homeCell)")
        }
        let viewModel = HomeCellViewModel(titleLabel: "Sleeping",
                                           detailLabel: "xyz",
                                           durationLabel: "00:23:22")
        cell.render(with: viewModel)
        return cell
    }
}
