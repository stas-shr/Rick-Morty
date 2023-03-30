//
//  RMCharacterListViewViewModel.swift
//  Rick&Morty
//
//  Created by Стас on 21.03.2023.
//

import UIKit

protocol RMCharacterListViewViewModelDelegate: AnyObject {
    func didLoadCharacters()
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath])
    func didSelectCharacter(_ character: RMCharacter)
}

/// View Model to carry characters list view logic
class RMCharacterListViewViewModel: NSObject {
    
    weak var delegate: RMCharacterListViewViewModelDelegate?
    
    private var isLoadingMoreCharacters = false
    
    private var characters: [RMCharacter] = [] {
        didSet {
            for character in characters {
                let viewModel = RMCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageURL: URL(string: character.image)
                )
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []
    
    private var apiInfo: RMGetAllCharactersResponce.Info? = nil
    
    /// Fetch set of 20 characters
    public func fetchCharacters() {
        RMService.shared.execute(
            .listCharactersRequests,
            expecting: RMGetAllCharactersResponce.self
        ) { [weak self] result in
            switch result {
            case .success(let resultsModel):
                let results = resultsModel.results
                let info = resultsModel.info
                self?.characters = results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadCharacters()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    /// Adds more characters if there are ones
    public func fetchAdditionalCharacters(url: URL) {
        guard !isLoadingMoreCharacters else { return }
        isLoadingMoreCharacters = true
        guard let request = RMRequest(url: url) else {
            isLoadingMoreCharacters = false
            return
        }
        
        RMService.shared.execute(request, expecting: RMGetAllCharactersResponce.self) { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let resultsModel):
                let moreResults = resultsModel.results
                let info = resultsModel.info
                strongSelf.characters.append(contentsOf: moreResults)
                strongSelf.apiInfo = info
                
                let originalCount = strongSelf.characters.count
                let newCount = moreResults.count
                // another option
//                let total = originalCount + newCount
//                let startingIndex = total - newCount
//                let indexPathToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap {
//                    return IndexPath(row: $0, section: 0)
//                }
                let startingIndex = originalCount - newCount
                let indexPathsToAdd = Array(startingIndex..<originalCount).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreCharacters(with: indexPathsToAdd)
                    strongSelf.isLoadingMoreCharacters = false
                }
            case .failure(let failure):
                print(String(describing: failure))
                strongSelf.isLoadingMoreCharacters = false
            }
        }
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return true // apiInfo?.next != nil
    }
    
}

//MARK: - CollectionView

extension RMCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterCollectionViewCell.cellId,
            for: indexPath
        ) as? RMCharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        return CGSize(width: width,
                      height: width * 1.5
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter, let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: RMFooterLoadingCollectionReusableView.id,
            for: indexPath
        ) as? RMFooterLoadingCollectionReusableView
                
        else {
            fatalError("Unsupported")
        }
        
        footer.startAnimating()
        
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreCharacters,
              !cellViewModels.isEmpty,
              let nextPageUrl = apiInfo?.next,
              let url = URL(string: nextPageUrl)
        else { return }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewHeight = scrollView.frame.size.height
            
            if offset >= (totalScrollViewHeight - totalContentHeight - 120) {
                self?.fetchAdditionalCharacters(url: url)
            }
            t.invalidate()
        }

    }
}

//MARK: - ScrollView

extension RMCharacterListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // moved to scrollViewDidEndDragging (delete later)
    }
    
    
}
