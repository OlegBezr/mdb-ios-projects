//
//  AuthTextField.swift
//  MDB Social
//
//  Created by Michael Lin on 2/25/21.
//

import UIKit

fileprivate let DEFAULT_FONT_SIZE: CGFloat = 15.0

final class AuthTextField: UIView {

    let textField: UITextField = {
        let tf = TextField()
        tf.borderStyle = .none
        tf.backgroundColor = UIColor(hex: "#f7f7f7")
        tf.textColor = .primaryText
        tf.font = .systemFont(ofSize: DEFAULT_FONT_SIZE, weight: .medium)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .secondaryText
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = .systemFont(ofSize: DEFAULT_FONT_SIZE-2, weight: .semibold)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var text: String? {
        get {
            return textField.text
        }
    }
    
    private var textFieldHeightConstraint: NSLayoutConstraint!
    
    init(frame: CGRect = .zero, title: String) {
        super.init(frame: frame)
        setTitle(title: title)
        configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func setTitle(title: String) {
        titleLabel.text = title.uppercased()
        titleLabel.sizeToFit()
        
    }
    
    private func configure() {

        addSubview(titleLabel)
        addSubview(textField)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -5)
        ])
        
        let height = DEFAULT_FONT_SIZE * 2.3
        textFieldHeightConstraint = textField.heightAnchor.constraint(
            equalToConstant: height)
        textFieldHeightConstraint.isActive = true
        textField.layer.cornerRadius = height / 2
    }
    
    private class TextField: UITextField {
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 20, dy: 0)
        }
        
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 20, dy: 0)
        }
    }
}
