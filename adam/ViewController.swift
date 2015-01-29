//
//  ViewController.swift
//  adam
//
//  Created by Kittikorn Ariyasuk on 1/11/15.
//  Copyright (c) 2015 Benri. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var myButton: UIButton!

    @IBAction func onClick(sender: AnyObject) {
        self.getGeo()
    }
    
    var menuArray:[Menu] = [Menu]()
    var const:Const = Const.sharedInstance
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setNeedsStatusBarAppearanceUpdate()
        self.getGeo()
        self.setupMenu()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getGeo() {
        println("Display geo")
        locationManager.delegate = self
        println("Display geo")
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        println("Display geo")
        locationManager.requestWhenInUseAuthorization()
        println("Display geo")
        locationManager.startUpdatingLocation()
        println("Display geo")
        Alamofire.request(.GET, "http://httpbin.org/get", parameters: ["foo": "bar"])
            .response { (request, response, data, error) in
                println(request)
                println(response)
                println(error)
        }
        var url = "http://snakebite.herokuapp.com/restaurants"
        Alamofire.request(.GET, url, parameters: ["": ""])
            .responseJSON { (req, res, json, error) in
                if(error != nil) {
                    NSLog("Error: \(error)")
                    println(req)
                    println(res)
                }
                else {
                    println("Success: \(url)")
                    println(res)
                    var json = JSON(json!)
                    println(json)
                }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
            CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
                
                if (error != nil) {
                    println("Reverse geocoder failed with error" + error.localizedDescription)
                    return
                }
                
                if placemarks.count > 0 {
                    let pm = placemarks[0] as CLPlacemark
                    self.displayLocationInfo(pm)
                } else {
                    println("Problem with the data received from geocoder")
                }
            })
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
        if placemark.location != nil {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            if placemark.locality != nil {
                println(placemark.locality)
            }
            if placemark.postalCode != nil {
                println(placemark.postalCode)
            }
            if placemark.administrativeArea  != nil {
                println(placemark.administrativeArea )
            }
            if placemark.country != nil {
                println(placemark.country)
            }
        }
    }


    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location" + error.localizedDescription)
    }
    
    func setupMenu() {
        
        var menu1 = Menu(menuName: "幕の内弁当", storeName: "六本木駅弁", imgName: "幕の内弁当.jpg", distanceVal: 1.1, pointVal: 10, price: 1000)
        var menu2 = Menu(menuName: "ビ弁当", storeName: "六本木一丁目駅弁", imgName: "ビ弁当.jpg", distanceVal: 1.1, pointVal: 10, price: 800)
        var menu3 = Menu(menuName: "幕の内弁当", storeName: "六本木駅弁", imgName: "幕の内弁当.jpg", distanceVal: 1.1, pointVal: 10, price: 1000)
        var menu4 = Menu(menuName: "ビ弁当", storeName: "六本木一丁目駅弁", imgName: "ビ弁当.jpg", distanceVal: 1.1, pointVal: 10, price: 800)
        var menu5 = Menu(menuName: "ビ弁当", storeName: "六本木一丁目駅弁", imgName: "ビ弁当.jpg", distanceVal: 1.1, pointVal: 10, price: 800)
        var menu6 = Menu(menuName: "ビ弁当", storeName: "六本木一丁目駅弁", imgName: "ビ弁当.jpg", distanceVal: 1.1, pointVal: 10, price: 800)
        
        menuArray.append(menu1)
        menuArray.append(menu2)
        menuArray.append(menu3)
        menuArray.append(menu4)
        menuArray.append(menu5)
        menuArray.append(menu6)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: MenuCell = tableView.dequeueReusableCellWithIdentifier("menuCell") as MenuCell
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 255, green: 255, blue: 50, alpha: 1.0)
        }
        else {
           // cell.backgroundColor = UIColor.greenColor()
        }
        
        let menu = menuArray[indexPath.row]
        
        cell.setMenuCell(menu.menuName, storeName: menu.storeName, imgName: menu.imgName, distanceVal: menu.distanceVal, pointVal: menu.pointVal, price: menu.price)
        
        return cell
    }
}

