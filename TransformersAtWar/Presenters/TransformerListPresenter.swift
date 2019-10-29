//
//  TransformerListPresenter.swift
//  TransformersAtWar
//
//  Created by Denis Efremov on 2019-10-26.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

import Foundation

class TransformerListPresenter {
    
    //var apiService = TransformersApiService()
    
    var allTransformers = [Transformer]()
    var autobots = [Transformer]()
    var decepticons = [Transformer]()
    var eliminatedTransformers = [Eliminated]()
    
    func getAllTransformers(completion: @escaping ([Transformer]?) -> Void) {
        TransformersApiService.fetchAllTransformers(completion: { (success, transformers) in
            if success {
                completion(transformers)
            } else {
                completion(nil)
            }
        })
    }
    
    func getTransformer(id: String) {
        TransformersApiService.fetchTransformer(with: id)
    }
    
    func deleteTransformer(id: String, completion: @escaping (Bool) -> Void) {
        TransformersApiService.deleteTransformer(id: id) { (success) in
            if success {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func wageTheWar(transformers: [Transformer], completion: @escaping (String) -> Void) {
        allTransformers = transformers
        // separate transformers into two teams: A and D
        autobots = transformers.filter{ $0.team == "A" }
        decepticons = transformers.filter{ $0.team == "D" }
        
        // sort A and D by rank
        let linedUpAutobots = autobots.sorted { $0.rank > $1.rank }
        let linedUpDecepticons = decepticons.sorted { $0.rank > $1.rank }
        
        //        for a in linedUpAutobots {
        //            print("Name: \(a.name)")
        //            print("Rank: \(a.rank)")
        //        }
        //        for d in linedUpDecepticons {
        //            print("Name: \(d.name)")
        //            print("Rank: \(d.rank)")
        //        }
        
        // conduct the battle
        let numberOfBattles = min(linedUpAutobots.count, linedUpDecepticons.count)
        //print("numberOfBattles: \(numberOfBattles)")
        for i in 0..<numberOfBattles {
            print("\(linedUpAutobots[i].name) from \(linedUpAutobots[i].team) team is facing \(linedUpDecepticons[i].name) from \(linedUpDecepticons[i].team)")
            let (outcome,eliminated) = determineBattleOutcome(autobot: linedUpAutobots[i], decepticon: linedUpDecepticons[i])
            if outcome == .allDestroyed {
                markAsDestroyed(outcome: .allDestroyed)
                break
            } else if outcome == .win {
                markAsDestroyed(outcome: .win, loser: eliminated)
            } else {
                let elimA = Eliminated()
                let elimD = Eliminated()
                elimA.id = linedUpAutobots[i].id
                elimA.team = linedUpAutobots[i].team
                elimD.id = linedUpDecepticons[i].id
                elimD.team = linedUpDecepticons[i].team
                markAsDestroyed(outcome: .tie, winner: elimA, loser: elimD)
            }
        }
        
        // assumption was made that all the destroyed transformers have to be deleted from the list
        
        
        let outcome = summarizeTheWarResults()
        
        // send back the results
        completion("War is over. \(outcome)")
    }
    
    func determineBattleOutcome(autobot: Transformer, decepticon: Transformer) -> (BattleOutcome,Eliminated?) {
        let eliminated = Eliminated()
        let optimusPrime = Constants.TransformerNames.optimusPrime
        let predaking = Constants.TransformerNames.predaking
        
        // Optimus Prime vs. Predaking
        if autobot.name.uppercased() == optimusPrime && decepticon.name.uppercased() == predaking {
            return (.allDestroyed, nil)
        } else if autobot.name.uppercased() == optimusPrime && decepticon.name.uppercased() != predaking {
            eliminated.id = decepticon.id
            eliminated.team = "D"
            return (.win, eliminated)
        } else if autobot.name.uppercased() != optimusPrime && decepticon.name.uppercased() == predaking {
            eliminated.id = autobot.id
            eliminated.team = "A"
            return (.win, eliminated)
        }
            // Not Optimus Prime and not Predaking
        else {
            
            // courage and strength rule
            if autobot < decepticon {
                eliminated.id = autobot.id
                eliminated.team = "A"
                return (.win, eliminated)
            } else if decepticon < autobot {
                eliminated.id = decepticon.id
                eliminated.team = "D"
                return (.win, eliminated)
            }
            
            // skill rule
            if autobot > decepticon {
                eliminated.id = decepticon.id
                eliminated.team = "D"
                return (.win, eliminated)
            } else if decepticon > autobot {
                eliminated.id = autobot.id
                eliminated.team = "A"
                return (.win, eliminated)
            }
            
            // overall rating rule
            if autobot.overallRating > decepticon.overallRating {
                eliminated.id = decepticon.id
                eliminated.team = "D"
                return (.win, eliminated)
            } else if autobot.overallRating < decepticon.overallRating {
                eliminated.id = autobot.id
                eliminated.team = "A"
                return (.win, eliminated)
            } else {
                return (.tie, nil)
            }
        }
    }
    
    func markAsDestroyed(outcome: BattleOutcome, winner: Eliminated? = nil, loser: Eliminated? = nil) {
        let eliminated = Eliminated()
        switch outcome {
        case .allDestroyed:
            for tr in allTransformers {
                eliminated.id = tr.id
                eliminated.team = tr.team
                eliminatedTransformers.append(eliminated)
            }
            break
        case .win:
            eliminatedTransformers.append(loser!)
            break
        case .tie:
            eliminatedTransformers.append(winner!)
            eliminatedTransformers.append(loser!)
            break
        }
    }
    
    func summarizeTheWarResults() -> String {
        let eliminatedAutobots = eliminatedTransformers.filter{ $0.team == "A" }
        let eliminatedDecepticons = eliminatedTransformers.filter{ $0.team == "D" }
        
        if allTransformers.count == eliminatedTransformers.count {
            return Constants.WarResults.allDestroyed
        } else if eliminatedAutobots.count < eliminatedDecepticons.count {
            return Constants.WarResults.autobotsWon
        } else if eliminatedAutobots.count > eliminatedDecepticons.count {
            return Constants.WarResults.decepticonsWon
        } else {
            return Constants.WarResults.nobodyWon
        }
    }
    
    func destroyTheLosers() {
        // TODO: implement it
    }
    
}
