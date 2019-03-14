//
//  RecepiesTableViewController.swift
//  test2
//
//  Created by Alexander Batalov on 3/13/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit
import Kingfisher

class RecepiesTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    private let cellReuseIdentifier = "RecepieCell"
    private var recipes = [Recipe]()
    private var filteredRecipes = [Recipe]()
    private let networkManager = RecipeNetworkManager()
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Recipes"
        // register nib
        tableView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        
        //Add search controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
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
            tableView.setEmptyMessage("You don't have any recipes, yet.\n Pull to refresh!")
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredRecipes.count
        }
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
        guard let cell = cell as? RecipeTableViewCell else {
            preconditionFailure("Can not cast cell as Recipe Table View Cell")
        }
        let recipe = isFiltering ? filteredRecipes[indexPath.row] : recipes[indexPath.row]
        cell.recipeImageView.kf.setImage(with: recipe.thumbImageURL)
        cell.nameLabel.text = recipe.name
        cell.descriptionLabel.text = recipe.description
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = isFiltering ? filteredRecipes[indexPath.row] : recipes[indexPath.row]
        let detailVC = RecipeDetailViewController(nibName: "RecipeDetailViewController", bundle: nil)
        detailVC.recipe = recipe
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - Search Results Updating

extension RecepiesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredRecipes = recipes.filter {
            return $0.name?.lowercased().contains(searchText.lowercased()) ?? false
        }
        
        tableView.reloadData()
    }
}
