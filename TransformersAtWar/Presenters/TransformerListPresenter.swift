//
//  TransformerListPresenter.swift
//  TransformersAtWar
//
//  Created by Denis Efremov on 2019-10-26.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

import Foundation

class TransformerListPresenter {
    
    let realmManager = RealmManager()
    
    var allTransformers = [Transformer]()
    var autobots = [Transformer]()
    var decepticons = [Transformer]()
    var eliminatedTransformers = [Eliminated]()
    
    func getAllTransformers(completion: @escaping ([Transformer]?) -> Void) {
        
        // check the local Realm DB first, then - pull data from the API
        if let transformers = realmManager.getAllTransformers() {
            completion(transformers)
        } else {
            TransformersApiService.fetchAllTransformers(completion: { (success, transformers) in
                if success {
                    self.realmManager.saveMultipleTransformers(transformers: transformers!)
                    completion(transformers)
                } else {
                    completion(nil)
                }
            })
        }
    }
    
    // TODO: implement if needed
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
        
        if autobots.count == 0 {
            completion("No autobots are linued up for the war!")
        }
        if decepticons.count == 0 {
            completion("No decepticons are linued up for the war!")
        }
        
        // sort A and D by rank
        let linedUpAutobots = autobots.sorted { $0.rank > $1.rank }
        let linedUpDecepticons = decepticons.sorted { $0.rank > $1.rank }
        
        // conduct the battle and calculate the outcome
        let numberOfBattles = min(linedUpAutobots.count, linedUpDecepticons.count)
        var battleOutcome: BattleOutcome = .tie
        
        for i in 0..<numberOfBattles {
            print("\(linedUpAutobots[i].name) from \(linedUpAutobots[i].team) team is facing \(linedUpDecepticons[i].name) from \(linedUpDecepticons[i].team)")
            let (outcome,eliminated) = determineBattleOutcome(autobot: linedUpAutobots[i], decepticon: linedUpDecepticons[i])
            if outcome == .allDestroyed {
                markAsDestroyed(outcome: .allDestroyed)
                battleOutcome = outcome
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
            battleOutcome = outcome
        }
        
        // logic to select the war result message
        let warOutcome = summarizeTheWarResults(outcome: battleOutcome)
        
        // reset the eliminated transformers array
        destroyTheLosers()
        
        // send back the results
        completion("War is over. \(warOutcome)")
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
    
    func summarizeTheWarResults(outcome: BattleOutcome) -> String {
        
        // Optimus Prime fought against Predaking
        if outcome == .allDestroyed {
            return Constants.WarResults.allDestroyed
        }
        
        let eliminatedAutobots = eliminatedTransformers.filter{ $0.team == "A" }
        let eliminatedDecepticons = eliminatedTransformers.filter{ $0.team == "D" }
        
        if eliminatedAutobots.count < eliminatedDecepticons.count {
            return Constants.WarResults.autobotsWon
        } else if eliminatedAutobots.count > eliminatedDecepticons.count {
            return Constants.WarResults.decepticonsWon
        } else {
            return Constants.WarResults.nobodyWon
        }
    }
    
    func destroyTheLosers() {
        // assumption was made - the loser don't have to be deleted from DB and API
        // just resetting the eliminated transformers array for now
        eliminatedTransformers = [Eliminated]()
    }
    
}
