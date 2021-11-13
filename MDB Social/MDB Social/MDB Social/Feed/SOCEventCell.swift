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
            setTitle()
        }
    }
    
    var event: SOCEvent? {
        didSet {
            imageView.image = nil
            if let event = event {
                if let url = URL(string: event.photoURL) {
                    imageView.load(url: url)
                }
                titleView.text = event.name
                interestedView.text = "Interested: " + String(event.rsvpUsers.count)
                
                FIRDatabaseRequest.shared.getUserById(
                    userId: event.creator,
                    completion: { user in
                        self.creator = user
                    }
                )
            }
        }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = nil
        iv.backgroundColor = .primary
        iv.tintColor = .black
        iv.contentMode = .scaleAspectFit
        
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "Check"
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let interestedView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "Check"
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
//        contentView.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.1058823529, blue: 0.1098039216, alpha: 1)
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleView)
        contentView.addSubview(interestedView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1 / 2),
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleView.bottomAnchor.constraint(equalTo: interestedView.topAnchor, constant: -5),
            interestedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            interestedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            interestedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        imageView.layer.cornerRadius = 10
    }
    
    func setTitle() {
        let name = event!.name
        let attrName = NSMutableAttributedString(string: name)
        let byString = "\nby "
        let attrByString = NSMutableAttributedString(string: byString)
        let creatorName = creator!.username
        let attrCreator = NSMutableAttributedString(string: creatorName)
        attrCreator.addAttribute(
            .foregroundColor,
            value: UIColor.primary,
            range: NSRange(location: 0, length: creatorName.count)
        )
        let finalAttrString = NSMutableAttributedString()
        finalAttrString.append(attrName)
        finalAttrString.append(attrByString)
        finalAttrString.append(attrCreator)
        titleView.attributedText = finalAttrString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
