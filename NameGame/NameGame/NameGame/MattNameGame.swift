//
//  MattNameGame.swift
//  NameGame
//
//  Created by Carlton Jester on 4/14/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import Foundation
class MattNameGame: NameGame {
    
    override func setListOfPeopleToUse(allPeople: [Person]) {
        
        self.listOfPeopleToUse = allPeople.filter({ (p) -> Bool in
            if let fN = p.firstName {
                return fN.starts(with:"Mat")
            }
            return false
            
        })
    }
}
