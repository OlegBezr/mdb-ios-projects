//
//  SOCEventVC.swift
//  MDB Social
//
//  Created by Oleg Bezrukavnikov on 10/31/21.
//

import UIKit

class SOCEventVC: UIViewController  {
    private let eventId: SOCEventID
    private var event: SOCEvent? {
        didSet {
            updateEventUI()
            if let event = event {
                if let url = URL(string: event.photoURL) {
                    imageView.load(url: url)
                }
                FIRDatabaseRequest.shared.getUserById(
                    userId: event.creator,
                    completion: { user in
                        self.creator = user
                    }
                )
            }
        }
    }
    var creator: SOCUser? {
        didSet {
            setTitle()
            if let creatorId = creator?.uid, let uid = SOCAuthManager.shared.currentUser?.uid {
                if (creatorId.elementsEqual(uid)) {
                    deleteButton.isHidden = false
                }
            }
        }
    }
    
    private var interestedButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled();
        config.title = "Follow"
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled();
        config.baseBackgroundColor = .red
        config.title = "Delete"
        button.configuration = config
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let imageView: PaddedImageView = {
        let iv = PaddedImageView()
        iv.tintColor = .white
        iv.backgroundColor = .primary
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        return iv
    }()
    private let titleView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let descriptionView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
//        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = 5
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let timeView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = 6
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let interestedView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(eventId: SOCEventID) {
        self.eventId = eventId
        super.init(nibName: nil, bundle: nil)
        imageView.image = nil
        
        FIRDatabaseRequest.shared.getEventById(eventId: eventId, completion: {
            receivedEvent in
            self.event = receivedEvent
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        interestedButton.addAction(
            UIAction(title: "", handler: { [unowned self] action in
                self.changeEventInterest()
            }),
            for: .touchUpInside
        )
        deleteButton.addAction(
            UIAction(title: "", handler: { [unowned self] action in
                if let event = self.event {
                    FIRDatabaseRequest.shared.deleteEvent(
                        event,
                        completion: {
                            dismiss(animated: true, completion: nil)
                        }
                    )
                }
            }),
            for: .touchUpInside
        )
        
        view.addSubview(imageView)
        view.addSubview(titleView)
        view.addSubview(stackView)
        view.addSubview(buttonStackView)
        
//        stackView.addArrangedSubview(titleView)
        stackView.addArrangedSubview(descriptionView)
        stackView.addArrangedSubview(timeView)
        stackView.addArrangedSubview(interestedView)
        buttonStackView.addArrangedSubview(deleteButton)
        buttonStackView.addArrangedSubview(interestedButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            imageView.heightAnchor.constraint(equalToConstant: view.bounds.height / 3),
            imageView.widthAnchor.constraint(equalToConstant: view.bounds.width - 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: buttonStackView.topAnchor, constant: -10),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 2),
            buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])
    }
    
    override func viewDidLayoutSubviews() {
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
    }
    
    func updateEventUI() {
        if let event = event {
            titleView.text = event.name
            descriptionView.text = "Description: " + event.description
            
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "dd MMM YY, hh:mm a"
            let dateString = dayTimePeriodFormatter.string(
                from: event.startDate
            )
            timeView.text = "Time: " + dateString
            interestedView.text = "Interested: " + String(event.rsvpUsers.count)
            if let uid = SOCAuthManager.shared.currentUser?.uid {
                interestedButton.setTitle(
                    event.rsvpUsers.contains(where: { s in
                        s.elementsEqual(uid)
                    }) ? "Unfollow" : "Follow",
                    for: .normal
                )
            }
        }
    }
    
    func setTitle() {
        let name = event!.name
        let attrName = NSMutableAttributedString(string: name)
        let byString = "\nby "
        let attrByString = NSMutableAttributedString(string: byString)
        let creatorName = creator!.username
        let attrCreator = NSMutableAttributedString(string: creatorName)
        attrCreator.addAttribute(
            .foregroundColor,
            value: UIColor.primary,
            range: NSRange(location: 0, length: creatorName.count)
        )
        let finalAttrString = NSMutableAttributedString()
        finalAttrString.append(attrName)
        finalAttrString.append(attrByString)
        finalAttrString.append(attrCreator)
        titleView.attributedText = finalAttrString
    }
    
    func changeEventInterest() {
        if let uid = SOCAuthManager.shared.currentUser?.uid, let currentEvent = event {
            if (currentEvent.rsvpUsers.contains(uid)) {
                event?.rsvpUsers.removeAll(where: { s in
                    s.elementsEqual(uid)
                })
            } else {
                event?.rsvpUsers.append(uid)
            }
        }
        
        if let updatedEvent = event {
            FIRDatabaseRequest.shared.setEvent(updatedEvent, completion: {})
        }
        
        updateEventUI()
        setTitle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

