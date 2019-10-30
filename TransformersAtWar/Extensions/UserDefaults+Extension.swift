//
//  UserDefaults+Extension.swift
//  TransformersAtWar
//
//  Created by Denis Efremov on 2019-10-29.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

extension UserDefaults {
    // check for is first launch - only true on first invocation after app install, false on all further invocations
    static func isFirstLaunch() {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if (isFirstLaunch) {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
            KeychainWrapper.standard.removeObject(forKey: "allSparkToken")
        }
    }
}
