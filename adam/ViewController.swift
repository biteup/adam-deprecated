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

let discoverCloseNotificationKey = "me.gobbl.adam.discoverCloseNotificationKey"
let discoverSearchNotificationKey = "me.gobbl.adam.discoverSearchNotificationKey"

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var myButton: UIButton!

    @IBAction func onClick(sender: AnyObject) {
        self.menuTableView.userInteractionEnabled = false
        self.myButton.enabled = false
        self.requestGeo()
        var discoverVC: DiscoverViewConroller = DiscoverViewConroller(nibName: "DiscoverView", bundle: nil)
        var discoverView = discoverVC.view
        self.navigationController?.addChildViewController(discoverVC)
        self.navigationController?.view.addSubview(discoverVC.view)
    }
    
    var menuArray:[Menu]    = [Menu]()
    var const:Const         = Const.sharedInstance
    let locationManager     = CLLocationManager()
    var populateLength = 3
    var currentLoadedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let app:UIApplication = UIApplication.sharedApplication()
        app.networkActivityIndicatorVisible = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateNotificationDiscoverClose", name: discoverCloseNotificationKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateNotificationDiscoverSearch", name: discoverSearchNotificationKey, object: nil)
        
        self.currentLoadedIndex = 0
        self.populateLength     = 3
        
        
        self.menuTableView.delegate = self
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.setNeedsStatusBarAppearanceUpdate()
        self.populateMenu(false, tags: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = menuTableView.indexPathForCell(sender as UITableViewCell){
            var menuVC: MenuDetailViewController = segue.destinationViewController as MenuDetailViewController
            
            let cell: MenuCell = self.menuTableView.cellForRowAtIndexPath(indexPath) as MenuCell
            
            menuVC.detailParam["menuName"] = cell.getMenuNameLabel() //  cell.menuNameLabel.text
            menuVC.detailParam["storeName"] = cell.getStoreNameLabel()// cell.storeNameLabel.text
            menuVC.detailParam["storeLocation"] = cell.getAddress() // "Roppongi"
            menuVC.detailParam["price"] =  cell.getPriceLabel()
            menuVC.detailParam["distant"] = cell.getDistanceLabel() //cell.distantLabel.text
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        }
    }
    func requestGeo() {
        locationManager.startUpdatingLocation()
    }
    
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

    func updateLocationInfo(placemark: CLPlacemark){
        if placemark.location != nil {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let coordinate:CLLocationCoordinate2D = placemark.location.coordinate
            println(placemark.location)
            println(coordinate.latitude.description, coordinate.longitude.description)
            
            const.setConst("location", key: "latitude", value: coordinate.latitude.description)
            const.setConst("location", key: "longitude", value: coordinate.longitude.description)
            const.setConst("location", key: "locality", value: placemark.locality)
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
    
    func populateMenu(isReset:Bool, tags: String?) {
        if isReset {
            self.currentLoadedIndex = 0
            self.menuArray = []
        }
        
        var svapi:RestuarantSVAPI = RestuarantSVAPI()
        var current: CLLocation = CLLocation(latitude: 35.6895, longitude: 139.6917)
        if let latitudeStr = self.const.getConst("location", key: "latitude") {
            if let longitudeStr = self.const.getConst("location", key: "longitude") {
                let latitudeDbl  = (latitudeStr as NSString).doubleValue
                let longitudeDbl = (longitudeStr as NSString).doubleValue
                current = CLLocation(latitude: latitudeDbl, longitude: longitudeDbl)
            }
        }
    /*    let activityView:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        activityView.center =   self.view.center;
        activityView.startAnimating()
        menuTableView.addSubview(activityView)*/
        if let searchTag = tags {
            svapi.getRestuarantByTags(searchTag,
                start: self.currentLoadedIndex,
                limit: self.populateLength,
                {(somejson) -> Void in
                    if let json: AnyObject = somejson{
                        self.currentLoadedIndex += self.populateLength
                        println("Start")
                        println(NSDate())
                        let myJSON = JSON(json)
                        println(myJSON)
                        //println(myJSON)
                        for (index: String, itemJSON: JSON) in myJSON["items"] {
                            if let storeName:String = itemJSON["name"].rawString() {
                                if let storeLocationStr = itemJSON["geolocation"].rawString()  {
                                    let longitudeDbl = itemJSON["geolocation"]["lon"].double
                                    let latitudeDbl  = itemJSON["geolocation"]["lat"].double
                                    let storeLocation = CLLocation(latitude: latitudeDbl!, longitude: longitudeDbl!)
                                    let storeDistance = current.distanceFromLocation(storeLocation) / 1000
                                    let storeAddress  = itemJSON["address"].string!
                                    
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
                                                            price: price,
                                                            address: storeAddress)
                                                        self.menuArray.append(menu)
                                                        
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if isReset {
                            self.menuTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Bottom)
                        } else {
                            self.menuTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.None)
                        }
                        //activityView.stopAnimating()
                    }
                },
                {()->Void in
                    println("Error")
            })
        } else {
            svapi.getRestuarant(self.currentLoadedIndex,
                limit: self.populateLength,
                {(somejson) -> Void in
                    if let json: AnyObject = somejson{
                        self.currentLoadedIndex += self.populateLength
                        println("Start")
                        println(NSDate())
                        let myJSON = JSON(json)
                        println(myJSON)
                        //println(myJSON)
                        for (index: String, itemJSON: JSON) in myJSON["items"] {
                            if let storeName:String = itemJSON["name"].rawString() {
                                if let storeLocationStr = itemJSON["geolocation"].rawString()  {
                                    let longitudeDbl = itemJSON["geolocation"]["lon"].double
                                    let latitudeDbl  = itemJSON["geolocation"]["lat"].double
                                    let storeLocation = CLLocation(latitude: latitudeDbl!, longitude: longitudeDbl!)
                                    let storeDistance = current.distanceFromLocation(storeLocation) / 1000
                                    let storeAddress  = itemJSON["address"].string!
                                    
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
                                                            price: price,
                                                            address: storeAddress)
                                                        self.menuArray.append(menu)
                                                        
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if isReset {
                            self.menuTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Bottom)
                        } else {
                            self.menuTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.None)
                        }
                        //activityView.stopAnimating()
                    }
                },
                {()->Void in
                    println("Error")
            })
        
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell: MenuCell = tableView.dequeueReusableCellWithIdentifier("menuCell") as MenuCell
        if menuArray.count <= 0 {
            return cell
        }
        
        let menu = menuArray[indexPath.row]

        cell.setMenuCell(menu.menuName, storeName: menu.storeName, imgURL: menu.imgURL, distanceVal: menu.distanceVal, pointVal: menu.pointVal, price: menu.price, address: menu.address)
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y + view.frame.size.height > scrollView.contentSize.height * 0.8 {
            if let searchTag = const.getConst("search", key: "tag") {
                populateMenu(false, tags: searchTag)
            } else {
                populateMenu(false, tags: nil)
            }
        }
    }
    
    func updateNotificationDiscoverClose() {
        // reload here
        self.navigationController?.view.resignFirstResponder()
        self.menuTableView.userInteractionEnabled = true
        self.myButton.enabled = true
        const.deleteConst("search", key: "picker")
    }
    
    func updateNotificationDiscoverSearch() {
        // reload here
        self.navigationController?.view.resignFirstResponder()
        self.menuTableView.userInteractionEnabled = true
        self.myButton.enabled = true
        if let searchTag = const.getConst("search", key: "picker") {
            const.setConst("search", key: "tag", value: searchTag)
            populateMenu(true, tags: searchTag)
        }
        const.deleteConst("search", key: "picker")
    }
    
}

