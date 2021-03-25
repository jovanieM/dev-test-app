//
//  FetchData.swift
//  dev-test-app
//
//  Created by Jovanie Molas on 3/19/21.
//

import Foundation

enum FetchError: Error {
    case noData
    case cannotProcessData
    case badResponse
}

class NetworkManager {
    
    static var shared = NetworkManager()
    
    let session: URLSession
    
    private var downloadedImages = NSCache<NSString, NSData>()
    
    private init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }

    private func urlComponents(endPath: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = Constants.APIDetails.APIScheme
        components.host = Constants.APIDetails.APIHost
        components.path = Constants.APIDetails.APIPath + endPath
        
        return components
    }

    func getProduct(token: String, completion: @escaping(Result<[Product], FetchError>) -> Void){
  
        var comp = urlComponents(endPath: Constants.APIDetails.productPath)
        
        comp.queryItems = [URLQueryItem(name: "searchCriteria[pageSize]", value: String(0)),
                           URLQueryItem(name: "fields", value: "items[sku,name]")]

        var request = URLRequest(url: comp.url!)
        
        request.httpMethod = Constants.HTTPRequestMethod.get
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request){ data, response, error in
            guard let jsonData = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(Response.self, from: jsonData)
                completion(.success(response.items))
                
            }catch {
                completion(.failure(.cannotProcessData))
            }
        }.resume()
    }
    
    func getToken(completion: @escaping(Result<String, FetchError>)->()){
        let credentials = ["username": "appDevTest",
                           "password": "tti2020"]

        var request = URLRequest(url: urlComponents(endPath: Constants.APIDetails.tokenPath).url!)
        request.httpMethod = Constants.HTTPRequestMethod.post
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: credentials,
                                                         options: []) else {return}
 
        request.httpBody = httpBody
        
        session.dataTask(with: request){ data, response, error in

            guard error == nil else {
                completion(.failure(.cannotProcessData))
                return
            }
    
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.cannotProcessData))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            DispatchQueue.main.async {
                guard let token = String(data: data, encoding: .utf8) else { return }
                completion(.success(token.replacingOccurrences(of: "\"", with: "")))
            }
        }.resume()
    }
    
    func getProductDetails(from sku: String, token: String, completion: @escaping(Result<ProductDetails, FetchError>) -> ()){
        let comp = urlComponents(endPath: Constants.APIDetails.productDetailsPath + sku)
        var request = URLRequest(url: comp.url!)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request){ data, response, error in
            guard let jsonData = data else {
                completion(.failure(.noData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.badResponse))
                return
            }

            do {
                let response = try JSONDecoder().decode(ProductDetails.self, from: jsonData)
                completion(.success(response))
            }catch {
                completion(.failure(.cannotProcessData))
            }
        }.resume()
    }
    
    func downloadImage(from filePath: String, completion: @escaping(Data?, Error?) ->()) {
        
        let urlString = Constants.APIDetails.imageURL + filePath
        if let imageData = downloadedImages.object(forKey: urlString as NSString) {
            completion(imageData as Data, nil)
            print("cached image")
            return
        }
        guard let url = URL(string: urlString) else {
            return
        }
        
        session.downloadTask(with: url) { localUrl, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(nil, error)
                return
            }
            
            guard let localUrl = localUrl else {
                completion(nil, error)
                return
            }
            do {
                let data = try Data(contentsOf: localUrl)
                self.downloadedImages.setObject(data as NSData, forKey: urlString as NSString)
                completion(data, nil)
            }catch let error {
                completion(nil, error)
            }
            
        }.resume()
    }
}
