//
//  PokemonCollectionVC.swift
//  Pokedex
//
//  Created by Oleg Bezrukavnikov on 10/8/21.
//

import UIKit

class PokemonCollectionVC: UIViewController, UICollectionViewDelegate {
    let searchController = UISearchController()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 30
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PokemonCard.self, forCellWithReuseIdentifier: PokemonCard.reuseIdentifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // 1B 1D 1F
        navigationItem.searchController = searchController
        view.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.1058823529, blue: 0.1098039216, alpha: 1)
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: 88, left: 30, bottom: 0, right: 30))
        collectionView.backgroundColor = .clear
        
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension PokemonCollectionVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PokemonGenerator.shared.getPokemonArray().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pokemon = PokemonGenerator.shared.getPokemonArray()[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCard.reuseIdentifier, for: indexPath) as! PokemonCard
        cell.pokemon = pokemon
        return cell
    }
}

extension PokemonCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let pokemon = PokemonGenerator.shared.getPokemonArray()[indexPath.item]
        
        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: {
            return PokemonPreviewVC(pokemon: pokemon)
        }) { _ in
            let okItem = UIAction(title: "OK", image: UIImage(systemName: "arrow.down.right.and.arrow.up.left")) { _ in }
            return UIMenu(title: "", image: nil, identifier: nil, children: [okItem])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokemon = PokemonGenerator.shared.getPokemonArray()[indexPath.item]
        print("Selected \(pokemon.name)")
    }
}
