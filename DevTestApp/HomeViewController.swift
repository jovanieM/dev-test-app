//
//  HomeViewController.swift
//  dev-test-app
//
//  Created by Jovanie Molas on 3/19/21.
//

import UIKit

class HomeViewController: UITableViewController {
    
    let networkManager = NetworkManager.shared
    var token = ""
    
    let reloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reload", for: .normal)
        button.tintColor = .darkGray
        return button
    }()
    
    let sortButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sort", for: .normal)
        button.tintColor = .darkGray
        return button
    }()

    var products = [Product]() {
        willSet {// disable buttons while fetching data
            let notEmpty = !newValue.isEmpty
            DispatchQueue.main.async {
                self.reloadButton.isEnabled = notEmpty
                self.sortButton.isEnabled = notEmpty
                self.tableView.separatorStyle = notEmpty ? .singleLine : .none
            }
        }
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Items"
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = .white

        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: self.reloadButton),
                                                   UIBarButtonItem(customView: self.sortButton)]
        self.sortButton.addTarget(self, action: #selector(sortProducts), for: .touchUpInside)
        self.reloadButton.addTarget(self, action: #selector(loadProducts), for: .touchUpInside)
        self.sortButton.isEnabled = false
        self.reloadButton.isEnabled = false
        self.tableView.separatorStyle = .none
        self.tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "cellId")
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        getAuthToken()
    }
    
    private func getAuthToken() {
        networkManager.getToken { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let token):
                self.token = token
                self.loadProducts()
                print(self.token)
            }
        }
    }
    
    @objc func sortProducts(){
        guard !self.products.isEmpty else {
            print("product is empty")
            return }
        
        let sorted = self.products.sorted{ $0.name < $1.name }
        self.products.removeAll()
        self.products = sorted
    }
    
    @objc func loadProducts() {
        self.products.removeAll()
        networkManager.getProduct(token: token){ [weak self] result in
            switch result {
            case .success(let products):
                self?.products = products
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension HomeViewController: ProductDetailDelegate {
    func completionHandler(index: Int) {
        tableView.reloadData()
    }
}
