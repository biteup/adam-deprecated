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
    
    func getRestuarantByID(id:Int, successCallback:(json:AnyObject?)->Void, errorCallback:()->Void){
        
        let my_response = Alamofire.request(.GET, apiBaseURL + apiEndPoint, parameters : ["id":id])
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
    
    
}