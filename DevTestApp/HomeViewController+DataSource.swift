//
//  HomeViewController+DataSource.swift
//  DevTestApp
//
//  Created by Jovanie Molas on 3/25/21.
//

import UIKit

extension HomeViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ProductTableViewCell
        cell.backgroundColor = .white
        cell.bookmark.isHidden = true
        let book = UserDefaults.standard.bool(forKey: products[indexPath.row].sku)
        if book {
            cell.bookmark.isHidden = false
        }
        cell.productName = products[indexPath.row].name
        return cell
    }
    
}
