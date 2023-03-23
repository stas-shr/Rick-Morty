//
//  RMCharacterCollectionViewCell.swift
//  Rick&Morty
//
//  Created by Стас on 23.03.2023.
//

import UIKit

/// Sengle cell for a character
class RMCharacterCollectionViewCell: UICollectionViewCell {
    static let cellId = "RMCharacterCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 18, weight: .medium)
        nameLabel.textColor = .label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private let statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.font = .systemFont(ofSize: 16, weight: .regular)
        statusLabel.textColor = .secondaryLabel
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        return statusLabel
    }()


    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .secondarySystemBackground
        addSubviews(imageView, nameLabel, statusLabel)
        setConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil
    }
    
    public func configure(with viewModel: RMCharacterCollectionViewCellViewModel) {
        nameLabel.text = viewModel.characterName
        statusLabel.text = viewModel.characterStatusText
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.imageView.image = image
                }
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
    }
}

extension RMCharacterCollectionViewCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            statusLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            statusLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            statusLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            statusLabel.heightAnchor.constraint(equalToConstant: 40),
            
            nameLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor, constant: -5),
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),

            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -5),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5)
        ])
    }
}
