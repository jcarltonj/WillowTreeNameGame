//
//  NameGame.swift
//  NameGame
//
//  Created by Erik LaManna on 11/7/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import Foundation

protocol NameGameDelegate: class {
    func setupNewTurn()
    func setAnswer(check:(Person?)->Bool)
}

class NameGame {
    
    weak var delegate: NameGameDelegate?
    
    let peopleManager: PeopleManager = PeopleManager()

    let numberPeople = 6
    
    var currentTurnList: [Person] = []
    
    var answer: Person?

    init(delegate del: NameGameDelegate? = nil) {
        delegate = del
    }
    // Load JSON data from API
    func loadGameData(completion: @escaping () -> Void) {
        peopleManager.getPeople(){
            self.setupNewTurn()
        }
    }
    @objc func setupNewTurn() {
        addPeopleToTurnFromList(list: peopleManager.localPeople)
        selectAnswer()
        delegate?.setupNewTurn()
        
    }
    func selectAnswer() {
        self.answer = self.currentTurnList[Int(arc4random_uniform(UInt32(self.numberPeople)))]
    }
    func addPeopleToTurnFromList(list: [Person]) {
        var indexes = Set<Int>()
        currentTurnList = []
        while indexes.count != numberPeople { //avoid the case where one
            indexes.insert(Int(arc4random_uniform(UInt32(peopleManager.localPeople.count))))
        }
        for i in indexes {
            currentTurnList.append(peopleManager.localPeople[i])
        }
    }
    func checkAnswer(person: Person) -> Bool{
        
        if let answer = self.answer {
            let ansBool = answer == person
            defer {
                delegate?.setAnswer(){test in
                    return answer == test
                }
                Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(setupNewTurn), userInfo: nil, repeats: false)
            }
            if ansBool {
                print("true")
                return true
            }
            else {
                print("false")
                return false
            }
        }
        return false
    }
}
