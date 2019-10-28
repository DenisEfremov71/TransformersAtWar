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
    
}
