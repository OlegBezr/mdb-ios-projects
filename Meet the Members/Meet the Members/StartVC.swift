//
//  StartVC.swift
//  Meet the Member
//
//  Created by Michael Lin on 1/18/21.
//

import UIKit

// MARK: STEP 0: Before We Start
// Before we kick off our first project. You should know that
// by no means you should feel obligated to follow these steps.
// Finishing all of the steps does NOT mean finishing the project.
// You should consult the spec to see what needs to be done.
// These steps are just a order of doing things that I think may
// help you navigate through the starters code. So feel free to
// explore and write your own stuff anywhere else, or circle back to
// the steps that you've finished - do it anyway you like, as long as
// you follow the specs. But please make sure that you read and
// understand the code/comments, they contain information that will
// be super helpful in the future. The project is designed to
// be challenging. So budget your time. The general rule of thumb
// for asking question: if you ever get stuck on something for
// more than 30 minutes and still have no clue, ask for help!

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
        
        // Must have if you are using constraints
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Start", for: .normal)
        
        button.setTitleColor(.blue, for: .normal)
        
        // MARK: STEP 1: UIButton Customization
        // Create you own customized UIButton.
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
        // Read through the following code and make sure that you understand
        // what it's doing. Then add your constraints for the start button
        // in the *second* NSLayoutConstraint.activate([]).
        //
        // Add our label as a subview of the root UIView of WelcomeVC
        // -------view hierarchy--------
        //
        // WelcomeVC -> View (root)
        //               |- welcomeLabel
        //               \
        //
        // -----------------------------
        // Constraints can only be created in the same view hierarchy. So you have to add the view to
        // subview before creating constraints.
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
        // This is another way of activating constraints. It is the same as writing out individual
        // constraints and add .isActive = true
        NSLayoutConstraint.activate([
            // You can use the view.topAnchor. But it's different, why?
            // https://developer.apple.com/documentation/uikit/uiview/positioning_content_relative_to_the_safe_area
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            
            // For your understanding: welcomeLabel.leadingAnchor = view.leadingAnchor + 50
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            // welcomeLabel.trailingAnchor = view.trailingAnchor - 50
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
        // Again, add the start button as a subview of the root UIView of WelcomeVC.
        // -------view hierarchy--------
        //
        // WelcomeVC -> View (root)
        //               |- welcomeLabel
        //               |- startButton
        //               \
        //
        // -----------------------------
        view.addSubview(startButton)
        
        // A view must be in the hierarchy before constraints are added.
        NSLayoutConstraint.activate([
            // MARK: >> Your Code Here <<
        ])
        
        // MARK: STEP 3: Adding Callbacks
        // Just read the code.
        //
        // This will add the didTapStart as the *callback* function of startButton's touchUpInside event.
        // Notice the @objc notation in the function declaration. It is required if we want to
        // reference the function using selector.
        startButton.addTarget(self, action: #selector(didTapStart(_:)), for: .touchUpInside)
    }
    
    // Trivia: Why do we need the @objc here
    // https://www.hackingwithswift.com/example-code/language/what-is-the-objc-attribute
    @objc func didTapStart(_ sender: UIButton) {
        // Initialize an instance of MainVC
        let vc = MainVC()
        // Use the present function to modally present the MainVC
        present(vc, animated: true, completion: nil)
    }
}

