//
//  RMCharacterViewController.swift
//  Rick&Morty
//
//  Created by Стас on 20.03.2023.
//

import UIKit

/// Controller to show and search for characters
final class RMCharacterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Characters"
        
        let request = RMRequest(
            endpoint: .character,
            querryParameters: [URLQueryItem(name: "name", value: "rick"),
                              URLQueryItem(name: "status", value: "alive")]
        )
        print(request.url)
        
        
    }
    



}
