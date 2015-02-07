//
//  MenuDetailViewController.swift
//  adam
//
//  Created by Kittikorn Ariyasuk on 2/7/15.
//  Copyright (c) 2015 Benri. All rights reserved.
//

import UIKit
import Foundation


class MenuDetailViewController : UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeLocationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var distantLabel: UILabel!
    
    
    var detailParam: [String : String] = ["menuName" : "", "storeName" : "","storeLocaiton" : "","price" : "","distant" : ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setNeedsStatusBarAppearanceUpdate()
        println("Hey, buddy")
   /*     self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.setupMenu()*/
        self.setupDetail()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupDetail(){
        self.menuNameLabel.text         = self.detailParam["menuName"]
        self.storeNameLabel.text        = self.detailParam["storeName"]
        self.storeLocationLabel.text    = self.detailParam["storeLocation"]
        self.priceLabel.text            = self.detailParam["price"]
        self.distantLabel.text          = self.detailParam["distant"]
    }

}