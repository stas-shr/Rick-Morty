//
//  RMService.swift
//  Rick&Morty
//
//  Created by Стас on 20.03.2023.
//

import Foundation

/// Primary API service object to get data
final class RMService {
    /// Shared singleton instance
    static let shared = RMService()
    
    /// Privatised constructor
    private init() {}
    
    enum RMServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    /// Send API call
    /// - Parameters:
    ///   - request: request instance
    ///   - type: the type of object we expect to get back
    ///   - complition: callback with data or error
    public func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        complition: @escaping (Result<T, Error>) -> Void
    ) {
        guard let urlRequest = self.request(from: request) else {
            complition(.failure(RMServiceError.failedToCreateRequest))
            return
        }
        
        let tasк = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                complition(.failure(error ?? RMServiceError.failedToGetData))
                return
            }
            
            // Decode the responce
            do {
                let resolt = try
                JSONDecoder().decode(type.self, from: data)
                complition(.success(resolt))
            }
            catch {
                complition(.failure(error))
            }
        }
        
        tasк.resume()
    }
    
    //MARK: - Private
    
    private func request(from rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        return request
    }
}
