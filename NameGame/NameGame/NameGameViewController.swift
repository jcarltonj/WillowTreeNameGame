//
//  ViewController.swift
//  NameGame
//
//  Created by Matt Kauper on 3/8/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import UIKit

class NameGameViewController: UIViewController {

    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var innerStackView1: UIStackView!
    @IBOutlet weak var innerStackView2: UIStackView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var imageButtons: [FaceButton]!
    
    let nameGame = NameGame()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let orientation: UIDeviceOrientation = self.view.frame.size.height > self.view.frame.size.width ? .portrait : .landscapeLeft
        configureSubviews(orientation)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameGame.delegate = self
        nameGame.loadGameData {}
    }

    @IBAction func faceTapped(_ button: FaceButton) {
        guard let person = button.person else {
            return
        }
        let answer = self.nameGame.checkAnswer(person: person)
        print(person.headshot!.url!)
    }

    func configureSubviews(_ orientation: UIDeviceOrientation) {
        if orientation.isLandscape {
            outerStackView.axis = .vertical
            innerStackView1.axis = .horizontal
            innerStackView2.axis = .horizontal
        } else {
            outerStackView.axis = .horizontal
            innerStackView1.axis = .vertical
            innerStackView2.axis = .vertical
        }

        view.setNeedsLayout()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let orientation: UIDeviceOrientation = size.height > size.width ? .portrait : .landscapeLeft
        configureSubviews(orientation)
    }
}

//MARK: - NameGameDelegate
extension NameGameViewController: NameGameDelegate {
    func setAnswer(check: (Person?) -> Bool) {
        for i in imageButtons {
            i.setAnswer(isCorrect: check(i.person))
        }
    }
    
    func setupNewTurn() {
        setLoadingButtons()
        
        if let firstName = self.nameGame.answer?.firstName, let lastName = self.nameGame.answer?.lastName {
            DispatchQueue.main.async {
                self.questionLabel.text = "Who is " + firstName + " " + lastName + "?"
            }
        }
        for i in 0..<imageButtons.count {
            imageButtons[i].setPerson(person: nameGame.currentTurnList[i])
        }
        
        
    }
    
    //MARK: - Helpers
    func setLoadingButtons() {
        DispatchQueue.main.async {
            for button in self.imageButtons {
                button.clearAnswer()
                button.setBackgroundImage(UIImage(named: "Loading"), for: .normal)
            }
        }
    }
    
}
