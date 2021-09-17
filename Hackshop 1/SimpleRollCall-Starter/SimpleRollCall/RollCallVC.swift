//
//  RollCallVC.swift
//  SimpleRollCall
//
//  Created by Michael Lin on 1/20/21.
//

// Import Statements
import UIKit

// Subclassing UIViewController so that we can customize it.
// Note that the prefix UI indicates that it's in the UIKit framework.
class RollCallVC: UIViewController {
    
    // A constant holding all the names.
    let names = ["Angeline", "Carol", "Dylan", "Evelyn", "Jared", "Max",
                 "Michelle", "Oleg", "Rikio", "SangJun", "Shannon"]
    
    // A variable that stores the names that are yet to be called.
    var namesToCall: [String] = []
    
    var presentNames: [String] = []
    var absentNames: [String] = []
    
    // Create a label component and make it a stored property so that we get
    // to use it later. On the right side of the assignment is a
    // closure, also known in other languages as a lambda expression
    // or anonymous function. You can learn more about it here if you want:
    // https://docs.swift.org/swift-book/LanguageGuide/Closures.html ,
    // but we will go over it more in detail in the next week. Here we
    // immediately call the closure after its creation (by adding the '()')
    // so that we get the customized and returned UILabel inside. This is
    // a common practice in programmatically creating UI components.
    var nameLabel: UILabel = {
        let label = UILabel()
        
        // This is actually `UIColor.white`, but we simplify it using a
        // Swift language feature called *Implicit Member Expression*.
        // Because Swift is expecting a UIColor type, we can
        // abbreviate it this way.
        label.textColor = .white
        
        label.text = "Placeholder"
        
        label.textAlignment = .center
        
        // Still, it's useful to know that the type is `UIFont`
        label.font = .systemFont(ofSize: 40, weight: .semibold)
        
        // This prevents Swift from translating the label's frame,
        // which is (x: 0, y: 0, width: 0, height: 0) aka CGRect.zero because we didn't
        // set it, into constraints. We will set the positioning in the
        // viewDidLoad.
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // Create a UIButton using the same technique.
    var absentButton: UIButton = {
        let button = UIButton()
        
        // Set the button image to system glyph named xmark.
        // Checkout this blog for more information about SF Symbol:
        // https://www.avanderlee.com/swift/sf-symbols-guide/
        //
        // Note that you can't just say button.image = something because
        // a button can have different states.
        // MARK: >> Your Code Here <<
        
        // Create a symbol configuration to customize the appearance of our symbol image.
        // The procedure is described in this article:
        // https://developer.apple.com/documentation/uikit/uiimage/configuring_and_displaying_symbol_images_in_your_ui
        // MARK: >> Your Code Here <<
        
        // This changes the color of the image
        // MARK: >> Your Code Here <<
        
        // Set the background color
        // What's the different between .red and .systemRed?
        // Try typing them out and hovering on it while holding option(⌥)
        // MARK: >> Your Code Here <<
        
        // Because we want to bind both buttons to the same @objc callback, we will use tag to
        // identify which button is tapped.
        button.tag = 1
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // Same stuff here
    var presentButton: UIButton = {
        let button = UIButton()
        
        // MARK: >> Your Code Here <<
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.tag = 0
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        // Add the components into view hierarchy

        // MARK: >> Your Code Here <<
        
        // Now it should look like this
        // -------view hierarchy--------
        //
        // WelcomeVC -> View (root)
        //               |- nameLabel
        //               |- acceptButton
        //               |- rejectButton
        //               \
        //
        // -----------------------------
        // 80% of the time the order of which you add the subviews doesn't matter. But when
        // two subviews overlap, the one you added later (at the bottom) would appears on top.
        
        // Next step, let's make the constraints
        // (0, 0)
        //  ___________________ -->> x
        // /         |         \
        // |         | 200pt   |
        // | 50pt    |         |
        // |-->--| label |--<--|
        // |         |    -50pt|
        // |         |         |
        // |         |         |
        // |         | 300pt   |
        // |         |         |
        // |     60pt|60pt     |
        // |->-|  |--|--|  |-<-| This implicitly set each button to 74 points
        // | |       |       | | wide given the size of an iPhone 12 Pro Max
        // |80pt     |     80pt| which is 428pt x 845pt. This does make
        // |         |         | it smaller on other devices though and we
        // |         |         | will talk about how to deal with that in
        // \         |         / the future.
        //  -------------------
        // y
        NSLayoutConstraint.activate([
            // MARK: >> Your Code Here <<
        ])
        
        // Bind the @objc function to the button's touchUpInside event. Touch up inside means
        // the users tap and lift the finger inside the button, which is basically a regular
        // touch.
        presentButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        absentButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    }
    
    // Use viewWillAppear lifecycle callback to populate the namesToCall list. Why not viewDidLoad?
    // Because we want it to be able to reset when we come back from the ResultVC.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK: >> Your Code Here <<
    }
    
    // As the name says, called after subviews finish the layout.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // A little trick that makes the button round.
        //
        // We can't do this in viewDidLoad because at the time we were just setting up
        // the constraints, and the buttons haven't been layouted yet. So
        // `button.frame.width` wouldn't reflect the actual width of the view
        // (it's actually gonna be .zero again).
        // MARK: >> Your Code Here <<
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        
        // MARK: >> Your Code Here <<
        
        // UIView.animate() is incredibly versatile. You can use it to animate
        // opacity, color, and even constraints! Here we use it to create a simple
        // fade in fade out animation.
        UIView.animate(withDuration: 0.3, animations: {
            self.nameLabel.alpha = 0
        }, completion: { _ in
            // MARK: >> Your Code Here <<
            UIView.animate(withDuration: 0.3, animations: {
                self.nameLabel.alpha = 1
            })
        })
    }
    
    func presentResult() {
        let vc = ResultVC()
        
        // MARK: >> Your Code Here <<
        
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true, completion: nil)
    }
}

