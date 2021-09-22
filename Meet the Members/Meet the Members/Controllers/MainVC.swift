//
//  MainVC.swift
//  Meet the Members
//
//  Created by Michael Lin on 1/18/21.
//

import Foundation
import UIKit

class MainVC: UIViewController {
    
    // Create a property for our timer, we will initialize it in viewDidLoad
    var timer: Timer?
    var question: QuestionProvider.Question?
    
    // MARK: STEP 7: UI Customization
    // Action Items:
    // - Customize your imageView and buttons.
    
    let imageView: UIImageView = {
        let view = UIImageView()
        
        // MARK: >> Your Code Here <<
    
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let buttons: [UIButton] = {
        return (0..<4).map { index in
            let button = UIButton()

            // Tag the button its index
            button.tag = index
            button.backgroundColor = .systemGreen.withAlphaComponent(0.5)
            button.titleEdgeInsets = UIEdgeInsets.init(
                top: 0, left: 3, bottom: 0, right: 3
            )
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.setTitleColor(.darkGray, for: .normal)
            
            // MARK: >> Your Code Here <<
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }
        
    }()
    
    // MARK: STEP 10: Stats Button
    // Action Items:
    // - Follow the examples you've seen so far, create and
    // configure a UIButton for presenting the StatsVC. Only the
    // callback function `didTapStats(_:)` was written for you.
    
    // MARK: >> Your Code Here <<
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        // Create a timer that calls timerCallback() every one second
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        getNextQuestion()
        
        // MARK: STEP 6: Adding Subviews and Constraints
        // Action Items:
        // - Add imageViews and buttons to the root view.
        // - Create and activate the layout constraints.
        // - Run the App
        
        // Additional Information:
        // If you don't like the default presentation style,
        // you can change it to full screen too! However, in this
        // case you will have to find a way to manually to call
        // dismiss(animated: true, completion: nil) in order
        // to go back.
        //
        // modalPresentationStyle = .fullScreen
        
        view.addSubview(imageView);
        for i in 0...3 {
            view.addSubview(buttons[i]);
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: 50
            ),
            imageView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            imageView.heightAnchor.constraint(
                lessThanOrEqualToConstant: view.bounds.width - 20
            ),
            imageView.heightAnchor.constraint(
                equalTo: imageView.widthAnchor,
                multiplier: (imageView.image?.size.height ?? 1) / (imageView.image?.size.width ?? 1)
            ),
            buttons[0].topAnchor.constraint(
                equalTo: view.centerYAnchor,
                constant: 100
            ),
            buttons[1].topAnchor.constraint(
                equalTo: buttons[0].topAnchor
            ),
            buttons[0].trailingAnchor.constraint(
                equalTo: view.centerXAnchor,
                constant: -20
            ),
            buttons[1].leadingAnchor.constraint(
                equalTo: view.centerXAnchor,
                constant: 20
            ),
            buttons[2].topAnchor.constraint(
                equalTo: buttons[0].bottomAnchor,
                constant: 30
            ),
            buttons[3].topAnchor.constraint(
                equalTo: buttons[2].topAnchor
            ),
            buttons[2].trailingAnchor.constraint(
                equalTo: view.centerXAnchor,
                constant: -20
            ),
            buttons[3].leadingAnchor.constraint(
                equalTo: view.centerXAnchor,
                constant: 20
            ),
        ] + buttons.map({ button in
                return button.widthAnchor.constraint(
                    equalToConstant: view.bounds.width / 2 - 50
                )
            }) + buttons.map({ button in
                return button.heightAnchor.constraint(
                    equalToConstant: 50
                )
            })
        )
        
        // MARK: >> Your Code Here <<
        
        // MARK: STEP 9: Bind Callbacks to the Buttons
        // Action Items:
        // - Bind the `didTapAnswer(_:)` function to the buttons.
        
        // MARK: >> Your Code Here <<
        buttons.forEach { button in
            button.addTarget(
                self,
                action: #selector(didTapAnswer(_:)),
                for: .touchUpInside
            )
        }
        
        
        // MARK: STEP 10: Stats Button
        // See instructions above.
        
        // MARK: >> Your Code Here <<
    }
    
    // What's the difference between viewDidLoad() and
    // viewWillAppear()? What about viewDidAppear()?
    override func viewWillAppear(_ animated: Bool) {
        // MARK: STEP 13: Resume Game
        // Action Items:
        // - Reinstantiate timer when view appears
        
        // MARK: >> Your Code Here <<
    }
    
    override func viewDidLayoutSubviews() {
        for i in 0...3 {
            buttons[i].layer.cornerRadius = 10
            buttons[i].clipsToBounds = true
        }
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
    }
    
    func getNextQuestion() {
        // MARK: STEP 5: Data Model
        // Action Items:
        // - Get a question instance from `QuestionProvider`
        // - Configure the imageView and buttons with information from
        //   the question instance
        
        // MARK: >> Your Code Here <<
        if let newQuestion = QuestionProvider.shared.nextQuestion() {
            question = newQuestion
            imageView.image = newQuestion.image
            for i in 0...3 {
                buttons[i].setTitle(newQuestion.choices[i], for: .normal)
            }
        }
        else {
            print("Error")
        }
    }
    
    // MARK: STEP 8: Buttons and Timer Callback
    // Action Items:
    // - Complete the callback function for the 4 buttons.
    // - Complete the callback function for the timer instance
    //
    // Additional Information:
    // Take some time to plan what should be in here.
    // The 4 buttons should share the same callback.
    //
    // Add instance properties and/or methods
    // to the class if necessary. You may need to come back
    // to this step later on.
    //
    // Hint:
    // - The timer will fire every one second.
    // - You can use `sender.tag` to identify which button is pressed.
    @objc func timerCallback() {
        
        // MARK: >> Your Code Here <<
    }
    
    @objc func didTapAnswer(_ sender: UIButton) {
        if (sender.tag == question?.choices.firstIndex(of: question?.answer ?? "")) {
            print("Right")
        }
        else {
            print("Wrong")
        }
    }
    
    @objc func didTapStats(_ sender: UIButton) {
        
        let vc = StatsVC(data: "Hello")
        
        vc.modalPresentationStyle = .fullScreen
        
        // MARK: STEP 11: Going to StatsVC
        // When we are navigating between VCs (e.g MainVC -> StatsVC),
        // we often need a mechanism for transferring data
        // between view controllers. There are many ways to achieve
        // this (initializer, delegate, notification center,
        // combined, etc.). We will start with the easiest one today,
        // which is custom initializer.
        //
        // Action Items:
        // - Pause the game when stats button is tapped
        // - Read the example in StatsVC.swift, and replace it with
        //   your custom init for `StatsVC`
        // - Update the call site here on line 139
        
        present(vc, animated: true, completion: nil)
    }
}
