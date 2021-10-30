//
//  FeedVC.swift
//  MDB Social No Starter
//
//  Created by Michael Lin on 10/17/21.
//

import UIKit
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class FeedVC: UIViewController {
    private let signOutButtonHeight = 44.0
    
    private var events: [SOCEvent] = [
    ]
    
    private let signOutButton: UIButton = {
        var filled = UIButton.Configuration.filled()
        
        let btn = LoadingButton()
        btn.layer.backgroundColor = UIColor.primary.cgColor
        btn.setTitle("Sig  Out", for: .normal)
        btn.setTitleColor(.white, for: .normal)

        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btn.isUserInteractionEnabled = true
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(SOCEventCell.self, forCellWithReuseIdentifier: SOCEventCell.reuseIdentifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.addSubview(signOutButton)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        NSLayoutConstraint.activate([
            signOutButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 0
            ),
            signOutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 2),
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.topAnchor.constraint(
                equalTo: signOutButton.bottomAnchor,
                constant: 20
            ),
        ])
        
        FIRDatabaseRequest.shared.getEvents { events in
            self.events = events.sorted(by: { a, b in
                return a.startDate > b.startDate
            })
            print(self.events[0].name)
            print(self.events.count)
            self.collectionView.reloadData()
            print(self.collectionView.visibleCells.count)
        }
        
        signOutButton.layer.cornerRadius = signOutButtonHeight / 2
        signOutButton.addTarget(self, action: #selector(didTapSignOut(_:)), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.frame = view.bounds.inset(
            by: UIEdgeInsets(top: view.safeAreaInsets.top + signOutButtonHeight + 20, left: 20, bottom: 0, right: 20)
        )
    }
    
    @objc func didTapSignOut(_ sender: UIButton) {
        SOCAuthManager.shared.signOut {
            guard let window = UIApplication.shared
                    .windows.filter({ $0.isKeyWindow }).first else { return }
            let vc = UIStoryboard(name: "Auth", bundle: nil).instantiateInitialViewController()
            window.rootViewController = vc
            let options: UIView.AnimationOptions = .transitionCrossDissolve
            let duration: TimeInterval = 0.3
            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
        }
    }
}

extension FeedVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let event = events[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SOCEventCell.reuseIdentifier, for: indexPath) as! SOCEventCell
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.event = event
        return cell
    }
}

extension FeedVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width / 2 + 40, height: 200)
    }
}
