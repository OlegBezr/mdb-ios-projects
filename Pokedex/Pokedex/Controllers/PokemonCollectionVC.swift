//
//  PokemonCollectionVC.swift
//  Pokedex
//
//  Created by Oleg Bezrukavnikov on 10/8/21.
//

import UIKit

class PokemonCollectionVC: UIViewController, UICollectionViewDelegate, UISearchBarDelegate {
    let searchController = UISearchController()
    let pokemonData = PokemonGenerator.shared.getPokemonArray().sorted { a, b in
        return a.name < b.name;
    }
    var rowView = false
    var chosenPokemonSize = CGSize(width: 80, height: 130)
    let pokemonSizeGrid = CGSize(width: 80, height: 130)
    var pokemonSizeRow: CGSize?
    let itemTextGrid = "Row view"
    let itemTextRow = "Grid view"
    var filteredPokemonData = PokemonGenerator.shared.getPokemonArray()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 30
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PokemonCard.self, forCellWithReuseIdentifier: PokemonCard.reuseIdentifier)
        return collectionView
    }()
    
//    let textView: UILabel = {
//        var label = UILabel()
//        label.text = "CHECK"
//        label.textColor = .white
//        return label
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // 1B 1D 1F
//        overrideUserInterfaceStyle = .dark
        pokemonSizeRow = CGSize(width: /*view.bounds.width / 2*/ 130, height: view.bounds.height / 2)
        navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white.withAlphaComponent(0.95)]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationItem.title = "Pokemons"
        searchController.searchBar.placeholder = "Pikachu"
        searchController.searchBar.barStyle = .black
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Row view", style: .plain, target: self, action: #selector(changeView(sender:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "More filters")
        view.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.1058823529, blue: 0.1098039216, alpha: 1)
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: 100, left: 30, bottom: 0, right: 30))
        collectionView.backgroundColor = .clear
        
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @objc func changeFilters(sender: UIBarButtonItem) {
//        view.addSubview(textView)
//        NSLayoutConstraint.activate([textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50)])
    }
    
    @objc func changeView(sender: UIBarButtonItem) {
        if rowView {
            rowView = false
            navigationItem.leftBarButtonItem?.title = itemTextGrid
            chosenPokemonSize = pokemonSizeGrid
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .vertical
                layout.itemSize = pokemonSizeGrid
            }
            collectionView.reloadData()
        } else {
            rowView = true
            navigationItem.leftBarButtonItem?.title = itemTextRow
            chosenPokemonSize = pokemonSizeRow ?? pokemonSizeGrid
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }
            collectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredPokemonData = pokemonData
        collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredPokemonData = []
        
        for pokemon in pokemonData {
            if pokemon.name.lowercased().starts(with: searchText.lowercased()) {
                filteredPokemonData.append(pokemon)
            }
        }
        
        collectionView.reloadData()
    }
}

extension PokemonCollectionVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPokemonData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pokemon = filteredPokemonData[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCard.reuseIdentifier, for: indexPath) as! PokemonCard
        cell.pokemon = pokemon
        return cell
    }
}

extension PokemonCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return chosenPokemonSize
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let pokemon = filteredPokemonData[indexPath.item]
        
        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: {
            return PokemonPreviewVC(pokemon: pokemon)
        }) { _ in
            let okItem = UIAction(title: "OK", image: UIImage(systemName: "arrow.down.right.and.arrow.up.left")) { _ in }
            return UIMenu(title: "", image: nil, identifier: nil, children: [okItem])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokemon = filteredPokemonData[indexPath.item]
        print("Selected \(pokemon.name)")
    }
}
