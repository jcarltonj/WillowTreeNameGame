//
//  Person.swift
//  NameGame
//
//  Created by Carlton Jester on 4/14/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import Foundation
import UIKit

struct Person : Codable, Equatable, Hashable {
    
    //MARK: - Properties
    let id: String?
    let type: String?
    let slug: String?
    let jobTitle: String?
    let firstName: String?
    let lastName: String?
    let headshot: Headshot?
    
    //MARK: - Equatable
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.id == rhs.id
    }
    //MARK: - Hashable
    var hashValue: Int {
        guard let i = id else {
            return 0
        }
        
        return i.hashValue
    }
    
    //MARK: - Headshot
    struct Headshot : Codable, Equatable, Hashable {
        var hashValue: Int {
            guard let i = id else {
                return 0
            }
            
            return i.hashValue
        }
        
        //MARK: - Properties
        let type: String?
        let mimeType: String?
        let id: String?
        let url: String?
        let alt: String?
        let height: Int?
        let width: Int?
        
        //MARK: - Load Image
        func getPersonImage() -> UIImage? {
            if let us = self.url, let u = URL(string: "https:"+us) {
                do {
                    let data = try Data(contentsOf: u)
                    return UIImage(data: data)
                }
                catch {
                    print(error)
                }
            }
            return UIImage(named: "Not Found")
        }
    }
}
