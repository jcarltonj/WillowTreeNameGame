//
//  NameGameTeamMode.swift
//  NameGame
//
//  Created by Carlton Jester on 4/14/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import Foundation

class NameGameTeamMode: NameGame {
    lazy var teamModeList: [Person] = {
        return peopleManager.localPeople.filter({ (p) -> Bool in
            return p.jobTitle != nil
        })
    }()
    override func getListOfPeopleToUse() -> [Person] {
        for i in teamModeList {
            print(i.jobTitle)
        }
        return teamModeList
    }
}
