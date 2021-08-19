//
//  Utils.swift
//  Meet the Member
//
//  Created by Michael Lin on 1/18/21.
//

import Foundation
import UIKit

class QuestionProvider {
    
    // This pattern is called a *singleton*, you can see it at a lot of places in swift!
    // You can access the instance properties and methods through ImageProvider.shared...
    static let shared = QuestionProvider()
    
    // This property is *private*, meaning that it can only be access(read&write) from within the class.
    private let names = ["Aady Pillai", "Aarushi Agrawal", "Afees Tiamiyu", "Allison Husain", "Anand Chandra", "Anik Gupta", "Anita Shen", "Anjali Thakrar", "Anmol Parande", "Ashwin Aggarwal", "Ashwin Kumar", "Athena Leong", "Charles Yang", "Colin Zhou", "Divya Tadimeti", "DoHyun Cheon", "Francis Chalissery", "Geo Morales", "Ian Shen", "Imran Khaliq", "Izzie Lau", "James Jung", "Joey Hejna", "Juliet Kim", "Kanyes Thaker", "Karen Alarcon", "Katniss Lee", "Kayli Jiang", "Kiana Go", "Maggie Yi", "Matthew Locayo", "Max Emerling", "Melanie Cooray", "Michael Lin", "Neha Nagabothu", "Nicholas Wang", "Nikhar Arora", "Olivia Li", "Patrick Yin", "Paul Shao", "Rini Vasan", "Shaina Chen", "Shaurya Sanghvi", "Shomil Jain", "Shubha Jagannatha", "Simran Regmi", "Srujay Korlakunta", "Vaibhav Gattani", "Will Oakley", "Will Vavrik", "Yatin Agarwal", "Samuel Alber", "Sydney Karimi", "Abhishek Kattuparambil", "Kanu Grover", "Janvi Shah", "Michelle Kroll"]
    
    // Private(set) means the property is read-only from the outside.
    private(set) var namesToDisplay: [String]
    
    // This is called an initializer.
    init() {
        namesToDisplay = names.shuffled()
    }
    
    // Return an question struct using the name at the bottom
    // of the shuffled namesToDisplay list, and remove the name
    // from the list. Return nil if the list is already empty,
    // or if the image with the name cannot be found.
    //
    // Why not go from the beginning you might ask. The answer is here: https://www.hackingwithswift.com/example-code/language/how-to-remove-the-first-or-last-item-from-an-array
    func getNextQuestion() -> Question? {
        if let name = namesToDisplay.popLast(), let image = UIImage(named: name.lowercased().replacingOccurrences(of: " ", with: "")) {
            // Use a set so that we don't randomly add the same names.
            var choices = Set<String>()
            choices.insert(name)
            while choices.count < 4 {
                choices.insert(names.randomElement()!)
            }
            
            return Question(image: image, answer: name, choices: Array(choices).shuffled())
        }
        return nil
    }
    
    func reset() {
        namesToDisplay = names.shuffled()
    }
    
    struct Question {
        // The image
        let image: UIImage
        
        // The name
        let answer: String
        
        // Answer + 3 other random names.
        let choices: [String]
    }
}
