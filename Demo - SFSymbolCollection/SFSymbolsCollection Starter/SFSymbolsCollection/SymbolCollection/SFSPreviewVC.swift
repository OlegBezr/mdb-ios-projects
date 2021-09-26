//
//  SFSPreviewVC.swift
//  SFSPreviewVC
//
//  Created by Michael Lin on 9/26/21.
//

import UIKit

class SFSPreviewVC: UIViewController {
    
    private let imageView = UIImageView()

    override func viewDidLoad() {
        view.addSubview(imageView)
        let width = 110
        let height = 110
        preferredContentSize = CGSize(width: width, height: height)
    }
    
    override func viewDidLayoutSubviews() {
        imageView.frame = view.bounds.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }

    init(symbol: SFSymbol) {
        super.init(nibName: nil, bundle: nil)

        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.tintColor = .white
        imageView.image = symbol.image
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
