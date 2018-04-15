//
//  PeopleManager.swift
//  NameGame
//
//  Created by Carlton Jester on 4/14/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import Foundation
class PeopleManager {
    //cache file name
    fileprivate let fileName: String = "people.json"
    //save and get contacts from a file
    var localPeople: [Person] {
        get {
            return self.decodePeople(data: self.readFromFile())
        }
        set(newPeople) {
            self.writeToFile(contents: self.encodePeople(people: newPeople))
        }
    }
    //decode people from json
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
    //encode people to json
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
    //write json to a file
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
    //read json from a file
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
    //get people from API
    func getPeople(completion: @escaping ([Person]) -> Void ) {
        guard let request = getRequest(path: "profiles", andRequestType: "GET") else {
            return
        }
        let session = URLSession.shared
        //run and pass completion handler, data is stored in the class
        session.dataTask(with: request) { (data, response, error) in
            guard let d = data else {
                return
            }
            let people = self.decodePeople(data: d)
            self.localPeople = people
            completion(people)
        }.resume()
        
        
    }
    
    //MARK: - Helpers
    //get request
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
