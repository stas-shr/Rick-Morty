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
    
    /// Send API call
    /// - Parameters:
    ///   - request: request instance
    ///   - complition: callback with data or error
    public func execute(_ request: RMRequest, complition: @escaping () -> Void) {
        
    }
}
