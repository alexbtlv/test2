//
//  RecepiesTableViewController.swift
//  test2
//
//  Created by Alexander Batalov on 3/13/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit
import MBProgressHUD

class RecepiesTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    private let cellReuseIdentifier = "RecepieCell"
    private var recipes = [Recipe]()
    private let networkManager = RecipeNetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Recipes"
        // register nib
        tableView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshRecipesData(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Recipe Data ...", attributes: nil)
    }
    
    @objc private func refreshRecipesData(_ sender: Any) {
        // Fetch Weather Data
        fetchRecipesData()
    }

    private func fetchRecipesData() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            self.networkManager.getRecepies(completion: { (response) in
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    
                    switch response {
                    case .success(let newRecepies):
                        self.recipes = newRecepies
                        self.tableView.reloadData()
                    case .failure(let error):
                        self.showAlert(withMessage: error)
                    }
                } // end of main.async
            })
            
        }
    }
}

 // MARK: - Table view data source

extension RecepiesTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if recipes.isEmpty {
            tableView.setEmptyMessage("You don't have any recipes, just yet.\n Pull to refresh!")
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
}

// MARK: – Table view delegate

extension RecepiesTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) else {
            preconditionFailure("Plese make sure to register Nib for Cell Reuse Identifier.")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = recipes[indexPath.row].name
    }
}
