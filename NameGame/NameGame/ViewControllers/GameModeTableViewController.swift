//
//  GameModeTableViewController.swift
//  NameGame
//
//  Created by Carlton Jester on 4/14/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import UIKit

class GameModeTableViewController: UITableViewController {
    struct GameModes {
        static let regular = "Regular"
        static let regularHelp = "Reg Force Touch/Long Press Help"
        static let team = "Team Mode"
        static let teamHelp = "Team Help"
        static let mat = "Mat(t)"
        static let matHelp = "Mat(t) Help"
    }
    let gameModes = [GameModes.regular, GameModes.regularHelp, GameModes.team, GameModes.teamHelp, GameModes.mat, GameModes.matHelp]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gameModes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = gameModes[indexPath.row]

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let indexPath = tableView.indexPathForSelectedRow, let dest = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NameGame") as? NameGameViewController else {
            return
        }
        switch gameModes[indexPath.row] {
        case GameModes.regular:
            dest.learnModeIsOn = false
        case GameModes.regularHelp:
            dest.learnModeIsOn = true
        case GameModes.team:
            dest.nameGame = TeamModeNameGame()
            dest.learnModeIsOn = false
        case GameModes.teamHelp:
            dest.nameGame = TeamModeNameGame()
            dest.learnModeIsOn = true
        case GameModes.mat:
            dest.nameGame = MattNameGame()
            dest.learnModeIsOn = false
        case GameModes.matHelp:
            dest.nameGame = MattNameGame()
            dest.learnModeIsOn = true
        default:
            break
        }
        dest.title = gameModes[indexPath.row]
        self.navigationController?.pushViewController(dest, animated: true)
    }

}

