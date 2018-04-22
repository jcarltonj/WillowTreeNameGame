//
//  SettingsViewController.swift
//  NameGame
//
//  Created by Carlton Jester on 4/21/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var timeTextView: UITextField!
    
    var peopleManager: PeopleManager = PeopleManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressBar.progress = 0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let time = UserDefaults.standard.double(forKey: NameGame.timeKey)
        self.timeTextView.text = "\(time)"
        if time == 0 {
            self.timeTextView.text = "3.0"
        }
        
    }
    
    @IBAction func clearCache(_ sender: UIButton) {
        PeopleManager.clearCache()
    }
    
    @IBAction func downloadAll(_ sender: UIButton) {
        print(URLCache.shared.currentDiskUsage)
        print(URLCache.shared.diskCapacity)
        print(URLCache.shared.currentMemoryUsage)
        print(URLCache.shared.memoryCapacity)
        URLCache.shared.diskCapacity = 100000000 // enlarge cache
        peopleManager.getPeople { (people) in
            var total:Float = Float(people.count)
            var count: Float = 0
            for person in people {
                if let headshot = person.headshot {
                    headshot.getPersonImage { _ in
                        DispatchQueue.main.async {
                            count += 1
                            self.progressBar.progress = count / total
                        }
                    }
                }
                else {
                    total -= 1
                }
            }
        }
    }
    @IBAction func valueWasChanged(_ sender: UITextField) {
        if let str = sender.text, let num = Double(str) {
            UserDefaults.standard.set(num, forKey: NameGame.timeKey)
        }
    }
    
   
}
