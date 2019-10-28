//
//  Transformer.swift
//  TransformersAtWar
//
//  Created by Denis Efremov on 2019-10-26.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

import Foundation

class Transformer: Codable {
    var id: String?
    var name: String
    var team: String
    var team_icon: String?
    var courage: Int
    var endurance: Int
    var firepower: Int
    var intelligence: Int
    var rank: Int
    var skill: Int
    var speed: Int
    var strength: Int
    
    var overallRating: Int {
        return strength + intelligence + speed + endurance + firepower
    }
    
    init(id: String?, name: String, team: String, team_icon: String?, courage: Int, endurance: Int,
         firepower: Int, intelligence: Int, rank: Int, skill: Int, speed: Int, strength: Int) {
        self.id = id
        self.name = name
        self.team = team
        self.team_icon = team_icon
        self.courage = courage
        self.endurance = endurance
        self.firepower = firepower
        self.intelligence = intelligence
        self.rank = rank
        self.skill = skill
        self.speed = speed
        self.strength = strength
    }
}
