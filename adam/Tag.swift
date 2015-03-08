//
//  Tag.swift
//  adam
//
//  Created by Kittikorn Ariyasuk on 2/10/15.
//  Copyright (c) 2015 Benri. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class TagSVAPI {
    
    let apiBaseURL:String   = "http://snakebite.herokuapp.com"
    let apiEndPoint:String  = "/tags"
    
    init(){
        
    }
    func getTags(limit:Int, successCallback:(json:AnyObject?)->Void, errorCallback:()->Void){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let my_response = Alamofire.request(.GET, apiBaseURL + apiEndPoint,parameters: ["limit": limit])
            .responseJSON({ (req, res, json, error) in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if(error != nil) {
                    NSLog("Error: \(error)")
                    println(req)
                    println(res)
                    errorCallback()
                }
                else {
                    successCallback(json: json)
                }
            })
    }
}