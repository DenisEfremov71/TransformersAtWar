//
//  TransformerListPresenter.swift
//  TransformersAtWar
//
//  Created by Denis Efremov on 2019-10-26.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

import Foundation

class TransformerListPresenter {
    
    var apiService = TransformersApiService()
    
    func checkAllSparkToken() {
        if KeychainHelper.getAllSparkToken() == nil {
            apiService.fetchAllSparkToken()
        }
    }
    
}
