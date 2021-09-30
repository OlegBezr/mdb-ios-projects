//
//  PokemonGenerator.swift
//  Pokedex
//
//  Created by SAMEER SURESH on 9/25/16.
//  Updated by ANMOL PARANDE on 01/25/2020
//  Updated by MICHAEL LIN on 02/18/21
//  Copyright © 2021 MDB. All rights reserved.

import Foundation

class PokemonGenerator {
    
    static let shared = PokemonGenerator()
    
    func getPokemonArray() -> [Pokemon] {
        guard let url = Bundle.main.url(forResource: "pokemons", withExtension: "json") else { print("Couldn't find Pokemon filepath")
            return []
        }
        guard let jsonData = try? Data(contentsOf: url) else {
            print("Couldn't load file")
            return []
        }
        
        
        
        let decoder = JSONDecoder()
        
        // Generally this is bad practice, but we need this decoding for the app to load, and the force unwrap will tell us why the error is occurring
        return try! decoder.decode([Pokemon].self, from: jsonData)
    }
}
