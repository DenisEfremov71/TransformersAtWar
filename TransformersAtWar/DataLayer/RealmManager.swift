//
//  RealmManager.swift
//  TransformersAtWar
//
//  Created by Denis Efremov on 2019-10-29.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class RealmManager {
    let realm: Realm?
    
    init() {
        realm = try! Realm()
    }
    
    func getAllTransformers() -> [Transformer]? {
        guard let realm = self.realm else {
            return nil
        }
        
        let objects = realm.objects(RealmTransformer.self)
        if objects.count == 0 {
            return nil
        }
        
        var transformers = [Transformer]()
        for i in 0..<objects.count {
            let transformer = Transformer(id: objects[i].id, name: objects[i].name, team: objects[i].team, team_icon: objects[i].team_icon,
                courage: objects[i].courage, endurance: objects[i].endurance, firepower: objects[i].firepower, intelligence: objects[i].intelligence,
                rank: objects[i].rank, skill: objects[i].skill, speed: objects[i].speed, strength: objects[i].strength)
            transformers.append(transformer)
        }
        
        return transformers
    }
    
    func getTransformer(id: String) -> RealmTransformer? {
        guard let realm = self.realm else {
            return nil
        }
        return realm.object(ofType: RealmTransformer.self, forPrimaryKey: id)
    }
    
    func saveTransformer(transformer: Transformer) {
        guard let realm = self.realm else {
            return
        }
        do {
            let rt = RealmTransformer()
            rt.id = transformer.id!
            rt.name = transformer.name
            rt.team = transformer.team
            rt.team_icon = transformer.team_icon!
            rt.courage = transformer.courage
            rt.endurance = transformer.endurance
            rt.firepower = transformer.firepower
            rt.intelligence = transformer.intelligence
            rt.rank = transformer.rank
            rt.skill = transformer.skill
            rt.speed = transformer.speed
            rt.strength = transformer.strength
            try realm.write {
                realm.add(rt)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveMultipleTransformers(transformers: [Transformer]) {
        guard let realm = self.realm else {
            return
        }
        do {
            var rtArray = [RealmTransformer]()
            for n in 0..<transformers.count {
                let rt = RealmTransformer()
                rt.id = transformers[n].id!
                rt.name = transformers[n].name
                rt.team = transformers[n].team
                rt.team_icon = transformers[n].team_icon!
                rt.courage = transformers[n].courage
                rt.endurance = transformers[n].endurance
                rt.firepower = transformers[n].firepower
                rt.intelligence = transformers[n].intelligence
                rt.rank = transformers[n].rank
                rt.skill = transformers[n].skill
                rt.speed = transformers[n].speed
                rt.strength = transformers[n].strength
                rtArray.append(rt)
            }
            try realm.write {
                realm.add(rtArray)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateTransformer(transformer: Transformer) {
        guard let realm = self.realm else {
            return
        }
        if let trFromRealm = realm.object(ofType: RealmTransformer.self, forPrimaryKey: transformer.id) {
            do {
                try realm.write {
                    trFromRealm.courage = transformer.courage
                    trFromRealm.endurance = transformer.endurance
                    trFromRealm.firepower = transformer.firepower
                    trFromRealm.intelligence = transformer.intelligence
                    trFromRealm.name = transformer.name
                    trFromRealm.rank = transformer.rank
                    trFromRealm.skill = transformer.skill
                    trFromRealm.speed = transformer.speed
                    trFromRealm.strength = transformer.strength
                    trFromRealm.team = transformer.team
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteTransformer(transformer: Transformer) {
        guard let realm = self.realm else {
            return
        }
        do {
            let filter = NSPredicate(format: "id == %@", transformer.id!)
            let realmTransformer = realm.objects(RealmTransformer.self).filter(filter)
            try realm.write {
                realm.delete(realmTransformer)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
