//
//  RMCharacterDetailViewController.swift
//  Rick&Morty
//
//  Created by Стас on 23.03.2023.
//

import UIKit

/// Controller for selected Character with details
final class RMCharacterDetailViewController: UIViewController {
    
    private let viewModel: RMCharacterDetailViewViewModel
    
    init(viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.title
    }
 
}
