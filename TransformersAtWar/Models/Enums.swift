//
//  Enums.swift
//  TransformersAtWar
//
//  Created by Denis Efremov on 2019-10-27.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

import Foundation

enum Mode: String {
    case add  = "add"
    case edit = "edit"
}

enum BattleOutcome: String {
    case win          = "win"
    case tie          = "tie"
    case allDestroyed = "allDestroyed"
}
