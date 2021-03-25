//
//  Constants.swift
//  DevTestApp
//
//  Created by Jovanie Molas on 3/22/21.
//

import Foundation

struct Constants {
    struct APIDetails {
        static let APIScheme = "https"
        static let APIHost = "milwaukee.dtndev.com"
        static let APIPath = "/rest/default/V1"
        static let tokenPath = "/integration/admin/token"
        static let productPath = "/products"
        static let productDetailsPath = "/products/"
        static let imageURL = "https://milwaukee.dtndev.com/media/catalog/product/cache/e2d140cbc864e6a2429f6dfbb93d9620"
    }
    
    struct HTTPRequestMethod {
        static let get = "GET"
        static let post = "POST"
    }
}
