//
//  TransformersApiService.swift
//  TransformersAtWar
//
//  Created by Denis Efremov on 2019-10-26.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

import Foundation
import Alamofire

class TransformersApiService {
    
    static func fetchAllSparkToken(completion: @escaping (Bool) -> Void) {
        Alamofire.request(Constants.ApiEndPoints.fetchToken).responseString { (response) in
            
            if response.response?.statusCode != 200 {
                completion(false)
            }
            
            guard let token = response.value else {
                completion(false)
                return
            }
            
            KeychainHelper.setAllSparkToken(allSparkToken: token)
            print("JWT Token: \(KeychainHelper.getAllSparkToken() ?? "no token")")
            completion(true)
        }
    }
    
    static func fetchTransformer(with id: String) {
        let url = Constants.ApiEndPoints.fetchSpecificTransformer + "/\(id)"
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Authorization": "Bearer \(KeychainHelper.getAllSparkToken() ?? "no token")"]
        Alamofire.request(url, headers: headers).responseJSON { (response) in
            // TODO: implement if needed
        }
    }
    
    static func fetchAllTransformers(completion: @escaping (Bool, [Transformer]?) -> Void) {
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Authorization": "Bearer \(KeychainHelper.getAllSparkToken() ?? "no token")"]
        Alamofire.request(Constants.ApiEndPoints.fetchAllTransformers, headers: headers).responseJSON { (response) in
            
            guard response.result.error == nil else {
                print(response.result.error!)
                completion(false, nil)
                return
            }
            
            guard let json = response.result.value as? [String: Any] else {
                print("Error: no JSON returned")
                completion(false, nil)
                return
            }
            
            // check if JSON contains the "transformers" key and the value is not empty
            guard let transformers = json["transformers"] as? [Dictionary<String,Any>], transformers.count > 0 else {
                print("Error: invalid JSON returned")
                completion(false, nil)
                return
            }
            
            var arr = [Transformer]()
            
            for tr in transformers {
                // Condition required to check for type safety :)
                guard let id = tr["id"] as? String,
                    let name = tr["name"] as? String,
                    let team = tr["team"] as? String,
                    let team_icon = tr["team_icon"] as? String,
                    let courage = tr["courage"] as? Int,
                    let endurance = tr["endurance"] as? Int,
                    let firepower = tr["firepower"] as? Int,
                    let intelligence = tr["intelligence"] as? Int,
                    let rank = tr["rank"] as? Int,
                    let skill = tr["skill"] as? Int,
                    let speed = tr["speed"] as? Int,
                    let strength = tr["strength"] as? Int
                    else {
                        print("Something is not well")
                        continue
                    }
                let newTransformer = Transformer.init(id: id, name: name, team: team, team_icon: team_icon, courage: courage, endurance: endurance, firepower: firepower, intelligence: intelligence, rank: rank, skill: skill, speed: speed, strength: strength)
                arr.append(newTransformer)
            }
            
            print(arr)
            completion(true, arr)
        }
    }
    
    static func createNewTransformer(parameters: [String:Any], completion: @escaping (Bool, Transformer?) -> Void) {
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Authorization": "Bearer \(KeychainHelper.getAllSparkToken() ?? "no token")"]
        Alamofire.request(Constants.ApiEndPoints.createNewTransformer, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            guard response.result.error == nil else {
                print(response.result.error!)
                completion(false, nil)
                return
            }
            
            guard let data = response.data else {
                print("Error: no data returned")
                completion(false, nil)
                return
            }
            
            do {
                let newTransformer = try JSONDecoder().decode(Transformer.self, from: data)
                completion(true, newTransformer)
            } catch let error {
                print(error.localizedDescription)
                completion(false, nil)
            }
        }
    }
    
    static func updateTransformer(id: String, parameters: [String:Any], completion: @escaping (Bool, Transformer?) -> Void) {
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Authorization": "Bearer \(KeychainHelper.getAllSparkToken() ?? "no token")"]
        Alamofire.request(Constants.ApiEndPoints.updateTransformer, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            guard response.result.error == nil else {
                print(response.result.error!)
                completion(false, nil)
                return
            }
            
            guard let data = response.data else {
                print("Error: no data returned")
                completion(false, nil)
                return
            }
            
            do {
                let newTransformer = try JSONDecoder().decode(Transformer.self, from: data)
                completion(true, newTransformer)
            } catch let error {
                print(error.localizedDescription)
                completion(false, nil)
            }
        }
    }
    
    static func deleteTransformer(id: String, completion: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Authorization": "Bearer \(KeychainHelper.getAllSparkToken() ?? "no token")"]
        let url = Constants.ApiEndPoints.deleteTransformer + "/\(id)"
        Alamofire.request(url, method: .delete, headers: headers).responseString { (response) in
            
            guard response.result.error == nil else {
                print(response.result.error!)
                completion(false)
                return
            }
            
            guard let statusCode = response.response?.statusCode else {
                print("No status code returned")
                completion(false)
                return
            }
            
            if statusCode == 204 {
                completion(true)
            } else {
                completion(false)
            }
            
        }
    }
}
