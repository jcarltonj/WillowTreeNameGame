//
//  MattNameGame.swift
//  NameGame
//
//  Created by Carlton Jester on 4/14/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import Foundation
class MattNameGame: NameGame {
    lazy var teamModeList: [Person] = {
        return peopleManager.localPeople.filter({ (p) -> Bool in
            if let fN = p.firstName {
                return fN.starts(with:"Mat")
            }
            return false
            
        })
    }()
    override func getListOfPeopleToUse() -> [Person] {
        return teamModeList
    }
}
