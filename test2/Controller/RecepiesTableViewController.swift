//
//  RecepiesTableViewController.swift
//  test2
//
//  Created by Alexander Batalov on 3/13/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit
import MBProgressHUD

class RecepiesTableViewController: UITableViewController {

    private let cellReuseIdentifier = "RecepieCell"
    private var recipes = [Recipe]()
    private let networkManager = RecipeNetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchRecipesData()
    }
    
    private func setupUI() {
        title = "Recipes"
        // Configure Refresh Control
        refreshControl?.addTarget(self, action: #selector(refreshRecipesData(_:)), for: .valueChanged)
        refreshControl?.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl?.attributedTitle = NSAttributedString(string: "Fetching Recipe Data ...", attributes: nil)
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
                    self.refreshControl?.endRefreshing()
                    
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
    
    private func showAlert(withMessage message: String?, success: Bool = false ) {
        let alert = UIAlertController(title: success ? "Success" : "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

 // MARK: - Table view data source

extension RecepiesTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
}

// MARK: – Table view delegate

extension RecepiesTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        cell.textLabel?.text = recipes[indexPath.row].name
        return cell
    }
}
