//
//  MenuCell.swift
//  adam
//
//  Created by ariyasuk-k on 2015/01/23.
//  Copyright (c) 2015年 Benri. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var distantLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
        
        println(priceText)
        if let currency = const.getConst("setting", key: "CURRENCY") {
            if let currencySign = const.getConst("currencySign", key: currency) {
                priceText = " " + currencySign + " " + priceText + "  "
            }
        }
        resizePriceLabelFrame(priceText)
    }
    
    func setMenuNameLabel(name: String) {
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
    
    func setDistanceLabel(distance: Float) {
        var formatter : String = String(format: "%.01f km", distance)
        self.distantLabel.text = formatter
    }
    
    func getDistanceLabel() ->String? {
        return self.distantLabel.text
    }
    
    func setPointLabel(point: Int) {
        var formatter : String = String(format: "%d yums", point)
        self.pointLabel.text = formatter
    }
    
    func getPointLabel() ->String? {
        return self.pointLabel.text
    }
    
    func setImageByName(imgName: String) {
        self.menuImageView.image = UIImage(named: imgName)
        //self.menuImageView.layer.borderColor = UIColorFromRGB(0x34495e).CGColor
        //self.menuImageView.layer.borderWidth = 0.5
    }
    
    func setMenuCell(inMenuName: String, storeName: String, imgName:String, distanceVal:Float, pointVal: Int, price:Float) {
        self.setMenuNameLabel(inMenuName)
        self.setStoreNameLabel(storeName)
        self.setImageByName(imgName)
        self.setPriceLabel(price)
        self.setDistanceLabel(distanceVal)
        self.setPointLabel(pointVal)
    }
}
