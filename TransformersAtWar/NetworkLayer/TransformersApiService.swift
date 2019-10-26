//
//  TransformersApiService.swift
//  TransformersAtWar
//
//  Created by Denis Efremov on 2019-10-26.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

import Foundation
import Alamofire

class TransformersApiService {
    
    func fetchAllSparkToken() {
        Alamofire.request(Constants.ApiEndPoints.fetchToken).responseString { (response) in
            guard let token = response.value else {
                //TODO: add error handling!!!
                return
            }
            KeychainHelper.setAllSparkToken(allSparkToken: token)
            print("\(KeychainHelper.getAllSparkToken() ?? "no token")")
        }
    }
    
}
