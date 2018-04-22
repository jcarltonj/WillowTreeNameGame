//
//  PreviewPersonViewController+NewContactAB.swift
//  NameGame
//
//  Created by Carlton Jester on 4/22/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import ContactsUI

extension PreviewPersonViewController: CNContactViewControllerDelegate {
    
    //MARK: - Delegate
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        self.dismiss(animated: true)
    }
    func contactViewController(_ viewController: CNContactViewController, shouldPerformDefaultActionFor property: CNContactProperty) -> Bool {
        return true
    }
    
    //MARK: - Helpers
    @objc
    func addToContact() {
        let newContact = CNMutableContact()
        
        guard let p = self.person else {
            return
        }
        if let firstName = p.firstName {
            newContact.givenName = firstName
        }
        if let lastName  = p.lastName {
            newContact.familyName = lastName
        }
        if let jobTitle = p.jobTitle {
            newContact.jobTitle = jobTitle
            newContact.organizationName = "WillowTree"
        }
        
        self.person?.headshot?.getPersonImage(completion: { (image) in
            newContact.imageData = UIImagePNGRepresentation(image)
        })
        
        let vc = CNContactViewController(forNewContact: newContact)
        vc.delegate = self
        
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalTransitionStyle = .coverVertical
        self.present(nvc, animated: true)

    }
    
    func requestContactsAccess() {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .denied, .notDetermined, .restricted:
            CNContactStore().requestAccess(for: .contacts) { (granted, error) in
                if granted {
                    DispatchQueue.main.async {
                        self.showAddToContact = true
                    }
                }
                else {
                    self.showAddToContact = false
                }
            }
        default:
            self.showAddToContact = true
        }
    }
}
