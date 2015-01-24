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
    
    func resizePriceLabelFrame(price: Int){
        //Calculate the expected size based on the font and linebreak mode of your label
        // FLT_MAX here simply means no constraint in height
        var maximumLabelSize: CGSize = CGSizeMake(320, 50)
        var abc: String = "¥ "
        abc = abc + String(price)
        let priceText: NSString = abc as NSString
        let expectedLabelSize: CGSize = priceText.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(17.0)])
        println(expectedLabelSize)
        
        
        //CGSize expectedLabelSize =
    
        //CGSize expectedLabelSize = [yourString sizeWithFont:yourLabel.font constrainedToSize:maximumLabelSize lineBreakMode:yourLabel.lineBreakMode];
    
        //adjust the label the the new height.
        //CGRect newFrame = yourLabel.frame
        //newFrame.size.height = expectedLabelSize.height
        //yourLabel.frame = newFrame
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
    
    func setMenuCell(inMenuName: String, storeName: String, imgName:String, distanceVal:Float, pointVal: Int) {
        self.setMenuNameLabel(inMenuName)
        self.setStoreNameLabel(storeName)
        self.setImageByName(imgName)
        self.resizePriceLabelFrame(1000)
        self.setDistanceLabel(distanceVal)
        self.setPointLabel(pointVal)
    }
}
