//
//  PeopleManager.swift
//  NameGame
//
//  Created by Carlton Jester on 4/14/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import Foundation
class PeopleManager {
    
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

//MARK: - REST
extension PeopleManager {
    //get people from API
    var request: URLRequest {
        guard let request = getRequest(path: "profiles", andRequestType: "GET") else {
            print("error with request")
            fatalError()
        }
        return request
        
    }
    func getPeople(completion: @escaping ([Person]) -> Void ) {
        
        PeopleManager.getData(request: self.request) { (data) in
            if let d = data {
                let people = self.decodePeople(data: d)
                completion(people)
            }
        }
    }
    
    //MARK: - Helpers
    //get request
    fileprivate func getRequest(path: String, andRequestType type: String) -> URLRequest? {
        guard let url =  URL(string: "https://willowtreeapps.com/api/v1.0/"+path) else {
            print("Error: URL invalid")
            return nil
        }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = type
        return request
    }
    static func getData(request: URLRequest, completion: @escaping (Data?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            if let r = urlResponse, let d = data {
                let cached = CachedURLResponse(response: r, data: d)
                URLCache.shared.storeCachedResponse(cached, for: request)
                completion(d)
            }
        }
        URLCache.shared.getCachedResponse(for: dataTask) { (cResponse) in
            if let r = cResponse {
                completion(r.data)
            }
            else {
                dataTask.resume()
            }
        }
    }
    static func clearCacheValue(request: URLRequest) {
        URLCache.shared.removeCachedResponse(for: request)
    }
}










