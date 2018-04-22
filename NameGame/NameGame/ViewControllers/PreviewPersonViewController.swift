//
//  PreviewPersonViewController.swift
//  NameGame
//
//  Created by Carlton Jester on 4/14/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import UIKit

class PreviewPersonViewController: UIViewController {

    var person: Person?
    var image: UIImage?
    
    var showAddToContact: Bool = false
    
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var job: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestContactsAccess()
        self.setupAddToContacts()
        // Do any additional setup after loading the view.
    }
    @objc    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupPerson(person p: Person?, image: UIImage?) {
        self.image = image
        self.person = p
    }
    func setUI() {
        
        if let i = image {
            personImage.image = i
        }
        //Set to blank string to clear for no name or job title cases
        name.text = ""
        job.text = ""
        if let fN = self.person?.firstName {
            name.text = fN
            self.title = fN
        }
        if let lN = self.person?.lastName, let t = name.text {
            let n = t + " \(lN)"
            name.text = n
            self.title = n
        }
        if let j = self.person?.jobTitle {
            job.text = j
        }
        
        
    }

}

//MARK: - Add to contacts button
extension PreviewPersonViewController {
    func setupAddToContacts() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToContact))
        self.navigationItem.setRightBarButton(add, animated: true)
    }
    
}
