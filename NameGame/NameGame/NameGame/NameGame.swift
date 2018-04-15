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
    
    //Use this to prevent the double tap issue where a user can double tap choices and the game resets twice
    var canPlay = true

    init(delegate del: NameGameDelegate? = nil) {
        delegate = del
    }
    // Load JSON data from API
    func loadGameData() {
        peopleManager.getPeople(){
            self.setupNewTurn()
        }
    }
    //Function that can be overriden to pick different base lists
    func getListOfPeopleToUse() -> [Person] {
        return peopleManager.localPeople
    }
    //Game to setup new turn and reload data
    @objc func setupNewTurn() {
        //Get 6 people
        addPeopleToTurnFromList(list: getListOfPeopleToUse())
        //Pick which will be correct
        selectAnswer()
        //Call setup for delegate
        delegate?.setupNewTurn(completion: {
            self.canPlay = true
        })
        
    }
    //Pick which will be correct
    func selectAnswer() {
        self.answer = self.currentTurnList[Int(arc4random_uniform(UInt32(self.numberPeople)))]
    }
    //Get 6 people
    func addPeopleToTurnFromList(list: [Person]) {
        //Use a set to avoid repeats
        var indexes = Set<Int>()
        currentTurnList = []
        //repeat until we have 6
        while indexes.count != numberPeople { //avoid the case where you get the same number
            indexes.insert(Int(arc4random_uniform(UInt32(list.count))))
        }
        //add people with idexes to list
        for i in indexes {
            let p = list[i]
            currentTurnList.append(p)
            
        }
    }
    //check if answer is correct
    func checkAnswer(person: Person) -> Bool{
        if let answer = self.answer {
            let ansBool = answer == person
            defer {
                //defer until return
                delegate?.setAnswer(){test in
                    return answer == test
                }
                //turn of ability to keep playing
                canPlay = false
                //wait 3 seconds until next turn
                Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(setupNewTurn), userInfo: nil, repeats: false)
            }
            //return truth
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
