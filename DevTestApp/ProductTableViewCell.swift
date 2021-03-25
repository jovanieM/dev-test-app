//
//  ProductTableViewCell.swift
//  DevTestApp
//
//  Created by Jovanie Molas on 3/23/21.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    let bookmark: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let bookmarkImage = #imageLiteral(resourceName: "bookmark_active").withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        imageView.image = bookmarkImage
        return imageView
    }()
    
    let productLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var productName: String? {
        didSet{
            productLabel.text = productName
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
               
        self.contentView.addSubview(bookmark)
        setupBookmarkImageView()
        self.contentView.addSubview(productLabel)
        setupProductNameLabel()
        
    }
    
    func setupBookmarkImageView() {
        bookmark.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.bookmark.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            self.bookmark.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.bookmark.widthAnchor.constraint(equalToConstant: 30),
            self.bookmark.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupProductNameLabel() {
        productLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.productLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            self.productLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.productLabel.rightAnchor.constraint(equalTo: bookmark.leftAnchor, constant: -10)
        ])
    }
}
