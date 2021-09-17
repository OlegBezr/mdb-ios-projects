//
//  StartVC.swift
//  Meet the Members
//
//  Created by Michael Lin on 1/18/21.
//

import UIKit

// MARK: STEP 0 - Before We Start
// Before we kick off our first project. You should know that
// you are not obligated to follow the steps. Depending on how
// you approach things, finishing all of the steps might not
// mean finishing the project. Be sure to check the spec to
// see what needs to be done.

// Also please make sure that you read understand the skeleton
// code and comments, they will be super helpful in the future.

class StartVC: UIViewController {
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        
        // == UIColor.darkGray
        label.textColor = .darkGray
        
        label.text = "Meet the Member"
        
        // == NSTextAlignment(expected type).center
        label.textAlignment = .center
        
        // == UIFont.systemFont(ofSize: 27, UIFont.weight.medium)
        label.font = .systemFont(ofSize: 27, weight: .medium)
        
        // Must have if you are using constraints.
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Start", for: .normal)
        
        button.setTitleColor(.blue, for: .normal)
        
        // MARK: STEP 1: UIButton Customization
        // Action Items:
        // - Customize `UIButton` through modifying its property
        //
        // Hints: Wondering what customizations are available?
        // Type out `button.` and Swift will show you a bunch of options, then
        // keep typing to narrow it down (try 'background').
        // You can also go to https://developer.apple.com/documentation/uikit/uibutton#topics
        // where you will find all the available APIs.
        
        // MARK: >> Your Code Here <<
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white // == UIColor(expected type).white
        
        // MARK: STEP 2: Subviews and Constraints
        // Action Items:
        // - Read the example on adding subviews and creating constraints
        //   for `welcomeLabel`
        // - Add layout constraints for `startButton`
        // - Add `startButton` as a subview of WelcomeVC's root view
        //
        // MARK: Example Area
        // -------view hierarchy--------
        //
        // WelcomeVC -> View (root)
        //               |- welcomeLabel
        //               \
        //
        // -----------------------------
        // - Constraints can only be created in the same view hierarchy.
        //   So you have to add the view subview before creating constraints.
        view.addSubview(welcomeLabel)
        
        
        // And add the constraints
        // (0, 0)
        //  ___________________ -->> x
        // /         |         \
        // |         | 100pt   |
        // | 50pt    |         |
        // |-----| label |-----|
        // |              -50pt
        // |
        // y
        //
        NSLayoutConstraint.activate([
            // You can use the view.topAnchor. But it's different, why?
            // https://developer.apple.com/documentation/uikit/uiview/positioning_content_relative_to_the_safe_area
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            
            // For your understanding, here's what it's saying:
            //     welcomeLabel.leadingAnchor = view.leadingAnchor + 50
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            //     welcomeLabel.trailingAnchor = view.trailingAnchor - 50
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
        // MARK: >> Your Code Here <<
        
        NSLayoutConstraint.activate([
            // MARK: >> Your Code Here <<
        ])
        
        
        // MARK: STEP 3: Adding Callbacks
        // Action Item:
        // - Read the example below
        // - Run target "Meet the Members" on the simulator.
        //   (You probably only need to click the play button on the top)
        //   Does the button appear where you expect?
        // - After this, you will go to Support Files/SceneDelegate.swift
        //   to complete step 4.
        //
        // Additional Information:
        // - The `addTarget` method will bind a function selector to the
        //   touchUpInside event. In English that means this function will
        //   be called when we tap the button.
        // - Notice the @objc decorator before the `didTapStart` function. We
        //   need this when we want to expose a method or property to objective-c
        //   runtime. Since selector is an objective-c only feature, we will
        //   need it here.
        startButton.addTarget(self, action: #selector(didTapStart(_:)), for: .touchUpInside)
    }
    
    @objc func didTapStart(_ sender: UIButton) {
        // Initialize an instance of MainVC
        let vc = MainVC()
        // Use the present function to modally present the MainVC
        present(vc, animated: true, completion: nil)
    }
}

