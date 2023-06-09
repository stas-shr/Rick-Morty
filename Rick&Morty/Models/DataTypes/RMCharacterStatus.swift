//
//  RMCharacterStatus.swift
//  Rick&Morty
//
//  Created by Стас on 21.03.2023.
//

import Foundation

enum RMCharacterStatus: String, Codable {
    case dead = "Dead"
    case alive = "Alive"
    case `unknown` = "unknown"
    
    var text: String {
        switch self {
        case .dead, .alive:
            return rawValue
        case .unknown:
            return "Unknown"
        }
    }
}
