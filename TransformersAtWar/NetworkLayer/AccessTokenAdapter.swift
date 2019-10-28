//
//  AccessTokenAdapter.swift
//  TransformersAtWar
//
//  Created by Denis Efremov on 2019-10-26.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

import Foundation
import Alamofire

/*
class AccessTokenAdapter: RequestAdapter, RequestRetrier {
    private let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(Constants.ApiEndPoints.apiPrefix) {
            //urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
            urlRequest.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0cmFuc2Zvcm1lcnNJZCI6Ii1MczdJZ1M2bWlrSVpjcmVHRy1fIiwiaWF0IjoxNTcyMDk3NDE0fQ.NyRjEmSd04JuLrcWalamVMRwkFwpKArYiC8M1MQqr-E", forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(false, 0.0)
            return
        }
    }
}
*/

////////////////////AccessTokenAdapter

//class OAuth2Handler: RequestAdapter, RequestRetrier {
class AccessTokenAdapter: RequestAdapter, RequestRetrier {
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?) -> Void
    
    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        return SessionManager(configuration: configuration)
    }()
    
    private let lock = NSLock()
    
    private var baseURLString: String
    private var accessToken: String
    
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    // MARK: - Initialization
    
    public init(baseURLString: String, accessToken: String) {
        self.baseURLString = baseURLString
        self.accessToken = accessToken
    }
    
    // MARK: - RequestAdapter
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(baseURLString) {
            var urlRequest = urlRequest
            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
            //urlRequest.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0cmFuc2Zvcm1lcnNJZCI6Ii1Mc0N4Snp0WFhUOTRpM3haMklIIiwiaWF0IjoxNTcyMTkyMjEwfQ.Wlc7jFuvFUwZjwTpeTIvhZ2WWbD-YcnG6SfKUX2npaY", forHTTPHeaderField: "Authorization")
            return urlRequest
        }
        
        return urlRequest
    }
    
    // MARK: - RequestRetrier
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock() ; defer { lock.unlock() }
        
        let codes = [401, 404]
        
        if let response = request.task?.response as? HTTPURLResponse, codes.contains(response.statusCode) {
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                refreshTokens { [weak self] succeeded, accessToken in
                    guard let strongSelf = self else { return }
                    
                    strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
                    
                    if let accessToken = accessToken {
                        strongSelf.accessToken = accessToken
                    }
                    
                    strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
                    strongSelf.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(false, 0.0)
        }
    }
    
    // MARK: - Private - Refresh Tokens
    
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }
        
        isRefreshing = true
        
        let urlString = "\(Constants.ApiEndPoints.fetchToken)"
        
        sessionManager.request(urlString).responseString { [weak self] response in
            
            guard let strongSelf = self else { return }
            
            if let token = response.value {
                completion(true, token)
            } else {
                completion(false, nil)
            }
            
            strongSelf.isRefreshing = false
        }
    }
}
