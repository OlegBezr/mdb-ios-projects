//
//  SOCEventCell.swift
//  MDB Social
//
//  Created by Oleg Bezrukavnikov on 10/30/21.
//

import UIKit

class SOCEventCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = String(describing: SOCEventCell.self)
    
    var creator: SOCUser? {
        didSet {
            titleView.text = event!.name + "\nby " + creator!.username
        }
    }
    
    var event: SOCEvent? {
        didSet {
            print("SOCEventCell created!")
            if let photoUrl = event?.photoURL {
                imageView.load(url: URL(string: photoUrl)!)
            }
            titleView.text = event?.name
            interestedView.text = "Interested: " + String(event!.rsvpUsers.count)
            
            FIRDatabaseRequest.shared.getUserById(
                userId: event!.creator,
                completion: { user in
                    self.creator = user
                }
            )
        }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "Check"
        label.textColor = .white
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let interestedView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "Check"
        label.textColor = .white
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .primary
//        contentView.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.1058823529, blue: 0.1098039216, alpha: 1)
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleView)
        contentView.addSubview(interestedView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1 / 2),
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleView.bottomAnchor.constraint(equalTo: interestedView.topAnchor),
            interestedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            interestedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            interestedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
