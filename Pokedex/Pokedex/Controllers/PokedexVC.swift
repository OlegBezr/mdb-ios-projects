////
////  ViewController.swift
////  Pokedex
////
////  Created by Michael Lin on 2/18/21.
////
//
//import UIKit
//
//class PokedexVC: UIViewController {
//    let pokemonCards: [PokemonCard]
//
//    init() {
//        let pokemons = PokemonGenerator.shared.getPokemonArray()
//        pokemonCards = {
//            return pokemons.map { pokemon in
//                let pokemonCard = PokemonCard(frame: <#CGRect#>, pokemon: pokemon)
//                return pokemonCard
//            }
//        }()
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }
//}
//
