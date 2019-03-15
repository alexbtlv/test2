//
//  RecepiesTableViewController.swift
//  test2
//
//  Created by Alexander Batalov on 3/13/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit
import Kingfisher

enum SearchScope: Int {
    case name, description, instructions
}

enum SortScope: String {
    case name = "Name"
    case date = "Date"
}

class RecepiesTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    private let cellReuseIdentifier = "RecepieCell"
    private var recipes = [Recipe]()
    private var filteredRecipes = [Recipe]()
    private var currentSearchScope: SearchScope = .name
    private let networkManager = RecipeNetworkManager()
    private var searchBarIsEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Recipes"
        // register nib
        tableView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        // Prepare to present search controller
        definesPresentationContext = true
        
        //Add search controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = ["Name", "Description", "Instructions"]
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
    
    @objc private func sortButtonTapped(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text, let scope = SortScope(rawValue: title) else { return }
        sortRecipesBy(scope)
        reloadData()
    }
    
    private func sortRecipesBy(_ scope: SortScope) {
        switch scope{
        case .name:
            isFiltering ? filteredRecipes.sort { $0.name < $1.name } : recipes.sort { $0.name < $1.name }
        case .date:
            isFiltering ? filteredRecipes.sort { $0.lastUpdated > $1.lastUpdated } : recipes.sort { $0.lastUpdated > $1.lastUpdated }
        }
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
                        self.reloadData()
                    case .failure(let error):
                        self.showAlert(withMessage: error)
                    }
                } // end of main.async
            })
            
        }
    }
    
    private func reloadData() {
        if isFiltering && filteredRecipes.isEmpty {
            tableView.setEmptyMessage("No search results")
        } else if recipes.isEmpty {
            tableView.setEmptyMessage("You don't have any recipes, yet.\n Pull to refresh!")
        } else {
            tableView.removeEmptyMessge()
        }
        tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = RecipeTableHeaderView()
            header.dateButton.addTarget(self, action: #selector(sortButtonTapped(_:)), for: .touchUpInside)
            header.nameButton.addTarget(self, action: #selector(sortButtonTapped(_:)), for: .touchUpInside)
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

// MARK: - Search Results Updating

extension RecepiesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        switch currentSearchScope {
        case .name:
            filteredRecipes = recipes.filter {
                return $0.name.lowercased().contains(searchText.lowercased())
            }
        case .description:
            filteredRecipes = recipes.filter {
                return $0.description?.lowercased().contains(searchText.lowercased()) ?? false
            }
        case .instructions:
            filteredRecipes = recipes.filter {
                return $0.instructions?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
        
        reloadData()
    }
}


extension RecepiesTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        currentSearchScope = SearchScope(rawValue: selectedScope) ?? .name
        updateSearchResults(for: searchController)
    }
}
