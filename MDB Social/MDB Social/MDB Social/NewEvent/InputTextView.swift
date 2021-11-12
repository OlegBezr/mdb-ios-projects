//
//  InputTextView.swift
//  MDB Social
//
//  Created by Oleg Bezrukavnikov on 11/11/21.
//

import UIKit

fileprivate let DEFAULT_FONT_SIZE: CGFloat = 15.0

final class InputTextView: UIView, UITextViewDelegate {
    var inputLines = 1
    let height = DEFAULT_FONT_SIZE * 2.3
    
    let textField: UITextView = {
        let tf = UITextView()
        tf.backgroundColor = UIColor(hex: "#f7f7f7")
        tf.textColor = .primaryText
        tf.font = .systemFont(ofSize: DEFAULT_FONT_SIZE, weight: .medium)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        let top = tf.textContainerInset.top
        let bottom = tf.textContainerInset.bottom
        tf.textContainerInset = UIEdgeInsets(top: top, left: 15, bottom: bottom, right: 15)
        
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
    
    init(frame: CGRect = .zero, title: String, inputLines: Int) {
        super.init(frame: frame)
        setTitle(title: title)
        setInputLines(inputLines: inputLines)
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
    
    func setInputLines(inputLines: Int) {
        self.inputLines = inputLines
    }
    
    private func configure() {
        textField.delegate = self
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
        
        textFieldHeightConstraint = textField.heightAnchor.constraint(
            equalToConstant: height * CGFloat(inputLines))
        textFieldHeightConstraint.isActive = true
        textField.layer.cornerRadius = height / 2
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count < 140
    }
}
