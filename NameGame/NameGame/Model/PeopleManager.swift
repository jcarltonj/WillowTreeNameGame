//
//  PeopleManager.swift
//  NameGame
//
//  Created by Carlton Jester on 4/14/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import Foundation
class PeopleManager {
    fileprivate let fileName: String = "people.json"
    var localPeople: [Person] {
        get {
            return self.decodePeople(data: self.readFromFile())
        }
        set(newPeople) {
            self.writeToFile(contents: self.encodePeople(people: newPeople))
        }
    }
    
    func decodePeople(data: Data) -> [Person] {
        
        let jsonDecoder = JSONDecoder()
        do {
            return try jsonDecoder.decode([Person].self, from: data)
        } catch {
            print(error)
            print("Error with json")
        }
        return []
    }
    func encodePeople(people: [Person]) -> Data {
        let  jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(people)
            return jsonData
        }
        catch {
            print(error)
        }
        return Data(base64Encoded: "[]")!
    }
}
//MARK: - Local Store
extension PeopleManager {
    fileprivate func writeToFile(contents data: Data) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(self.fileName)
            do {
                try data.write(to: fileURL)
            }
            catch {
                print(error)
            }
        }
    }
    fileprivate func readFromFile() -> Data {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(self.fileName)
            do {
                return try Data(contentsOf: fileURL)
            }
            catch {
                print(error)
            }
        }
        return Data(base64Encoded: "[]")!
    }
}

//MARK: - REST
extension PeopleManager {
    func getPeople(completion: @escaping () -> Void ) {
        guard let request = getRequest(path: "profiles", andRequestType: "GET") else {
            return
        }
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            guard let d = data else {
                return
            }
            let people = self.decodePeople(data: d)
            self.localPeople = people
            completion()
        }.resume()
        
        
    }
    
    //MARK: - Helpers
    private func getRequest(path: String, andRequestType type: String) -> URLRequest? {
        guard let url =  URL(string: "https://willowtreeapps.com/api/v1.0/"+path) else {
            print("Error: URL invalid")
            return nil
        }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = type
        return request
    }
}
