//
//  PokemonVC.swift
//  Pokedex
//
//  Created by Oleg Bezrukavnikov on 10/8/21.
//

import UIKit

class PaddedImageView: UIImageView {
    override var alignmentRectInsets: UIEdgeInsets {
        return UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
    }
}

class PokemonVC: UIViewController  {
    var pokemon: Pokemon
    var showingGif: Bool = false
    
    private let mainViewStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private let imageView: PaddedImageView = {
        let iv = PaddedImageView()
        iv.tintColor = .white
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        return iv
    }()
    private let titleView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let idView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let statsViews: [UILabel] = {
        return (0..<5).map {index in
            let label = UILabel()
            label.font = .systemFont(ofSize: 26)
            label.textColor = .white
            label.textAlignment = .center
            label.numberOfLines = 2
            
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }
    }()

    init(pokemon: Pokemon) {
        self.pokemon = pokemon
        super.init(nibName: nil, bundle: nil)
        
        if let defaultImage = UIImage(named: "pikachu") {
            imageView.image = defaultImage
        }
        if let largeImageUrl = pokemon.imageUrlLarge {
            imageView.load(url: largeImageUrl)
        }
        
        setTitle()
        idView.text = "id: " + String(pokemon.id)
        statsViews[0].text = "❤️health: " + String(pokemon.health)
        statsViews[1].text = "💨speed: " + String(pokemon.speed)
        statsViews[2].text = "🔥attack: " + String(pokemon.attack) + ", special: " + String(pokemon.specialAttack)
        statsViews[3].text = "🛡️defense: " + String(pokemon.defense) + ", special: " + String(pokemon.specialDefense)
        statsViews[4].text = "🏆total: " + String(pokemon.total)
    }
    
    func setTitle() {
        let name = pokemon.name + ": "
        let attrName = NSMutableAttributedString(string: name)
        var types = ""
        pokemon.types.forEach { type in
           types += type.rawValue + ", "
        }
        types = String(types.dropLast())
        types = String(types.dropLast())
        let attrTypes = NSMutableAttributedString(string: types)
        attrTypes.addAttribute(
            .foregroundColor,
            value: UIColor.systemBlue,
            range: NSRange(location: 0, length: types.count)
        )
        let finalAttrString = NSMutableAttributedString()
        finalAttrString.append(attrName)
        finalAttrString.append(attrTypes)
        titleView.attributedText = finalAttrString
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        if (showingGif) {
            if let largeImageUrl = pokemon.imageUrlLarge {
                imageView.load(url: largeImageUrl)
            } else if let defaultImage = UIImage(named: "pikachu") {
                imageView.image = defaultImage
            }
        } else {
            if let gifUrl = pokemon.imageUrlAnimated {
                imageView.loadGif(url: gifUrl)
            } else if let defaultImage = UIImage(named: "pikachu") {
                imageView.image = defaultImage
            }
        }
        showingGif = !showingGif
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.1058823529, blue: 0.1098039216, alpha: 1)
        
        view.addSubview(imageView)
        view.addSubview(titleView)
        view.addSubview(idView)
        view.addSubview(mainViewStack)
        
        statsViews.forEach { statView in
            mainViewStack.addArrangedSubview(statView)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            imageView.heightAnchor.constraint(equalToConstant: view.bounds.height / 3),
            imageView.widthAnchor.constraint(equalToConstant: view.bounds.width - 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            idView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 10),
            idView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            idView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainViewStack.topAnchor.constraint(equalTo: idView.bottomAnchor, constant: 30),
            mainViewStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
        ])
    }
    
    override func viewDidLayoutSubviews() {
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

