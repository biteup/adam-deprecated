//
//  ViewController.swift
//  adam
//
//  Created by Kittikorn Ariyasuk on 1/11/15.
//  Copyright (c) 2015 Benri. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var myButton: UIButton!

    @IBAction func onClick(sender: AnyObject) {
        self.requestGeo()
        var discoverVC: DiscoverViewConroller = DiscoverViewConroller(nibName: "DiscoverView", bundle: nil)
        var discoverView = discoverVC.view
        self.navigationController?.view.addSubview(discoverVC.view)
    }
    
    var menuArray:[Menu]    = [Menu]()
    var const:Const         = Const.sharedInstance
    let locationManager     = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()

        self.setupMenu()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = menuTableView.indexPathForCell(sender as UITableViewCell){
            var menuVC: MenuDetailViewController = segue.destinationViewController as MenuDetailViewController
            let cell: MenuCell = self.menuTableView.cellForRowAtIndexPath(indexPath) as MenuCell
            menuVC.detailParam["menuName"] = cell.menuNameLabel.text
            menuVC.detailParam["storeName"] = cell.storeNameLabel.text
            menuVC.detailParam["storeLocation"] = "Roppongi"
            menuVC.detailParam["price"] = cell.priceLabel.text
            menuVC.detailParam["distant"] = cell.distantLabel.text
                
            println(cell.menuNameLabel.text)
            //menuVC.recivedMenuName = "Heyyyy"
        }
        
        
        // selectIndexPath : NSIndexPath = self.tableView.i
        
      //  NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
       // UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:selectedIndexPath];
       // NSLog(@"%@", cell.textLabel.text);
        
    }
    
    func requestGeo() {
        locationManager.startUpdatingLocation()
    }
    /*
    *
    *  didUpdateLocations
    *
    */
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
            CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
                
                if (error != nil) {
                    println("Reverse geocoder failed with error" + error.localizedDescription)
                    return
                }
                
                if placemarks.count > 0 {
                    let pm = placemarks[0] as CLPlacemark
                    self.updateLocationInfo(pm)
                } else {
                    println("Problem with the data received from geocoder")
                }
            })
    }
    /// updateLocationInfo
    /// 1. This will update constant shared value of location
    /// 2. This will stop updating Location sevice.
    ///
    ///
    /// :param: placemark in CLPlacemark
    /// :returns: latitude and longitude
    func updateLocationInfo(placemark: CLPlacemark){
        if placemark.location != nil {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let coordinate:CLLocationCoordinate2D = placemark.location.coordinate
            println(placemark.location)
            println(coordinate.latitude.description, coordinate.longitude.description)
            
            const.setConst("location", key: "latitude", value: coordinate.latitude.description)
            const.setConst("location", key: "longitude", value: coordinate.longitude.description)
            /*
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
            }*/
        }
    }


    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location" + error.localizedDescription)
    }
    
    func setupMenu() {
        var svapi:RestuarantSVAPI = RestuarantSVAPI()
        var current: CLLocation = CLLocation(latitude: 35.6895, longitude: 139.6917)
        if let latitudeStr = self.const.getConst("location", key: "latitude") {
            if let longitudeStr = self.const.getConst("location", key: "longitude") {
                let latitudeDbl  = (latitudeStr as NSString).doubleValue
                let longitudeDbl = (longitudeStr as NSString).doubleValue
                current = CLLocation(latitude: latitudeDbl, longitude: longitudeDbl)
            }
        }
        let activityView:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        activityView.center =   self.view.center;
        activityView.startAnimating()
        menuTableView.addSubview(activityView)
        
        svapi.getRestuarantAll(10,
            {(somejson) -> Void in
                if let json: AnyObject = somejson{
                    println("Start")
                    println(NSDate())
                    let myJSON = JSON(json)
                    //println(myJSON)
                    for (index: String, itemJSON: JSON) in myJSON["items"] {
                        if let storeName:String = itemJSON["name"].rawString() {
                            if let storeLocationStr = itemJSON["geolocation"].rawString()  {
                                let longitudeDbl = itemJSON["geolocation"]["lon"].double
                                let latitudeDbl  = itemJSON["geolocation"]["lat"].double
                               // let longitudeDbl:Double = (longitude.rawString() as NSString).doubleValue
                               // let latitudeDbl:Double = (latitude.rawString() as NSString).doubleValue
                                let storeLocation = CLLocation(latitude: latitudeDbl!, longitude: longitudeDbl!)
                                let storeDistance = current.distanceFromLocation(storeLocation) / 1000
                                
                                
                                for (index: String, menuJSON: JSON) in itemJSON["menus"] {
                                    var imgURLString:String = menuJSON["images"][0].string!
                                
                                    imgURLString = imgURLString.stringByReplacingOccurrencesOfString("\"", withString: "", options:  NSStringCompareOptions.LiteralSearch, range: nil)
                                
                                    if let menuName = menuJSON["name"].rawString() {
                                        if let imgURL = NSURL(string: imgURLString) {
                                            if let pointVal = menuJSON["rating"].int {
                                                if let price    = menuJSON["price"].float {
                                                    var menu = Menu(menuName: menuName,
                                                        storeName: storeName,
                                                        imgURL: imgURL,
                                                        distanceVal: storeDistance,
                                                        pointVal: pointVal,
                                                        price: price)
                                                    self.menuArray.append(menu)

                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    println("End")
                    println(NSDate())
                    self.menuTableView.reloadData()
                    activityView.stopAnimating()
                }
            },
            {()->Void in
                println("Error")
            })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell: MenuCell = tableView.dequeueReusableCellWithIdentifier("menuCell") as MenuCell
        if menuArray.count <= 0 {
            return cell
        }
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 255, green: 255, blue: 50, alpha: 1.0)
        }
        else {
           // cell.backgroundColor = UIColor.greenColor()
        }
        
        let menu = menuArray[indexPath.row]

        cell.setMenuCell(menu.menuName, storeName: menu.storeName, imgURL: menu.imgURL, distanceVal: menu.distanceVal, pointVal: menu.pointVal, price: menu.price)
        return cell
    }
}

