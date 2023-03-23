//
//  RMCharacterViewController.swift
//  Rick&Morty
//
//  Created by Стас on 20.03.2023.
//

import UIKit

/// Controller to show and search for characters
final class RMCharacterViewController: UIViewController {

    let characterListView = RMCharacterListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Characters"
        
        view.addSubview(characterListView)
        setConstraints()
    }
    
}

extension RMCharacterViewController {
    func setConstraints() {
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            characterListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}
