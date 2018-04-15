//
//  NameGameTeamMode.swift
//  NameGame
//
//  Created by Carlton Jester on 4/14/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import Foundation

class TeamModeNameGame: NameGame {
    lazy var teamModeList: [Person] = {
        return peopleManager.localPeople.filter({ (p) -> Bool in
            return p.jobTitle != nil
        })
    }()
    override func getListOfPeopleToUse() -> [Person] {
        return teamModeList
    }
}
