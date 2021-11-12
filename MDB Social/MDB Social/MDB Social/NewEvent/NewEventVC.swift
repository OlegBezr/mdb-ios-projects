//
//  NewEventVC.swift
//  MDB Social
//
//  Created by Oleg Bezrukavnikov on 11/11/21.
//

import Foundation
import UIKit
import NotificationBannerSwift
import FirebaseFirestore
import FirebaseFirestoreSwift

class NewEventVC: UIViewController {
    private var bannerQueue = NotificationBannerQueue(maxBannersOnScreenSimultaneously: 1)
    private var imagePicker: ImagePicker!
    public let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let createButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "Create"
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nameTextField: AuthTextField = {
        let tf = AuthTextField(title: "Name:")
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let descriptionTextField: InputTextView = {
        let tf = InputTextView(title: "Description:", inputLines: 4)
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 15

        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "photo")
        iv.tintColor = .white
        iv.backgroundColor = .primary
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        return iv
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "New Event"
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(stackView)
        view.addSubview(datePicker)
        view.addSubview(createButton)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(descriptionTextField)
        createButton.addAction(
            UIAction(title: "", handler: { [unowned self] action in
                createEvent()
            }),
            for: .touchUpInside
        )
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        imageView.addGestureRecognizer(tapGestureRecognizer)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            imageView.heightAnchor.constraint(equalToConstant: view.bounds.height / 4),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            datePicker.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 2),
        ])
    }
    
    override func viewDidLayoutSubviews() {
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
    }
    
    @objc func didTapBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imageTapped(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    func createEvent() {
        guard let name = nameTextField.text, name != "" else {
            showErrorBanner(withTitle: "Missing event name", subtitle: "Please provide a name")
            return
        }
        guard let description = descriptionTextField.text, description != "" else {
            showErrorBanner(withTitle: "Missing event description", subtitle: "Please provide a description")
            return
        }
        guard let image: UIImage = imageView.image else {
            showErrorBanner(withTitle: "Missing event image", subtitle: "Please provide an image")
            return
        }
        guard let uid = SOCAuthManager.shared.currentUser?.uid else {
            showErrorBanner(withTitle: "Error with user account", subtitle: "Please try signing out and signing in")
            return
        }
        guard let imgData = image.pngData() else {
            showErrorBanner(withTitle: "Error with the image", subtitle: "Please try choosing another image")
            return
        }
        let imageSize: Int = imgData.count
        let mbApproxSize = Double(imageSize) / 1000.0
        let percentage = mbApproxSize < 1000.0 ? 1.0 : (1000.0 / mbApproxSize)
        guard let compressedImage = image.resizeWithPercent(percentage: percentage) else {
            showErrorBanner(withTitle: "Error with the image", subtitle: "Please try choosing another image")
            return
        }
        guard let comprImgData = compressedImage.pngData() else {
            showErrorBanner(withTitle: "Error with the image", subtitle: "Please try choosing another image")
            return
        }
        
        print("\n\nCOMPRESSED IMAGE\n\n")
        let time = Timestamp(date: datePicker.date)
        let event = SOCEvent(name: name, description: description, photoURL: "lol", startTimeStamp: time, creator: uid, rsvpUsers: [])
        FIRDatabaseRequest.shared.createEvent(event) {
            self.navigationController?.popViewController(animated: true)
        }
//        FIRDatabaseRequest.shared.uploadImage(image: comprImgData) { url in
//            let event = SOCEvent(name: name, description: description, photoURL: url, startTimeStamp: time, creator: uid, rsvpUsers: [])
//            FIRDatabaseRequest.shared.createEvent(event) {
//                self.navigationController?.popViewController(animated: true)
//            }
//        }
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


extension NewEventVC: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.imageView.image = image
    }
}
