//
//  ResultVC.swift
//  SimpleRollCall
//
//  Created by Michael Lin on 2/13/21.
//

import UIKit

class ResultVC: UIViewController {
    
    // UIStackView: create a view stack with self-managed layouts.
    private let mainViewStack: UIStackView = {
        let stack = UIStackView()
        
        // There are two axis direction: .vertical and .horizontal
        stack.axis = .vertical
        
        // Equal spacing means each view will be spaced equally. Because
        // in our case stack.spacing is set in the next line. The height
        // of the stack view is inferred (i.e. we can get away with not
        // providing an explicit height in our constraints.)
        stack.distribution = .equalSpacing
        
        stack.spacing = 40
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private let presentNamesLabel: UILabel = {
        let label = UILabel()
        
        // This means the number of lines won't be set to an
        // arbitrary value. Instead, it will be determined by the
        // content of the label.
        label.numberOfLines = 0
        
        label.textColor = .white
        
        let attrText = NSAttributedString(string: "Present: ", attributes: [
            .font: UIFont.italicSystemFont(ofSize: 18)
        ])
        
        label.attributedText = attrText
        
        return label
    }()
    
    private let absentNamesLabel: UILabel = {
        let label = UILabel()
        
        // This means the number of lines won't be set to an
        // arbitrary value. Instead, it will be determined by the
        // content of the label.
        label.numberOfLines = 0
        
        label.textColor = .white
        
        let attrText = NSAttributedString(string: "Absent: ", attributes: [
            .font: UIFont.italicSystemFont(ofSize: 18)
        ])
        
        label.attributedText = attrText
        
        return label
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Reset", for: .normal)
        
        button.setTitleColor(.white, for: .normal)
        
        button.contentHorizontalAlignment = .center
        
        button.titleLabel?.font = .systemFont(ofSize: 25, weight: .bold)
        
        return button
    }()
    
    var absentNameList: [String] = [] {
        // This is called property observers. The code inside willSet
        // will be executed every time absentNameList is set to a new
        // value. The new value will be binded to a special keyword
        // newValue
        willSet {
            // MARK: >> Your Code Here <<
            // Then uncomment the following lines
            
//            let attrText = NSAttributedString(string: text, attributes: [
//                .font: UIFont.systemFont(ofSize: 18, weight: .medium)
//            ])
//
//            let baseAttrText = absentNamesLabel.attributedText!
//
//            let mutableAttrText = NSMutableAttributedString()
//
//            mutableAttrText.append(baseAttrText)
//            mutableAttrText.append(attrText)
//
//            absentNamesLabel.attributedText = mutableAttrText
        }
    }
    
    var presentNameList: [String] = [] {
        // Alternatively, you can use a didSet. DidSet is also a
        // property observer. The only difference between willSet and
        // didSet is that didSet happens after the value is assigned.
        // So the new value would just be the property itself, and the
        // previous value is binded to the keyword oldValue.
        didSet {
            // MARK: >> Your Code Here <<
            // Then uncomment the following lines
            
//            let attrText = NSAttributedString(string: text, attributes: [
//                .font: UIFont.systemFont(ofSize: 18, weight: .medium)
//            ])
//
//            let baseAttrText = presentNamesLabel.attributedText!
//
//            let mutableAttrText = NSMutableAttributedString()
//
//            mutableAttrText.append(baseAttrText)
//            mutableAttrText.append(attrText)
//
//            presentNamesLabel.attributedText = mutableAttrText
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        // Add mainViewStack to the root view, then add the two labels plus
        // the reset button as the arranged subviews of the stack view. The
        // ones that are added first will be stacked towards the beginning of
        // the stack view's axis.
        // -------view hierarchy--------
        //
        // WelcomeVC -> View (root)
        //               |- mainViewStack
        //                  |- presentNamesLabel (Arranged Subview)
        //                  |- absentNamesLabel (Arranged Subview)
        //                  |- resetButton (Arranged Subview)
        //                  \
        //
        // -----------------------------
        // MARK: >> Your Code Here <<
        
        
        NSLayoutConstraint.activate([
            // MARK: >> Your Code Here <<
        ])
        
        resetButton.addTarget(self, action: #selector(didTapReset(_:)), for: .touchUpInside)
    }
    
    @objc func didTapReset(_ sender: UIButton) {
        // Use the dismiss(animated:completion:) method to go back.
        dismiss(animated: true, completion: nil)
    }
}
