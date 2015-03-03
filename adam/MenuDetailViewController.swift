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
    
    
    var detailParam: [String : String] = ["menuName" : "", "storeName" : "","storeLocaiton" : "","price" : "","distant" : ""]
    var imgURL:NSURL = NSURL(string: "http://upload.wikimedia.org/wikipedia/commons/a/ad/Kyaraben_panda.jpg")!
    var isMenuSet = false
    var menuImage = UIImage(named: "default_bento.jpg")
    
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
        print(imgURL)
        Alamofire.request(.GET, imgURL).progress{ (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
           // self.imgProgressView.setProgress(Float(totalBytesRead) / Float(totalBytesExpectedToRead), animated: true)
                if totalBytesRead == totalBytesExpectedToRead {
                    //   self.imgProgressView.hidden = true
                }
            }
            .response() {
                (_, _, data, _) in
                
                if let image = UIImage(data: data! as NSData) {
                    //self.menuImageURL = imgURL
                    self.menuImageView.image = image
                    //self.imgNotFoundLabel.alpha = 0.0
                } else {
                    //self.imgNotFoundLabel.alpha = 1.0
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
        println(self.menuImageView.frame.size)
        self.setImageByURL(self.imgURL)
    }

}