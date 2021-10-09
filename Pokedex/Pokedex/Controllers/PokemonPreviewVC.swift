//
//  PokemonPreviewVC.swift
//  Pokedex
//
//  Created by Oleg Bezrukavnikov on 10/9/21.
//

import UIKit

class PokemonPreviewVC: UIViewController {
    
    private let imageView = UIImageView()

    override func viewDidLoad() {
        view.addSubview(imageView)
        let width = 150
        let height = 150
        preferredContentSize = CGSize(width: width, height: height)
    }
    
    override func viewDidLayoutSubviews() {
        imageView.frame = view.bounds.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }

    init(pokemon: Pokemon) {
        super.init(nibName: nil, bundle: nil)
        if let imageUrl = pokemon.imageUrl {
            imageView.load(url: imageUrl)
        }

        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.tintColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
