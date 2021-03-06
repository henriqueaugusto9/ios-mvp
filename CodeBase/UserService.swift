//
//  UserServices.swift
//  CodeBase
//
//  Created by Hafiz on 18/09/2017.
//  Copyright © 2017 github. All rights reserved.
//

import RxSwift
import ObjectMapper

class UserService {
    
    static let bag = DisposeBag()
    
    static func getUsers(callback:@escaping (Bool, [User]?, String?) -> Void) {
        moyaProvider.rx
            .request(GithubAPIService.getUsers)
            .subscribe { event in
                
                switch event {
                case let .success(response):
                    
                    Log.put(response)
                    
                    if response.success {
                        // on success, map to object
                        let data = Mapper<User>().mapArray(JSONObject: response.json)
                        callback(true, data, nil) // callback(success, data, errorMessage)
                        
                    }
                    else {
                        // non 200 status, map to error object
                        let errorResponse = Mapper<APIError>().map(JSONObject: response.json)
                        callback(false, nil, errorResponse?.message)
                    }
                    
                case let .error(error):
                    Log.put(error, type: .error)
                    callback(false, nil, ErrorMessage.unknownAPIError)
                }
                
            }
            .disposed(by: bag)
    }
    
    static func getUser(username: String, callback:@escaping (Bool, User?, String?) -> Void) {
        moyaProvider.rx
            .request(GithubAPIService.getUser(username: username))
            .subscribe { event in
                
                switch event {
                case let .success(response):
                    
                    if response.success {
                        // on success, map to object
                        let data = Mapper<User>().map(JSONObject: response.json)
                        callback(true, data, nil) // callback(success, data, errorMessage)
                        
                    }
                    else {
                        // non 200 status, map to error object
                        let errorResponse = Mapper<APIError>().map(JSONObject: response.json)
                        callback(false, nil, errorResponse?.message)
                    }
                    
                case let .error(error):
                    Log.put(error, type: .error)
                    callback(false, nil, ErrorMessage.unknownAPIError)
                }
                
            }
            .disposed(by: bag)
    }
}
