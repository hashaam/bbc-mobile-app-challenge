//
//  MainViewController.swift
//  bbc-mobile-app-challenge
//
//  Created by Hashaam Siddiq on 6/30/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    var coreDataStack: CoreDataStack! {
        didSet {
            viewModel = MainViewModel(coreDataStack: coreDataStack, delegate: self)
            viewModel.loadData()
        }
    }
    var viewModel: MainViewModel!
    
    var startDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clearsSelectionOnViewWillAppear = true
        
        setupRefreshControl()
        
        startDate = Date()
        
    }
    
    func setupRefreshControl() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlHandler), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        self.refreshControl = refreshControl
        
    }
    
    func refreshControlHandler() {
        
        startDate = Date()
        viewModel.fetchFruits()
        
    }
    
    func refreshControlEndRefreshing() {
        
        guard let refreshControl = self.refreshControl else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            let dateFormatter = DateFormatterManager.shared.formatter
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
            
            let dateString = dateFormatter.string(from: Date())
            let lastUpdatedString = "Last Updated: \(dateString)"
            
            refreshControl.attributedTitle = NSAttributedString(string: lastUpdatedString)
            refreshControl.endRefreshing()
        }
        
    }
    
    func configure(cell: UITableViewCell, atIndex: Int) {
        
        cell.textLabel?.text = viewModel.fruitTypeAt(index: atIndex)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Show Detail" {
            
            guard let indexPathForSelectedRow = tableView.indexPathForSelectedRow else { return }
            guard let fruit = viewModel.fruitAt(index: indexPathForSelectedRow.row) else { return }
            guard let detailViewController = segue.destination as? DetailViewController else { return }
            detailViewController.viewModel = DetailViewModel(fruit: fruit)
            
        }
        
    }
    
}

extension MainViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard viewModel != nil else { return 0 }
        return viewModel.numberOfRows()
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Fruit Cell", for: indexPath)
        configure(cell: cell, atIndex: indexPath.row)
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "Show Detail", sender: self)
        
    }
    
}

extension MainViewController: ViewModelDelegate {
    
    func dataReady(success: Bool) {
        
        if success {
            
            tableView.reloadData()
            
        } else {
            
            let alertController = UIAlertController(title: "Error", message: "Error occurred in fetching data", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        
        refreshControlEndRefreshing()
        
        viewModel.sendStats(statType: .display, startDate: startDate)
        
    }
    
}
