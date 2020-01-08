//
//  SearchViewController.swift
//  RedmadrobotTestProject
//
//  Created by Тимофей Забалуев on 30.12.2019.
//  Copyright © 2019 Тимофей Забалуев. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    private var timer: Timer?
    private let data: [String] = []
    private var filteredData = [String]()
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
//        definesPresentationContext = true
        
    }
    
//    func initData() {
//        Network.get(
//            urlParams: "/search/photos",
//            queryParams: ["query": "home"],
//            completHandler: { response in
//                print(response)
//            },
//            errorHandler: { error in
//                let alert = UIAlertController(title: "Ошибка", message: "Произошла ошибка получения данных с сервера, попробуйте позже.", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: "Хорошо", style: UIAlertAction.Style.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//            }
//        )
//    }
}

// MARK: SearchView

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredData = data.filter({ (element: String) -> Bool in
            return element.contains(searchController.searchBar.text!)
        })
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {(_) in
//            self.initData()
            self.tableView.reloadData()
        })
    }
}

// MARK: TableViewController

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredData.count
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        
        let newData = isFiltering ? filteredData[indexPath.row] : data[indexPath.row]
        
        cell.textLabel?.text = newData
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
