//
//  MenuDetailViewController.swift
//  adam
//
//  Created by Kittikorn Ariyasuk on 2/7/15.
//  Copyright (c) 2015 Benri. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class MenuDetailViewController : UIViewController {
    
    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeLocationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var distantLabel: UILabel!
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var imageProgressView: UIProgressView!
    
    
    var detailParam: [String : String] = ["menuName" : "", "storeName" : "","storeLocaiton" : "","price" : "","distant" : ""]
    var imgURL:NSURL = NSURL(string: "http://upload.wikimedia.org/wikipedia/commons/a/ad/Kyaraben_panda.jpg")!
    var isMenuSet = false
    var menuImage = UIImage(named: "default_bento.jpg")
    var imgCache:ImageCache = ImageCache.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var mixPanelInstance:Mixpanel = Mixpanel.sharedInstance()
        mixPanelInstance.track("Simulate Bento Viewed", properties: ["Menu" : self.detailParam["menuName"]!, "name" : "iOS"])
        self.setupDetail()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resizePriceLabelFrame(priceText: String){
        //Calculate the expected size based on the font and linebreak mode of your label
        var maximumLabelSize: CGSize = CGSizeMake(320, 50)
        let myPriceText: NSString = priceText as NSString
        let expectedLabelSize: CGSize = myPriceText.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(17.0)])
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        
        var newFrame: CGRect = priceLabel.frame
        newFrame.size.width = round(expectedLabelSize.width)
        newFrame.origin.x   = screenWidth - newFrame.size.width
        
        priceLabel.text = priceText
        priceLabel.frame = newFrame
        priceLabel.textAlignment = NSTextAlignment.Center
        
    }
    
    func setImageByURL(imgURL: NSURL) {
        if let image = imgCache.loadImage(imgURL) {
            self.menuImageView.image = image
        } else {
            Alamofire.request(.GET, imgURL).progress{ (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                self.imageProgressView.setProgress(Float(totalBytesRead) / Float(totalBytesExpectedToRead), animated: true)
                if totalBytesRead == totalBytesExpectedToRead {
                    self.imageProgressView.hidden = true
                }
                }
                .response() {
                    (request, response, data, error) in
                    
                    if let image = UIImage(data: data! as NSData) {
                        self.menuImageView.image = image
                        self.imgCache.cacheImage(request.URL, image: image)
                    } else {
                        
                    }
            }
        }
    }
    
    func setupDetail(){
        self.menuNameLabel.text         = self.detailParam["menuName"]
        self.storeNameLabel.text        = self.detailParam["storeName"]
        self.storeLocationLabel.text    = self.detailParam["storeLocation"]
        self.resizePriceLabelFrame(self.detailParam["price"]!)
        self.distantLabel.text          = self.detailParam["distant"]
        self.storeLocationLabel.sizeToFit()
        self.setImageByURL(self.imgURL)
    }

}