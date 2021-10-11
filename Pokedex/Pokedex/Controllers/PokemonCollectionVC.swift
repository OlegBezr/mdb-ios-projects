//
//  PokemonCollectionVC.swift
//  Pokedex
//
//  Created by Oleg Bezrukavnikov on 10/8/21.
//

import UIKit

class PokemonCollectionVC: UIViewController, UISearchBarDelegate {
    let searchController = UISearchController()
    let pokemonData = PokemonGenerator.shared.getPokemonArray().sorted { a, b in
        return a.name < b.name;
    }
    var filteredPokemonData = PokemonGenerator.shared.getPokemonArray().sorted { a, b in
        return a.name < b.name;
    }
    var isInRowView = false
    var chosenPokemonSize = CGSize(width: 80, height: 130)
    let pokemonSizeGrid = CGSize(width: 80, height: 130)
    var pokemonSizeRow: CGSize?
    let rowViewText = "Row view"
    let gridViewText = "Grid view"
    
    var moreFiltersText = "More filters"
    var lessFiltersText = "Less filters"
    var moreFilters = false
    var pokemonGridTopOffset = 0.0
    var filtersHeight = 130.0
    var chosenTypes: Set<PokeType> = []
    var searchText = ""
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 30
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.register(PokemonCard.self, forCellWithReuseIdentifier: PokemonCard.reuseIdentifier)
        return collectionView
    }()
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "No results found 😞"
        label.isHidden = true
        label.isEnabled = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let verticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillEqually
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isHidden = true
        return stack
    }()
    
    private let horizontalStackViews: [UIStackView] = {
        return (0..<4).map { index in
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.alignment = .leading
            stack.distribution = .fillEqually
            stack.spacing = 5
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }
    }()
    
    let filters: [UIButton] = {
        let pokeTypes = PokeType.allCases
        return (0..<pokeTypes.count).map { index in
            let button = UIButton()
            button.tag = index
            button.backgroundColor = .darkGray
            button.titleEdgeInsets = UIEdgeInsets.init(
                top: 0, left: 3, bottom: 0, right: 3
            )
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.setTitleColor(.white, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(PokeType.allCases[index].rawValue, for: .normal)
        
            return button
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationbar()
        setFilters()
        pokemonSizeRow = CGSize(width: 200, height: view.bounds.height / 3)
        
        view.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.1058823529, blue: 0.1098039216, alpha: 1)
        view.addSubview(verticalStackView)
        view.addSubview(collectionView)
        view.addSubview(noResultsLabel)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        filters.forEach { button in
            button.addTarget(
                self,
                action: #selector(pokeFilterTapped(_:)),
                for: .touchUpInside
            )
        }
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 0
            ),
            noResultsLabel.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            noResultsLabel.centerYAnchor.constraint(
                equalTo: collectionView.centerYAnchor
            ),
//            noResultsLabel.heightAnchor.constraint(
//                equalToConstant: 50.0
//            ),
//            noResultsLabel.widthAnchor.constraint(equalToConstant: 200.0),
            verticalStackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 0
            ),
            verticalStackView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            verticalStackView.heightAnchor.constraint(
                equalToConstant: filtersHeight
            )
        ] + horizontalStackViews.map { stack in
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        })
    }
    
    override func viewDidLayoutSubviews() {
        // USE safeArea bottom?
        collectionView.frame = view.bounds.inset(
            by: UIEdgeInsets(top: view.safeAreaInsets.top + pokemonGridTopOffset, left: 20, bottom: 0, right: 20)
        )
        filters.forEach { button in
            button.layer.cornerRadius = button.frame.height / 4
            button.clipsToBounds = true
        }
    }
    
    func setFilters() {
        for i in 0..<filters.count {
            horizontalStackViews[i / 5].addArrangedSubview(filters[i])
        }
        for i in 0..<horizontalStackViews.count {
            verticalStackView.addArrangedSubview(horizontalStackViews[i])
        }
    }
    
    func setNavigationbar() {
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: rowViewText, style: .plain, target: self, action: #selector(changeView(sender:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: moreFiltersText, style: .plain, target: self, action: #selector(changeFilters(_:)))
    }
    
    @objc func changeFilters(_ sender: UIBarButtonItem) {
        pokemonGridTopOffset = 0
        if (!moreFilters) {
            pokemonGridTopOffset = filtersHeight + 10
        }
        collectionView.frame = view.bounds.inset(
            by: UIEdgeInsets(
                top: view.safeAreaInsets.top + pokemonGridTopOffset,
                left: 20,
                bottom: 0,
                right: 20
            )
        )
        moreFilters = !moreFilters
        navigationItem.rightBarButtonItem?.title = moreFilters ? lessFiltersText
            : moreFiltersText
        chosenTypes.removeAll()
        verticalStackView.isHidden = !moreFilters
        changeFilterButtonsColor()
        filterData()
    }
    
    @objc func pokeFilterTapped(_ sender: UIButton) {
        let pokeTypeIndex = sender.tag
        let pokeType = PokeType.allCases[pokeTypeIndex]
        if chosenTypes.contains(pokeType) {
            chosenTypes.remove(pokeType)
        } else {
            chosenTypes.insert(pokeType)
        }
        
        changeFilterButtonsColor()
        filterData()
    }
    
    func changeFilterButtonsColor() {
        filters.forEach { button in
            let pokeTypeIndex = button.tag
            let pokeType = PokeType.allCases[pokeTypeIndex]
            let chosen = chosenTypes.contains(pokeType)
            let color = chosen ? UIColor.systemBlue: UIColor.darkGray
            button.backgroundColor = color
        }
    }
    
    @objc func changeView(sender: UIBarButtonItem) {
        if isInRowView {
            isInRowView = false
            navigationItem.leftBarButtonItem?.title = rowViewText
            chosenPokemonSize = pokemonSizeGrid
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .vertical
                layout.itemSize = pokemonSizeGrid
            }
            collectionView.reloadData()
        } else {
            isInRowView = true
            navigationItem.leftBarButtonItem?.title = gridViewText
            chosenPokemonSize = pokemonSizeRow ?? pokemonSizeGrid
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }
            collectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = ""
        filterData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        filterData()
    }
    
    func filterData() {
        if (moreFilters && !chosenTypes.isEmpty) {
            filteredPokemonData = pokemonData.filter { pokemon in
                var check = true
                chosenTypes.forEach { chosenType in
                    if !pokemon.types.contains(chosenType) {
                        check = false
                    }
                }
                return check
            }
        } else {
            filteredPokemonData = pokemonData
        }
        
        filteredPokemonData = filteredPokemonData.filter { pokemon in
            pokemon.name.lowercased().starts(with: searchText.lowercased())
        }
        noResultsLabel.isHidden = true
        if filteredPokemonData.isEmpty {
            noResultsLabel.isHidden = false
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
    
//    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//        let pokemon = filteredPokemonData[indexPath.item]
//
//        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: {
//            return PokemonPreviewVC(pokemon: pokemon)
//        }) { _ in
//            let okItem = UIAction(title: "OK", image: UIImage(systemName: "arrow.down.right.and.arrow.up.left")) { _ in }
//            return UIMenu(title: "", image: nil, identifier: nil, children: [okItem])
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokemon = filteredPokemonData[indexPath.item]
        let vc = PokemonVC(pokemon: pokemon)
        present(vc, animated: true, completion: nil)
    }
}
