//
//  ViewControllerExtensions.swift
//  TransformersAtWar
//
//  Created by Denis Efremov on 2019-10-28.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

import Foundation
import UIKit

extension TransformerDetailsViewController {
    func initUI(mode: Mode) {
        
        if mode == .add {
            sliderStrength.value = Float(currentStrength)
            sliderIntelligence.value = Float(currentIntelligence)
            sliderSpeed.value = Float(currentSpeed)
            sliderEndurance.value = Float(currentEndurance)
            sliderRank.value = Float(currentRank)
            sliderCourage.value = Float(currentCourage)
            sliderFirepower.value = Float(currentFirepower)
            sliderSkill.value = Float(currentSkill)
        } else if mode == .edit {
            guard let transformer = self.transformer else {
                UiHelper.showAlert(for: self, with: Constants.ErrorMessaages.noTransformerSelected)
                return
            }
            txtName.text = transformer.name
            txtTeam.text = transformer.team
            labelStrength.text = "\(transformer.strength)"
            sliderStrength.value = Float(transformer.strength)
            currentStrength = transformer.strength
            labelIntelligence.text = "\(transformer.intelligence)"
            sliderIntelligence.value = Float(transformer.intelligence)
            currentIntelligence = transformer.intelligence
            labelSpeed.text = "\(transformer.speed)"
            sliderSpeed.value = Float(transformer.speed)
            currentSpeed = transformer.speed
            labelEndurance.text = "\(transformer.endurance)"
            sliderEndurance.value = Float(transformer.endurance)
            currentEndurance = transformer.endurance
            labelRank.text = "\(transformer.rank)"
            sliderRank.value = Float(transformer.rank)
            currentRank = transformer.rank
            labelCourage.text = "\(transformer.courage)"
            sliderCourage.value = Float(transformer.courage)
            currentCourage = transformer.courage
            labelFirepower.text = "\(transformer.firepower)"
            sliderFirepower.value = Float(transformer.firepower)
            currentFirepower = transformer.firepower
            labelSkill.text = "\(transformer.skill)"
            sliderSkill.value = Float(transformer.skill)
            currentSkill = transformer.skill
        }
    }
}

extension TransformerListTableViewController {
    func createSpinnerView(completion: @escaping () -> Void) {
        let child = SpinnerViewController()
        
        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        // wait two seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
            completion()
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}
