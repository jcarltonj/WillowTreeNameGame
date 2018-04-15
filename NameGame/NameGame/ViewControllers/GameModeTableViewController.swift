//
//  GameModeTableViewController.swift
//  NameGame
//
//  Created by Carlton Jester on 4/14/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import UIKit

class GameModeTableViewController: UITableViewController {

    let gameModes = ["Regular", "Force Touch/Long Press Help", "Team Mode"]
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow, let dest = segue.destination as? NameGameViewController else {
            return
        }
        switch indexPath.row {
            case 0:
                dest.learnModeIsOn = false
            case 1:
                dest.learnModeIsOn = true
            case 2:
                dest.nameGame = NameGameTeamMode()
            default:
                break
                
        }
    }
 

}
