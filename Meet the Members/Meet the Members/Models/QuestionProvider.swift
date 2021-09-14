//
//  QuestionProvider.swift
//  Meet the Members
//
//  Created by Michael Lin on 1/18/21.
//

import Foundation
import UIKit

class QuestionProvider {
    
    struct Question {
        
        let image: UIImage
        
        let answer: String
        
        // Answer + 3 other random names.
        let choices: [String]
    }
    
    // This pattern is called *singleton*, you can see it at a lot of places in swift!
    // You can access the instance properties and methods through ImageProvider.shared...
    static let shared = QuestionProvider()
    
    // This property is *private*, meaning that it can only be access(read&write) from within the class.
    private let names = ["Aady Pillai", "Aarushi Agrawal", "Afees Tiamiyu", "Allison Husain", "Anand Chandra", "Anik Gupta", "Anita Shen", "Anjali Thakrar", "Anmol Parande", "Ashwin Aggarwal", "Ashwin Kumar", "Athena Leong", "Charles Yang", "Colin Zhou", "Divya Tadimeti", "DoHyun Cheon", "Francis Chalissery", "Geo Morales", "Ian Shen", "Imran Khaliq", "Izzie Lau", "James Jung", "Joey Hejna", "Juliet Kim", "Kanyes Thaker", "Karen Alarcon", "Katniss Lee", "Kayli Jiang", "Kiana Go", "Maggie Yi", "Matthew Locayo", "Max Emerling", "Melanie Cooray", "Michael Lin", "Neha Nagabothu", "Nicholas Wang", "Nikhar Arora", "Olivia Li", "Patrick Yin", "Paul Shao", "Rini Vasan", "Shaina Chen", "Shaurya Sanghvi", "Shomil Jain", "Shubha Jagannatha", "Simran Regmi", "Srujay Korlakunta", "Vaibhav Gattani", "Will Oakley", "Will Vavrik", "Yatin Agarwal", "Samuel Alber", "Sydney Karimi", "Abhishek Kattuparambil", "Kanu Grover", "Janvi Shah", "Michelle Kroll", "Kanav Mittal", "Oleg Bezrukavnikov", "Shannon Or", "Esha Palkar", "Nikki Suzani", "Dylan Hamuy", "Philip Kabranov", "Carol Li", "SangJun Lee", "Michelle Chang", "Angeline Lee", "Evan Ellis", "Jared Martin", "Nick Jiang", "Taylor Hodan", "Rikio Tsuyama-Dahlgren", "Evelyn Hu", "Max Wilcoxson",]
    
    // private(set) means the property is readonly from outside of the class.
    private(set) var namesToDisplay: [String]
    
    var shouldGameEnd: Bool {
        namesToDisplay.isEmpty
    }
    
    init() {
        namesToDisplay = names.shuffled()
    }
    
    /**
     Return a question struct using names left in the names to display list. Return nil if there's no
     more name to use, or if we couldn't find the image.
     */
    func nextQuestion() -> Question? {
        if let name = namesToDisplay.popLast(), let image = UIImage(named: name.lowercased().replacingOccurrences(of: " ", with: "")) {
            // Use a set so that we don't randomly add the same names.
            var choices = Set<String>()
            choices.insert(name)
            while choices.count < 4 {
                // We know that `names` is not going to be empty
                choices.insert(names.randomElement()!)
            }
            
            return Question(image: image, answer: name,
                            choices: Array(choices))
        }
        
        return nil
    }
    
    func reset() {
        namesToDisplay = names.shuffled()
    }
}
