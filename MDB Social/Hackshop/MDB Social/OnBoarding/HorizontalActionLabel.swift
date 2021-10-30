//
//  HorizontalActionLabel.swift
//  MDB Social
//
//  Created by Michael Lin on 3/1/21.
//

import UIKit

class HorizontalActionLabel: UIStackView {

    let label: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .secondaryText
        lbl.font = .systemFont(ofSize: 14, weight: .medium)
        
        return lbl
    }()
    
    let button: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.primary, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        
        return btn
    }()
    
    init(frame: CGRect = .zero, label: String, buttonTitle: String) {
        super.init(frame: frame)
        self.label.text = label
        self.button.setTitle(buttonTitle, for: .normal)
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addArrangedSubview(label)
        addArrangedSubview(button)
        axis = .horizontal
        distribution = .equalSpacing
        spacing = 2
        backgroundColor = .clear
    }
    
    func addTarget(_ target: Any?, action: Selector, for event: UIControl.Event) {
        button.addTarget(target, action: action, for: event)
    }
}

