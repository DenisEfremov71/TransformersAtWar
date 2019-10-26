//
//  KeychainHelper.swift
//  TransformersAtWar
//
//  Created by Denis Efremov on 2019-10-26.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class KeychainHelper {
    
    static func removeAll() {
        let _: Bool = KeychainWrapper.standard.removeObject(forKey: "allSparkToken")
    }
    
    // MARK: - Getters and Setters
    
    static func getAllSparkToken() -> String? {
        return KeychainWrapper.standard.string(forKey: "allSparkToken")
    }
    
    static func setAllSparkToken(allSparkToken: String) {
        KeychainWrapper.standard.set(allSparkToken, forKey: "allSparkToken")
    }
}
