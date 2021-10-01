//
//  SymbolProvider.swift
//  SymbolProvider
//
//  Created by Michael Lin on 9/26/21.
//

import Foundation
import SwiftyJSON
import UIKit

class SymbolProvider {
    
    static let symbols: [SFSymbol] = {
        guard let path = Bundle.main.path(forResource: "sf-symbols", ofType: "json") else { return [] }
        do {
            let data = try NSData(contentsOfFile: path) as Data
            let json = try JSON(data: data)
            let names = json[0]["items"].array!
            return names.map { (name: JSON) -> SFSymbol in
                SFSymbol(name: name.string!, image: UIImage(systemName: name.string!)!)
            }
        } catch {
            return []
        }
    }()
}
