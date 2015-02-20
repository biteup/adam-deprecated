//
//  Restuarants.swift
//  adam
//
//  Created by ariyasuk-k on 2015/02/03.
//  Copyright (c) 2015年 Benri. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

// TODO Authentication
class RestuarantSVAPI {
    
    let apiBaseURL:String   = "http://snakebite.herokuapp.com"
    let apiEndPoint:String  = "/restaurants"
    
    init(){
    
    }
    func getRestuarantAll(limit:Int, successCallback:(json:AnyObject?)->Void, errorCallback:()->Void){
        
        let my_response = Alamofire.request(.GET, apiBaseURL + apiEndPoint)
            .responseJSON({ (req, res, json, error) in
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
    
    func getRestuarant(start:Int, limit:Int, successCallback:(json:AnyObject?)->Void, errorCallback:()->Void){
        
        let params = [
            "start": String(start),
            "limit": String(limit)
        ]
        
        let my_response = Alamofire.request(.GET, apiBaseURL + apiEndPoint, parameters: params)
            .responseJSON({ (req, res, json, error) in
                if(error != nil) {
                    NSLog("Error: \(error)")
                    println(req)
                    println(res)
                    errorCallback()
                }
                else {
                    println(req)
                    successCallback(json: json)
                }
            })
    }
    
    func getRestuarantByTags(tags:String, start:Int, limit:Int, successCallback:(json:AnyObject?)->Void, errorCallback:()->Void){
        
        let params = [
            "tags"  : tags,
            "start": String(start),
            "limit": String(limit)
        ]
        
        let my_response = Alamofire.request(.GET, apiBaseURL + apiEndPoint, parameters: params)
            .responseJSON({ (req, res, json, error) in
                if(error != nil) {
                    NSLog("Error: \(error)")
                    println(req)
                    println(res)
                    errorCallback()
                }
                else {
                    println(req)
                    successCallback(json: json)
                }
            })
    }
}