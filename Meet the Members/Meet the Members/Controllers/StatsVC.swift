//
//  StatsVC.swift
//  Meet the Members
//
//  Created by Michael Lin on 1/18/21.
//

import UIKit

class StatsVC: UIViewController {
    let gameStats: GameStats
    let played3orLess: Int
    var correctAnswersOn3: Int = 0
    
    let pageNameView: UILabel = {
        let view = UILabel()
        view.textColor = .darkGray
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 27, weight: .medium)
        view.text = "Stats"
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let bestStreakView: UILabel = {
        let view = UILabel()
        view.textColor = .darkGray
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 24)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let scoreView: UILabel = {
        let view = UILabel()
        view.textColor = .darkGray
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 24)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let last3ScoreView: UILabel = {
        let view = UILabel()
        view.textColor = .darkGray
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 24)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(gameStats: GameStats) {
        self.gameStats = gameStats
        let ansCount = gameStats.answers.count
        self.played3orLess = min(ansCount, 3)
        
        bestStreakView.text = "Best streak: \(gameStats.bestStreak)"
        scoreView.text = "Total score: \(gameStats.score)/\(gameStats.answers.count)"
        
        super.init(nibName: nil, bundle: nil)
        
        gameStats.answers[ansCount-played3orLess..<ansCount].forEach({ value in
                correctAnswersOn3 += value ? 1:0
            }
        )
        last3ScoreView.text = "Last answers: \(correctAnswersOn3)/\(played3orLess)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(pageNameView)
        view.addSubview(bestStreakView)
        view.addSubview(scoreView)
        view.addSubview(last3ScoreView)
        
        NSLayoutConstraint.activate([
            pageNameView.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: 20
            ),
            pageNameView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            scoreView.topAnchor.constraint(
                equalTo: pageNameView.bottomAnchor,
                constant: 40
            ),
            scoreView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            bestStreakView.topAnchor.constraint(
                equalTo: scoreView.bottomAnchor,
                constant: 30
            ),
            bestStreakView.centerXAnchor.constraint(
                equalTo: scoreView.centerXAnchor
            ),
            last3ScoreView.topAnchor.constraint(
                equalTo: bestStreakView.bottomAnchor,
                constant: 30
            ),
            last3ScoreView.centerXAnchor.constraint(
                equalTo: scoreView.centerXAnchor
            ),
        ])
    }
}
