//
//  HomeViewController+Delegate.swift
//  DevTestApp
//
//  Created by Jovanie Molas on 3/25/21.
//

import UIKit

extension HomeViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.allowsSelection = false
        let sku = products[indexPath.row].sku
        networkManager.getProductDetails(from: sku, token: token) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let prod):
                DispatchQueue.main.async {
                    tableView.allowsSelection = true
                    let detailViewController = ProductDetailViewController()
                    detailViewController.productDetails = prod
                    detailViewController.delegate = self
                    detailViewController.tableViewIndex = indexPath.row
                    self.navigationController?.show(detailViewController, sender: self)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
