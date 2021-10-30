//
//  StartSignupVC.swift
//  MDB Social
//
//  Created by Oleg Bezrukavnikov on 10/29/21.
//

import UIKit
import NotificationBannerSwift

class StartSignupVC: UIViewController {
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 25

        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Welcome,"
        lbl.textColor = .primaryText
        lbl.font = .systemFont(ofSize: 30, weight: .semibold)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let titleSecLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sign up to continue"
        lbl.textColor = .secondaryText
        lbl.font = .systemFont(ofSize: 17, weight: .medium)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let fullnameTextField: AuthTextField = {
        let tf = AuthTextField(title: "Full Name:")
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let usernameTextField: AuthTextField = {
        let tf = AuthTextField(title: "User Name:")
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let nextButton: LoadingButton = {
        let btn = LoadingButton()
        btn.layer.backgroundColor = UIColor.primary.cgColor
        btn.setTitle("Next", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btn.isUserInteractionEnabled = true
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let signInActionLabel: HorizontalActionLabel = {
        let actionLabel = HorizontalActionLabel(
            label: "Already have an account?",
            buttonTitle: "Sign In")
        
        actionLabel.translatesAutoresizingMaskIntoConstraints = false
        return actionLabel
    }()
    
    private let contentEdgeInset = UIEdgeInsets(top: 120, left: 40, bottom: 30, right: 40)
    
    private let nextButtonHeight: CGFloat = 44.0

    private var bannerQueue = NotificationBannerQueue(maxBannersOnScreenSimultaneously: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .background
        
        view.addSubview(titleLabel)
        view.addSubview(titleSecLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: contentEdgeInset.top),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: contentEdgeInset.left),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: contentEdgeInset.right),
            titleSecLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                               constant: 3),
            titleSecLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            titleSecLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
        
        view.addSubview(stack)
        stack.addArrangedSubview(fullnameTextField)
        stack.addArrangedSubview(usernameTextField)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                           constant: contentEdgeInset.left),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                            constant: -contentEdgeInset.right),
            stack.topAnchor.constraint(equalTo: titleSecLabel.bottomAnchor,
                                       constant: 60)
        ])
        
        view.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            nextButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 30),
            nextButton.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: nextButtonHeight)
        ])
        
        nextButton.layer.cornerRadius = nextButtonHeight / 2
        
        nextButton.addTarget(self, action: #selector(didTapNext(_:)), for: .touchUpInside)
        
        view.addSubview(signInActionLabel)
        NSLayoutConstraint.activate([
            signInActionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInActionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])
        
        signInActionLabel.addTarget(self, action: #selector(didTapSignIn(_:)), for: .touchUpInside)
    }

    @objc func didTapNext(_ sender: UIButton) {
        guard let name = fullnameTextField.text, name != "" else {
            showErrorBanner(withTitle: "Missing full name", subtitle: "Please provide your full name")
            return
        }
        
        guard let username = usernameTextField.text, username != "" else {
            showErrorBanner(withTitle: "Missing user name", subtitle: "Please provide your user name")
            return
        }
        
        let vc = SignupVC(name: name, username: username)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc private func didTapSignIn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private func showErrorBanner(withTitle title: String, subtitle: String? = nil) {
        guard bannerQueue.numberOfBanners == 0 else { return }
        let banner = FloatingNotificationBanner(title: title, subtitle: subtitle,
                                                titleFont: .systemFont(ofSize: 17, weight: .medium),
                                                subtitleFont: subtitle != nil ?
                                                    .systemFont(ofSize: 14, weight: .regular) : nil,
                                                style: .warning)
        
        banner.show(bannerPosition: .top,
                    queue: bannerQueue,
                    edgeInsets: UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15),
                    cornerRadius: 10,
                    shadowColor: .primaryText,
                    shadowOpacity: 0.3,
                    shadowBlurRadius: 10)
    }
}
