//
//  RMCharacterViewController.swift
//  Rick&Morty
//
//  Created by Стас on 20.03.2023.
//

import UIKit

/// Controller to show and search for characters
final class RMCharacterViewController: UIViewController, RMCharacterListViewDelegate {

    let characterListView = RMCharacterListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Characters"
        
        view.addSubview(characterListView)
        setConstraints()
    }
    
    //MARK: - RMCharacterListViewDelegate
    
    func rmCharacterListView(_ characterListView: RMCharacterListView, didselectCharacter character: RMCharacter) {
            // Open detail controller of selected character
        let viewModel = RMCharacterDetailViewViewModel(character: character)
        let detailVC = RMCharacterDetailViewController(viewModel: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
        
       }
}

extension RMCharacterViewController {
    func setConstraints() {
        characterListView.delegate = self
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            characterListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}
