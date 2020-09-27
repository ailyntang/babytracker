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
    private var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UINib.init(nibName: homeCell, bundle: nil), forCellReuseIdentifier: homeCell)
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboardID = viewModel.cellViewModels[indexPath.row].storyboardID
        let storyboard = UIStoryboard(name: storyboardID, bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: storyboardID)
        show(secondVC, sender: self)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: homeCell, for: indexPath) as? HomeTableViewCell else {
            fatalError("Issue dequeuing \(homeCell)")
        }

        cell.render(with: viewModel.cellViewModels[indexPath.row])
        return cell
    }
}
