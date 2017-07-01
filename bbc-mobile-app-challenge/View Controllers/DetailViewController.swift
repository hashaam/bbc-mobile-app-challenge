//
//  DetailViewController.swift
//  bbc-mobile-app-challenge
//
//  Created by Hashaam Siddiq on 6/30/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {
    
    var viewModel: DetailViewModel!
    
    @IBOutlet weak var typeCell: UITableViewCell!
    @IBOutlet weak var priceCell: UITableViewCell!
    @IBOutlet weak var weightCell: UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()

    }
    
    func setupData() {
        
        title = viewModel.fruitType
        
        typeCell.textLabel?.text = viewModel.fruitType
        priceCell.textLabel?.text = viewModel.fruitPrice
        weightCell.textLabel?.text = viewModel.fruitWeight
        
        priceCell.textLabel?.textAlignment = .right
        weightCell.textLabel?.textAlignment = .right
        
    }

}

