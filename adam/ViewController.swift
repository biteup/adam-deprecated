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

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate{

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
    var menuArray : NSMutableArray = []
    
    var const:Const         = Const.sharedInstance
    var locationService:LocationService = LocationService.sharedInstance
    
    let locationManager     = CLLocationManager()
    var populateLength      = 3
    var currentLoadedIndex  = 0
    var isPopulating        = false
    var isInitiated         = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateNotificationDiscoverClose", name: discoverCloseNotificationKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateNotificationDiscoverSearch", name: discoverSearchNotificationKey, object: nil)
        
        self.currentLoadedIndex = 0
        self.populateLength     = 3
        
        self.menuTableView.delegate = self
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if (CLLocationManager.authorizationStatus() == .NotDetermined)  {
            self.locationManager.requestAlwaysAuthorization()
        } else {
            isInitiated = true
            self.populateMenu(true, tags: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = menuTableView.indexPathForCell(sender as UITableViewCell){
            var menuVC: MenuDetailViewController = segue.destinationViewController as MenuDetailViewController
            
            let cell: MenuCell = self.menuTableView.cellForRowAtIndexPath(indexPath) as MenuCell
            
            menuVC.detailParam["menuName"] = cell.getMenuNameLabel()
            menuVC.detailParam["storeName"] = cell.getStoreNameLabel()
            menuVC.detailParam["storeLocation"] = cell.getAddress()
            menuVC.detailParam["price"] =  cell.getPriceLabel()
            menuVC.detailParam["distant"] = cell.getDistanceLabel()
            menuVC.imgURL = cell.getImageURL()
            
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        }
    }
    
    
    func initMenu() {
        struct Static {
            static var onceToken : dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            self.populateMenu(false, tags: nil)
        }
    }
    
    func requestGeo() {
        locationManager.startUpdatingLocation()
    }
    
    // authorization status
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            var isUserAnswered = false
            
            switch status {
            case CLAuthorizationStatus.Restricted:
                isUserAnswered = true
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isLocationEnable")
            case CLAuthorizationStatus.Denied:
                isUserAnswered = true
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isLocationEnable")
            case CLAuthorizationStatus.NotDetermined:
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isLocationEnable")
            default:
                isUserAnswered = true
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isLocationEnable")
            }
            if isUserAnswered {
                self.initMenu()
                if !self.isInitiated {
                    self.isInitiated = true
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
                    self.updateLocationInfo(pm)
                } else {
                    println("Problem with the data received from geocoder")
                }
            })
    }

    func updateLocationInfo(placemark: CLPlacemark){
        if placemark.location != nil {
            //stop updating location to save battery life
            self.locationManager.stopUpdatingLocation()
            let coordinate:CLLocationCoordinate2D = placemark.location.coordinate
            locationService.setLocation(placemark.location)
            locationService.setLocality(placemark.locality)
        }
    }


    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location" + error.localizedDescription)
    }
    
    func populateMenu(isReset:Bool, tags: String?) -> Void {
        if self.isPopulating {
            return
        }
        if isReset {
            self.currentLoadedIndex = 0
            self.menuArray = []
        }
        
        isPopulating = true
        var svapi:RestuarantSVAPI = RestuarantSVAPI()
        if let searchTag = tags {
            svapi.getRestuarantByTags(searchTag,
                start: self.currentLoadedIndex,
                limit: self.populateLength,
                {(somejson) -> Void in
                    if let json: AnyObject = somejson{
                        self.currentLoadedIndex += self.populateLength
                        let myJSON = JSON(json)
                        for (index: String, itemJSON: JSON) in myJSON["items"] {
                            if let storeName:String = itemJSON["name"].rawString() {
                                if let storeLocationStr = itemJSON["geolocation"].rawString()  {
                                    let longitudeDbl = itemJSON["geolocation"]["lon"].double!
                                    let latitudeDbl  = itemJSON["geolocation"]["lat"].double!
                                    let storeLocation = CLLocation(latitude: latitudeDbl, longitude: longitudeDbl)
                                    let storeDistance = self.locationService.getDistanceFrom(storeLocation)
                                    let storeAddress  = itemJSON["address"].string!
                                    
                                    for (index: String, menuJSON: JSON) in itemJSON["menus"] {
                                        var imgURLString:String = menuJSON["images"][0].string!
                                        
                                        imgURLString = imgURLString.stringByReplacingOccurrencesOfString("\"", withString: "", options:  NSStringCompareOptions.LiteralSearch, range: nil)
                                        
                                        if let menuName = menuJSON["name"].rawString() {
                                            if let imgURL = NSURL(string: imgURLString) {
                                                if let pointVal = menuJSON["rating"].int {
                                                    if let price    = menuJSON["price"].float {
                                                        var menu:Menu = Menu(menuName: menuName,
                                                            storeName: storeName,
                                                            imgURL: imgURL,
                                                            distanceVal: storeDistance,
                                                            pointVal: pointVal,
                                                            price: price,
                                                            address: storeAddress,
                                                            latitude: latitudeDbl,
                                                            longitude: longitudeDbl)
                                                        self.menuArray.addObject(menu)
                                                        
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if isReset {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.menuTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Bottom)
                            }
                        } else {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.menuTableView.reloadData()
                            }
                            
                            //self.menuTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.None)
                        }
                        self.isPopulating = false
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
                        let lastItem = self.menuArray.count
                        
                        let myJSON = JSON(json)
                        for (index: String, itemJSON: JSON) in myJSON["items"] {
                            if let storeName:String = itemJSON["name"].rawString() {
                                if let storeLocationStr = itemJSON["geolocation"].rawString()  {
                                    let longitudeDbl = itemJSON["geolocation"]["lon"].double!
                                    let latitudeDbl  = itemJSON["geolocation"]["lat"].double!
                                    let storeLocation = CLLocation(latitude: latitudeDbl, longitude: longitudeDbl)
                                    let storeDistance = self.locationService.getDistanceFrom(storeLocation)
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
                                                            address: storeAddress,
                                                            latitude: latitudeDbl,
                                                            longitude: longitudeDbl)
                                                        self.menuArray.addObject(menu)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if isReset {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.menuTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Bottom)
                            }
                            
                        } else {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.menuTableView.reloadData()
                                
                                //self.menuTableView.
                                //self.menuTableView.reloadSections(NSIndexSet(index: lastItem), withRowAnimation: UITableViewRowAnimation.Bottom)
                            }
                        }
                        self.isPopulating = false
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

        let cell:MenuCell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath) as MenuCell

        if menuArray.count <= 0 {
            return cell
        }
        
        let menu = menuArray.objectAtIndex(indexPath.row) as Menu
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)){
            cell.setImageByURL(menu.imgURL)
        }
        
        let storeDistance = self.locationService.getDistanceFrom(CLLocation(latitude: menu.latitude, longitude: menu.longitude))
        
        cell.setMenuCell(menu.menuName, storeName: menu.storeName, distanceVal: storeDistance, pointVal: menu.pointVal, price: menu.price, address: menu.address)
        
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if !isInitiated {
            return
        }
        if scrollView.contentOffset.y + view.frame.size.height > scrollView.contentSize.height * 0.8 {
            if let searchTag = const.getConst("search", key: "tag") {
                self.populateMenu(false, tags: searchTag)
            } else {
                self.populateMenu(false, tags: nil)
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
        // Mixapanel Track
        var mixPanelInstance:Mixpanel = Mixpanel.sharedInstance()
        
        // reload here
        self.navigationController?.view.resignFirstResponder()
        self.menuTableView.userInteractionEnabled = true
        self.myButton.enabled = true
        if let searchTag = const.getConst("search", key: "picker") {
            mixPanelInstance.track("Simulate Search Tag", properties: ["Tag" : searchTag])
            const.setConst("search", key: "tag", value: searchTag)
            self.populateMenu(true, tags: searchTag)
        }
        const.deleteConst("search", key: "picker")
    }
    
    func updateLocation() {
        
    }
}

