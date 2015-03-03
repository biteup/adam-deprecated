//
//  MenuCell.swift
//  adam
//
//  Created by ariyasuk-k on 2015/01/23.
//  Copyright (c) 2015年 Benri. All rights reserved.
//

import UIKit
import Alamofire

class MenuCell: UITableViewCell {

    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!

    @IBOutlet weak var distantLabel: UILabel!
    @IBOutlet weak var imgNotFoundLabel: UILabel!
    @IBOutlet weak var imgProgressView: UIProgressView!

    var menuName: String = ""
    var storeName: String = ""
    var menuImageURL: NSURL = NSURL(string: "http://upload.wikimedia.org/wikipedia/commons/a/ad/Kyaraben_panda.jpg")!
    var price: String = ""
    var distant: String = ""
    var address: String = ""
    var isImageSet:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.menuNameLabel.text = ""
        self.storeNameLabel.text = ""
        self.menuImageView.image = nil
        self.priceLabel.text = ""
        self.distantLabel.text = ""
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
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
    
    func setPriceLabel(price: Float){
        var const:Const = Const.sharedInstance
        var priceText = ""
        if price % 1 == 0 {
            priceText = String(format: "%.0f", price)
        }
        else {
            priceText = String(format: "%.2f", price)
        }
        
        if let currency = const.getConst("setting", key: "CURRENCY") {
            if let currencySign = const.getConst("currencySign", key: currency) {
                priceText = " " + currencySign + " " + priceText + "  "
            }
        }
        resizePriceLabelFrame(priceText)
    }
    
    func getPriceLabel() -> String? {
        return self.priceLabel.text
    }
    
    func setMenuNameLabel(name: String) {
        self.menuName = name
        self.menuNameLabel.text = name
    }
    
    func getMenuNameLabel() ->String? {
        return self.menuNameLabel.text
    }
    
    func setStoreNameLabel(name: String) {
        self.storeNameLabel.text = name
    }
    
    func getStoreNameLabel() ->String? {
        return self.storeNameLabel.text
    }
    
    func setDistanceLabel(distance: Double) {
        var formatter : String = String(format: "%.02f km", distance)
        self.distantLabel.text = formatter
    }
    
    func getDistanceLabel() ->String? {
        return self.distantLabel.text
    }
    
    func setImage(image: UIImage) {
        self.menuImageView.image = image
    }
    
    func setImageByName(imgName: String) {
        self.menuImageView.image = UIImage(named: imgName)
    }
    
    func setImageByURL(imgURL: NSURL, menuObj:Menu) {
        self.menuImageURL = imgURL
        
        Alamofire.request(.GET, imgURL).progress{ (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
            dispatch_async(dispatch_get_main_queue()) {
                self.imgProgressView.setProgress(Float(totalBytesRead) / Float(totalBytesExpectedToRead), animated: true)
            }
            if totalBytesRead == totalBytesExpectedToRead {
                self.imgProgressView.hidden = true
                self.menuImageView.hidden = false
            } else {
            }
            }
            .response() {
                (_, _, data, _) in
                if let image = UIImage(data: data! as NSData) {
                    dispatch_async(dispatch_get_main_queue()){
                        self.imgNotFoundLabel.alpha = 0.0
                        self.menuImageView.image = image
                        menuObj.setMenuImage(image)
                    }
                } else {
                    self.imgNotFoundLabel.alpha = 1.0
                }
            }
    }
    
    func getImageURL() -> NSURL {
        return self.menuImageURL
    }

    func setAddress(address:String) {
        self.address = address
    }

    func getAddress() -> String?{
        return self.address
    }

    func setMenuCell(inMenuName: String, storeName: String, distanceVal:Double, pointVal: Int, price:Float, address: String) {
        
        self.setMenuNameLabel(inMenuName)
        self.setStoreNameLabel(storeName)
        self.setPriceLabel(price)
        self.setDistanceLabel(distanceVal)
        self.setAddress(address)
    }
}
