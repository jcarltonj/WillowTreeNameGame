//
//  FaceButton.swift
//  NameGame
//
//  Created by Intern on 3/11/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import Foundation
import UIKit

open class FaceButton: UIButton {

    var id: Int = 0
    var tintView: UIView = UIView(frame: CGRect.zero)
    var colorView: UIView = UIView()
    var person: Person?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        
        setTitleColor(.white, for: .normal)
        titleLabel?.alpha = 0.0

        
        tintView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tintView)

        tintView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tintView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tintView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tintView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        tintView.isUserInteractionEnabled = false
        
    }

    //MARK: - Person Helpers
    func setPerson(person p: Person) {
        self.person = p
        DispatchQueue.main.async {
            self.imageView?.clipsToBounds = true
            self.imageView?.contentMode = .scaleAspectFill
            self.contentMode = .scaleAspectFill
            self.clipsToBounds = true
            self.setImage(self.person?.headshot?.getPersonImage(), for: .normal)
            
        }
        
    }
    func setAnswer(isCorrect: Bool) {
        var color = UIColor()
        if isCorrect {
            color = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5)
        }
        else {
            color = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        }
        setToColor(color: color)
    }
    func clearAnswer() {
        setToColor(color: UIColor.clear)
    }
    private func setToColor(color: UIColor) {
        tintView.backgroundColor = color
    }
}
