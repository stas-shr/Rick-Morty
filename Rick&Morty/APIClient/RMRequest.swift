//
//  RMRequest.swift
//  Rick&Morty
//
//  Created by Стас on 20.03.2023.
//

import Foundation

/// Object that represents single API call
final class RMRequest {
    // What we need:
    // Base url
    // Endpoint
    // Path components
    // Query parameters
    // https://rickandmortyapi.com/api/character/2
    
    /// API constants
    private struct Constants {
        static let baseURL = "https://rickandmortyapi.com/api"
    }
    
    /// Desired endpoint
    private let endpoint: RMEndpoint
    
    /// Path components for API, if any
    private  let pathComponents: [String]
    
    /// Querry parameters for API, if any
    private let querryParameters: [URLQueryItem]
    
    /// Constructed url for the api request in string format
    private var urlString: String {
        var string = Constants.baseURL
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach({
                string += "/\($0)"
            })
        }
        
        if !querryParameters.isEmpty {
            string += "?"
            // name=value&name=value
            let argumentString = querryParameters.compactMap({
                guard let value = $0.value else {return nil}
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            string += argumentString
        }
            
        return string
    }
    
    /// Computed and constructed url
    public var url: URL? {
        return URL(string: urlString)
    }
    
    /// Desired http method
    public let httpMethod = "GET"
    
    //MARK: - Public
    
    /// Construct request
    /// - Parameters:
    ///   - endpoint: target endpoint
    ///   - pathComponents: collection of path components
    ///   - querryParameters: collection of querry parameters
    public init(
        endpoint: RMEndpoint,
        pathComponents: [String] = [],
        querryParameters: [URLQueryItem] = []
    ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.querryParameters = querryParameters
    }
}

extension RMRequest {
    static let listCharactersRequests = RMRequest(endpoint: .character)
}
