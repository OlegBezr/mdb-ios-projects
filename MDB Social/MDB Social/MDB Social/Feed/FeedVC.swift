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
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 50, right: 0)
        collectionView.backgroundColor = .clear
        collectionView.register(SOCEventCell.self, forCellWithReuseIdentifier: SOCEventCell.reuseIdentifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(didTapSignOut(_:)))
        navigationItem.title = "Events"
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 0
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
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.frame = view.bounds.inset(
            by: UIEdgeInsets(top: view.safeAreaInsets.top, left: 20, bottom: 0, right: 20)
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
        let width = view.bounds.width / 2 + 40
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }
}
