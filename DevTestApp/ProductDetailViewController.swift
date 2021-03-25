//
//  ProductDetailViewController.swift
//  DevTestApp
//
//  Created by Jovanie Molas on 3/22/21.
//

import UIKit

protocol ProductDetailDelegate {
    func completionHandler(index: Int)
}

class ProductDetailViewController: UIViewController {
    
    
    var delegate: ProductDetailDelegate?
    var tableViewIndex: Int?
    let networkManager = NetworkManager.shared
    var productDetails: ProductDetails? {
        didSet {
            nameLabel.text = productDetails?.name
            modelLabel.text = productDetails?.sku
            let priceFormat = NumberFormatter()
            priceFormat.locale = Locale.init(identifier: "ja_JP")
            priceFormat.numberStyle = .currency
            let price = priceFormat.string(from: NSNumber(value: productDetails?.price ?? 0))
            priceLabel.text = price
            stockStatus.text = productDetails?.extension_attributes.stock_item.is_in_stock ?? false ? "in stock" : "out of stock"
        }
    }
    
    let container: UIView = {
       let uiView = UIView()
        uiView.frame = .zero
        return uiView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.frame = .zero
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 22)
        label.sizeToFit()
        return label
    }()
    
    let modelLabel: UILabel = {
        let label = UILabel()
        label.frame = .zero
        label.font = .systemFont(ofSize: 18)
        label.sizeToFit()
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.frame = .zero
        label.font = .systemFont(ofSize: 18)
        label.sizeToFit()
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let stockStatus: UILabel = {
        let label = UILabel()
        label.frame = .zero
        label.font = .systemFont(ofSize: 18)
        label.sizeToFit()
        return label
    }()
    
    let bookmarkBtn: BookmarkButton = {
        let button = BookmarkButton()
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "back").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backToProductList))
        self.navigationItem.leftBarButtonItem = back

        self.navigationItem.setHidesBackButton(true, animated: false)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bookmarkBtn)
        self.bookmarkBtn.addTarget(self, action: #selector(setBookmarkStatus), for: .touchUpInside)
        setupBookmarkBtn()
        
        self.view.addSubview(container)
        self.setupContainerView()
        
        self.container.addSubview(nameLabel)
        self.setupProductName()
        

        self.container.addSubview(modelLabel)
        self.setupProductModel()
        
        self.container.addSubview(priceLabel)
        self.setupProductPrice()

        self.container.addSubview(imageView)
        self.setupProductImageView()

        self.container.addSubview(stockStatus)
        self.setupStockStatus()
        startDownload()
    }
    
    /// download image and save to cache
    func startDownload(){
        guard let imagePath = productDetails?.media_gallery_entries.first?.file else { return }
        networkManager.downloadImage(from: imagePath) { [weak self] (data, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            DispatchQueue.main.async {
                self?.imageView.image = UIImage(data: data)
            }
        }
    }
    
    @objc func backToProductList() {
        if let delegate = self.delegate {
            delegate.completionHandler(index: self.tableViewIndex!)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    /// toggle bookmark status
    @objc func setBookmarkStatus() {
        guard let product = self.productDetails else { return }
        let isMarked = UserDefaults.standard.bool(forKey: product.sku)
        if isMarked {// remove from bookmark
            UserDefaults.standard.removeObject(forKey: product.sku)
            self.bookmarkBtn.isSelected = false
        }else{
            UserDefaults.standard.setValue(true, forKey: product.sku)
            self.bookmarkBtn.isSelected = true
        }
    }
    
    /// set the current bookmark status image
    private func setupBookmarkBtn(){
        guard let product = self.productDetails else { return }
        let bookmarked = UserDefaults.standard.bool(forKey: product.sku)
        self.bookmarkBtn.isSelected = bookmarked
    }
    
    func setupContainerView() {
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            container.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: self.self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 16)
        ])
    }
    
    func setupProductName() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate ([
            nameLabel.topAnchor.constraint(equalTo: self.container.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: self.container.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: self.container.trailingAnchor),
        ])
    }
    
    func setupProductModel() {
        modelLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate ([
            modelLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 8),
            modelLabel.leadingAnchor.constraint(equalTo: self.container.leadingAnchor),
            modelLabel.trailingAnchor.constraint(equalTo: self.container.trailingAnchor)
        ])
    }
    
    func setupProductPrice() {
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: self.modelLabel.bottomAnchor, constant: 16),
            priceLabel.leadingAnchor.constraint(equalTo: self.container.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: self.container.trailingAnchor)
        ])
    }
    
    func setupProductImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.priceLabel.bottomAnchor, constant: 8),
            imageView.centerXAnchor.constraint(equalTo: self.container.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func setupStockStatus() {
        stockStatus.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stockStatus.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 8),
            stockStatus.leadingAnchor.constraint(equalTo: self.container.leadingAnchor),
            stockStatus.trailingAnchor.constraint(equalTo: self.container.trailingAnchor)
        ])
    }
}
