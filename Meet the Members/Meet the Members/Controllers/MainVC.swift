//
//  MainVC.swift
//  Meet the Members
//
//  Created by Michael Lin on 1/18/21.
//

import Foundation
import UIKit

class MainVC: UIViewController {
    enum GameState {
        case play
        case pause
        case answerCheck
    }
    
    var gameStats = GameStats()
    var oldGameState = GameState.play
    var gameState = GameState.play
    var timer: Timer?
    var timeForAnswerLeft = 5
    var timeForAnswerCheckLeft = 2
    var question: QuestionProvider.Question?
    var correctAnswer: Int {
        get {
            return question!.choices.firstIndex(of: question!.answer) ?? 0
        }
    }
    
    let timerView: UILabel = {
        let view = UILabel()
        view.text = "Time left: 5"
        view.textColor = .darkGray
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 20)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let progressBarView: UIProgressView = {
        let view = UIProgressView()
        
        view.progressTintColor = UIColor.systemBlue.withAlphaComponent(0.5)
        view.progress = 1;
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let scoreView: UILabel = {
        let view = UILabel()
        view.text = "Score: 0"
        view.textColor = .darkGray
        view.textAlignment = .center
        view.isOpaque = false
        view.font = .systemFont(ofSize: 20)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        
        view.backgroundColor = .lightGray
        view.contentMode = UIView.ContentMode.scaleAspectFit
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
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }
    }()
    
    let pauseButton: UIButton = {
        let button = UIButton()

        button.backgroundColor = .systemGreen.withAlphaComponent(0.5)
        button.titleEdgeInsets = UIEdgeInsets.init(
            top: 0, left: 3, bottom: 0, right: 3
        )
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitle("Pause", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let statsButton: UIButton = {
        let button = UIButton()

        button.backgroundColor = .systemGreen.withAlphaComponent(0.5)
        button.titleEdgeInsets = UIEdgeInsets.init(
            top: 0, left: 3, bottom: 0, right: 3
        )
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitle("Stats", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        // Create a timer that calls timerCallback() every one second
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(timerCallback),
            userInfo: nil,
            repeats: true
        )
        getNextQuestion()
        
        // modalPresentationStyle = .fullScreen
        
        view.addSubview(imageView)
//        view.addSubview(timerView)
        view.addSubview(progressBarView)
        view.addSubview(scoreView)
        for i in 0...3 {
            view.addSubview(buttons[i])
        }
        view.addSubview(pauseButton)
        view.addSubview(statsButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: 10
            ),
            imageView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            imageView.bottomAnchor.constraint(
                lessThanOrEqualTo: view.centerYAnchor
            ),
            imageView.widthAnchor.constraint(
                equalToConstant: view.bounds.width - 10
            ),
            imageView.heightAnchor.constraint(
                equalToConstant: view.bounds.height / 2 - 50
            ),
            scoreView.topAnchor.constraint(
                equalTo: imageView.bottomAnchor,
                constant: 10
            ),
            scoreView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
//            timerView.topAnchor.constraint(
//                equalTo: scoreView.bottomAnchor,
//                constant: 20
//            ),
//            timerView.centerXAnchor.constraint(
//                equalTo: view.centerXAnchor
//            ),
            progressBarView.topAnchor.constraint(
                equalTo: scoreView.bottomAnchor,
                constant: 10
            ),
            progressBarView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            progressBarView.heightAnchor.constraint(
                equalToConstant: 20
            ),
            progressBarView.widthAnchor.constraint(
                equalToConstant: view.bounds.width - 40
            ),
//            buttons[0].topAnchor.constraint(
//                equalTo: timerView.bottomAnchor,
//                constant: 30
//            ),
            buttons[0].topAnchor.constraint(
                equalTo: progressBarView.bottomAnchor,
                constant: 30
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
            pauseButton.topAnchor.constraint(
                lessThanOrEqualTo: buttons[2].bottomAnchor,
                constant: 50
            ),
            pauseButton.topAnchor.constraint(
                greaterThanOrEqualTo: buttons[2].bottomAnchor,
                constant: 20
            ),
            pauseButton.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -40
            ),
            pauseButton.trailingAnchor.constraint(
                equalTo: view.centerXAnchor,
                constant: -20
            ),
            statsButton.topAnchor.constraint(
                equalTo: pauseButton.topAnchor
            ),
            statsButton.bottomAnchor.constraint(
                equalTo: pauseButton.bottomAnchor
            ),
            statsButton.leadingAnchor.constraint(
                equalTo: view.centerXAnchor,
                constant: 20
            ),
            pauseButton.widthAnchor.constraint(
                equalToConstant: view.bounds.width / 4
            ),
            statsButton.widthAnchor.constraint(
                equalToConstant: view.bounds.width / 4
            )
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
        
        buttons.forEach { button in
            button.addTarget(
                self,
                action: #selector(didTapAnswer(_:)),
                for: .touchUpInside
            )
        }
        pauseButton.addTarget(
            self,
            action: #selector(pauseCallback),
            for: .touchUpInside
        )
        statsButton.addTarget(
            self,
            action: #selector(didTapStats(_:)),
            for: .touchUpInside
        )
    }
    
    // What's the difference between viewDidLoad() and
    // viewWillAppear()? What about viewDidAppear()?
    override func viewWillAppear(_ animated: Bool) {
        // MARK: STEP 13: Resume Game
        // Action Items:
        // - Reinstantiate timer when view appears
//        timer = Timer.scheduledTimer(
//            timeInterval: 1.0,
//            target: self,
//            selector: #selector(timerCallback),
//            userInfo: nil,
//            repeats: true
//        )
    }
    
    override func viewDidLayoutSubviews() {
        for i in 0...3 {
            buttons[i].layer.cornerRadius = 10
            buttons[i].clipsToBounds = true
        }
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.clipsToBounds = true
        pauseButton.layer.cornerRadius = 5
        statsButton.layer.cornerRadius = 5
    }
    
    func getNextQuestion() {
        hideAnswers()
        if let newQuestion = QuestionProvider.shared.nextQuestion() {
            question = newQuestion
            imageView.image = newQuestion.image
            for i in 0...3 {
                buttons[i].setTitle(newQuestion.choices[i], for: .normal)
            }
            timeForAnswerLeft = 5
            progressBarView.setProgress(
                 1, animated: false
            )
//            timerView.text = "Time left: \(timeForAnswerLeft)"
        }
        else {
            print("Error")
        }
    }
    
    @objc func pauseCallback() {
        if (gameState != GameState.pause) {
            oldGameState = gameState
            gameState = GameState.pause
            pauseButton.setTitle("Resume", for: .normal)
        }
        else {
            gameState = oldGameState
            pauseButton.setTitle("Pause", for: .normal)
        }
    }
    
    @objc func timerCallback() {
        switch gameState {
            case GameState.play:
                timeForAnswerLeft -= 1
                progressBarView.setProgress(
                     Float(timeForAnswerLeft) / 5.0, animated: true
                )
//                timerView.text = "Time left: \(timeForAnswerLeft)"
                if (timeForAnswerLeft == 0) {
                    wrongAnswer()
                    timeForAnswerLeft = 5
                    showAnswers()
                }
            case GameState.answerCheck:
                timeForAnswerCheckLeft -= 1
                if (timeForAnswerCheckLeft == 0) {
                    getNextQuestion()
                    timeForAnswerCheckLeft = 2
                    gameState = GameState.play
                }
            case GameState.pause:
                break
        }
    }
    
    @objc func didTapAnswer(_ sender: UIButton) {
        if (gameState == GameState.play) {
            showAnswers()
            if (sender.tag != correctAnswer) {
                wrongAnswer()
                sender.backgroundColor = .systemRed.withAlphaComponent(0.5)
            }
            else {
                gameStats.answers.append(true)
                gameStats.score += 1
                gameStats.currentStreak += 1
                gameStats.bestStreak = max(gameStats.bestStreak, gameStats.currentStreak)
            }
            scoreView.text = "Score: \(gameStats.score)"
        }
    }
    
    func wrongAnswer() {
        gameStats.currentStreak = 0
        gameStats.answers.append(false)
    }
    
    func hideAnswers() {
        buttons.forEach { button in
            button.backgroundColor = .systemGreen.withAlphaComponent(0.5)
        }
    }
    
    func showAnswers() {
        buttons.forEach { button in
            button.backgroundColor = .systemGray.withAlphaComponent(0.5)
        }
        buttons[correctAnswer].backgroundColor = .systemGreen.withAlphaComponent(0.5)
        gameState = GameState.answerCheck
    }
    
    @objc func didTapStats(_ sender: UIButton) {
        let vc = StatsVC(gameStats: gameStats)
        // timer?.invalidate()
        if (gameState != GameState.pause) {
            pauseCallback()
        }
        
        // vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true, completion: nil)
    }
}
