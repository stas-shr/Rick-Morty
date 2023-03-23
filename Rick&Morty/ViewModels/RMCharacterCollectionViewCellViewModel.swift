//
//  RMCharacterCollectionViewCellViewModel.swift
//  Rick&Morty
//
//  Created by Стас on 23.03.2023.
//

import Foundation

final class RMCharacterCollectionViewCellViewModel {
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
        return characterStatus.rawValue
    }
    
    public func fetchImage(complition: @escaping (Result<Data, Error>) -> Void) {
        // TODO: Сделать: сделать абстракцией (imageManager)
        guard let url = characterImageURL else {
            complition(.failure(URLError(.badURL)))
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                complition(.failure(URLError(.badServerResponse)))
                return
            }
            complition(.success(data))
        }
        task.resume()
    }
}
