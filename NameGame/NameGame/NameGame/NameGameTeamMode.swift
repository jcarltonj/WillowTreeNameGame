//
//  NameGameTeamMode.swift
//  NameGame
//
//  Created by Carlton Jester on 4/14/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import Foundation

class TeamModeNameGame: NameGame {
    
    override func setListOfPeopleToUse(allPeople: [Person]) {
        self.listOfPeopleToUse = allPeople.filter({ (p) -> Bool in
            return p.jobTitle != nil
        })
    }
}
