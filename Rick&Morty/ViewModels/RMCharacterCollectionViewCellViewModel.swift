//
//  RMCharacterCollectionViewCellViewModel.swift
//  Rick&Morty
//
//  Created by Стас on 23.03.2023.
//

import Foundation

final class RMCharacterCollectionViewCellViewModel: Hashable, Equatable {
    public let characterName: String
    private let characterStatus: RMCharacterStatus
    private let characterImageURL: URL?
    
    //MARK: -  Init
    
    init(characterName: String, characterStatus: RMCharacterStatus, characterImageURL: URL?) {
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageURL = characterImageURL
    }
    
    public var characterStatusText: String {
        return "Status: \(characterStatus.text)"
    }
    
    public func fetchImage(complition: @escaping (Result<Data, Error>) -> Void) {
        guard let url = characterImageURL else {
            complition(.failure(URLError(.badURL)))
            return
        }
        RMImageLoader.shared.downloadImage(url, complition: complition)
    }
    
    //MARK: - Hashable
    
    static func == (lhs: RMCharacterCollectionViewCellViewModel, rhs: RMCharacterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
        }

    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageURL)
    }
}
