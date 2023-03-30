//
//  RMImageLoader.swift
//  Rick&Morty
//
//  Created by Стас on 28.03.2023.
//

import Foundation

final class RMImageLoader {
    static let shared = RMImageLoader()
    
    private var imageDataCache = NSCache<NSString, NSData>()
    
    /// Get images with url
    /// - Parameters:
    ///   - url: source url
    ///   - complition: callback
    public func downloadImage(_ url: URL, complition: @escaping (Result<Data, Error>) -> Void) {
        let key = url.absoluteString as NSString
        if let data = imageDataCache.object(forKey: key) {
            complition(.success(data as Data))
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, _, error in
            guard let data = data, error == nil else {
                complition(.failure(URLError(.badServerResponse)))
                return
            }
            
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            complition(.success(data))
        }
        task.resume()

    }
}

