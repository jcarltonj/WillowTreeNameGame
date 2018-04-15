//
//  ViewController.swift
//  NameGame
//
//  Created by Matt Kauper on 3/8/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import UIKit
import CoreGraphics

class NameGameViewController: UIViewController {

    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var innerStackView1: UIStackView!
    @IBOutlet weak var innerStackView2: UIStackView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var imageButtons: [FaceButton]!
    
    var nameGame = NameGame()
    
    var learnModeIsOn = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let orientation: UIDeviceOrientation = self.view.frame.size.height > self.view.frame.size.width ? .portrait : .landscapeLeft
        configureSubviews(orientation)
        setupPeekPop()
        nameGame.delegate = self
        nameGame.loadGameData {}
        
        
    }

    @IBAction func faceTapped(_ button: FaceButton) {
        if nameGame.canPlay {
            guard let person = button.person else {
                return
            }
            let _ = self.nameGame.checkAnswer(person: person) //in case I want to use this later
        }
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
    func setupNewTurn(completion: @escaping () -> Void) {
        setLoadingButtons()
        if let firstName = self.nameGame.answer?.firstName, let lastName = self.nameGame.answer?.lastName {
            DispatchQueue.main.async {
                self.questionLabel.text = "Who is " + firstName + " " + lastName + "?"
            }
        }
        for i in 0..<imageButtons.count {
            imageButtons[i].setPerson(person: nameGame.currentTurnList[i])
        }
        completion()
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

//MARK: - Peek and Pop
extension NameGameViewController: UIViewControllerPreviewingDelegate {
    func setupPeekPop() {
        if learnModeIsOn {
            let gr = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognizer(gestureRecognizer:)))
            self.view.addGestureRecognizer(gr)
            if self.traitCollection.forceTouchCapability == .available {
                registerForPreviewing(with: self, sourceView: self.view)
            }
        }
    }
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        for button in imageButtons {
            
            let frame = button.convert(button.bounds, to: self.view) //convert the bounds of a
            
            if frame.contains(location) {
                let image = button.imageView?.image
                
                return getViewControllerForPerson(person: button.person, image: image)
            }
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    //MARK: - Helpers
    func getViewControllerForPerson(person: Person?, image: UIImage?) -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PreviewPerson") as! PreviewPersonViewController
        vc.setupPerson(person: person, image: image)
        return vc
        
    }
    
    @objc
    func longPressGestureRecognizer(gestureRecognizer gr: UILongPressGestureRecognizer) {
        if gr.state == .began {
            for button in imageButtons {
                let frame = button.convert(button.bounds, to: self.view) //convert the bounds of a
                if frame.contains(gr.location(in: self.view)) {
                    let image = button.imageView?.image
                    let vc = getViewControllerForPerson(person: button.person, image: image)
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
        }
    }
    
}
