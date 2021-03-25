//
//  Product.swift
//  DevTestApp
//
//  Created by Jovanie Molas on 3/23/21.
//

import Foundation

struct Response: Codable {
    var items: [Product]
}

struct Product: Codable {
    var name: String
    var sku: String
}

struct ProductDetails: Codable {
    var id : Int
    var sku: String
    var name: String
    var price: Int
    var extension_attributes: Attributes
    var media_gallery_entries: [MediaEntries]
}

struct Attributes: Codable{
    var stock_item: StockDetails
}

struct StockDetails: Codable {
    var is_in_stock: Bool
}

struct MediaEntries: Codable {
    var id: Int
    var media_type: String
    var file: String
}
