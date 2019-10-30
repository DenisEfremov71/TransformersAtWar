//
//  UIApplication+Extension.swift
//  TransformersAtWar
//
//  Created by Denis Efremov on 2019-10-29.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}
