//
//  TransformerDetailsPresenter.swift
//  TransformersAtWar
//
//  Created by Denis Efremov on 2019-10-27.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

import Foundation

class TransformerDetailsPresenter {
    
    let realmManager = RealmManager()
    
    func createNewTransformer(parameters: [String:Any], completion: @escaping (Bool, Transformer?) -> Void) {
        TransformersApiService.createNewTransformer(parameters: parameters) { (success, transformer) in
            if success {
                self.realmManager.saveTransformer(transformer: transformer!)
            }
            completion(success, transformer)
        }
    }
    
    func updateTransformer(id: String, parameters: [String:Any], completion: @escaping (Bool) -> Void) {
        TransformersApiService.updateTransformer(id: id, parameters: parameters) { (success, transformer) in
            if success {
                self.realmManager.updateTransformer(transformer: transformer!)
            }
            completion(success)
        }
    }
    
}
