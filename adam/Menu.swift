//
//  Menu.swift
//  adam
//
//  Created by ariyasuk-k on 2015/01/23.
//  Copyright (c) 2015年 Benri. All rights reserved.
//

import Foundation

class Menu {
    var menuName: String   = "name"
    var storeName: String  = "res_name"
    var imgURL: NSURL      = NSURL(string: "http://someurl.com")!
    var distanceVal:Float  = 1.0
    var pointVal:Int       = 1
    var price:Float        = 800
    
    init(menuName: String, storeName: String, imgURL: NSURL, distanceVal: Float, pointVal: Int, price: Float) {
        self.menuName       = menuName
        self.storeName      = storeName
        self.imgURL         = imgURL
        self.distanceVal    = distanceVal
        self.pointVal       = pointVal
        self.price          = price
    }
}