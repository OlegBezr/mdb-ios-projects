//
//  ViewController.swift
//  Pokedex
//
//  Created by Michael Lin on 2/18/21.
//

import UIKit

class PokedexVC: UIViewController {
    
    let pokemons = PokemonGenerator.shared.getPokemonArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

