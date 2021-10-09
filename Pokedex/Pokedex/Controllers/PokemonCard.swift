//
//  PokemonCard.swift
//  Pokedex
//
//  Created by Oleg Bezrukavnikov on 10/8/21.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

class PokemonCard: UICollectionViewCell  {
    static let reuseIdentifier: String = String(describing: PokemonCard.self)
    
    var pokemon: Pokemon? {
        didSet {
            if let imageUrl = pokemon?.imageUrl {
                imageView.load(url: imageUrl)
            }
            titleView.text = pokemon?.name
        }
    }
    
    private let titleView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        iv.contentMode = UIView.ContentMode.scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override init(frame: CGRect) {
        if let defaultImage = UIImage(named: "pikachu") {
            imageView.image = defaultImage
        }
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.1058823529, blue: 0.1098039216, alpha: 1)
        contentView.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.1058823529, blue: 0.1098039216, alpha: 1)
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: titleView.topAnchor, constant: -5),
            imageView.heightAnchor.constraint(equalToConstant: frame.height * 2 / 3),
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }
    
//    init(pokemon: Pokemon) {
//        self.pokemon = pokemon;
//
//        if let defaultImage = UIImage(named: "pikachu") {
//            imageView.image = defaultImage
//        }
//        if let imageUrl = pokemon.imageUrl {
//            imageView.load(url: imageUrl)
//        }
//        titleView.text = pokemon.name
//        imageView.clipsToBounds = true
//        imageView.contentMode = .scaleAspectFit
//        imageView.backgroundColor = .clear
//        imageView.tintColor = .white
//    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
