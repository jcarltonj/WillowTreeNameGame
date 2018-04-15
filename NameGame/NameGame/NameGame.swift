//
//  NameGame.swift
//  NameGame
//
//  Created by Erik LaManna on 11/7/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import Foundation

protocol NameGameDelegate: class {
    func setupNewTurn(completion: @escaping () -> Void)
    func setAnswer(check:(Person?)->Bool)
}

class NameGame {
    
    weak var delegate: NameGameDelegate?
    
    let peopleManager: PeopleManager = PeopleManager()

    let numberPeople = 6
    
    var currentTurnList: [Person] = []
    
    var answer: Person?
    
    var canPlay = true

    init(delegate del: NameGameDelegate? = nil) {
        delegate = del
    }
    // Load JSON data from API
    func loadGameData(completion: @escaping () -> Void) {
        peopleManager.getPeople(){
            self.setupNewTurn()
        }
    }
    func getListOfPeopleToUse() -> [Person] {
        return peopleManager.localPeople
    }
    @objc func setupNewTurn() {
        addPeopleToTurnFromList(list: getListOfPeopleToUse())
        selectAnswer()
        delegate?.setupNewTurn(completion: {
            self.canPlay = true
        })
        
    }
    func selectAnswer() {
        self.answer = self.currentTurnList[Int(arc4random_uniform(UInt32(self.numberPeople)))]
    }
    func addPeopleToTurnFromList(list: [Person]) {
        var indexes = Set<Int>()
        currentTurnList = []
        while indexes.count != numberPeople { //avoid the case where you get the same number
            indexes.insert(Int(arc4random_uniform(UInt32(list.count))))
        }
        for i in indexes {
            let p = list[i]
            currentTurnList.append(p)
            
        }
    }
    func checkAnswer(person: Person) -> Bool{
        
        if let answer = self.answer {
            let ansBool = answer == person
            defer {
                delegate?.setAnswer(){test in
                    return answer == test
                }
                canPlay = false
                Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(setupNewTurn), userInfo: nil, repeats: false)
            }
            if ansBool {
                return true
            }
            else {
                return false
            }
        }
        return false
    }
}
