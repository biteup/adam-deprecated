//
//  DiscoverView.swift
//  adam
//
//  Created by Kittikorn Ariyasuk on 2/7/15.
//  Copyright (c) 2015 Benri. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class DiscoverView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var myPickerView: UIPickerView!
    

    @IBOutlet weak var swipeLocationButton: UIButton!

    var pickerData:[String] = ["Surprised ME ME ME ME ME ME ME ME ME ME ME ME !"]
    var const:Const         = Const.sharedInstance
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.locationInit()
        self.addBlurEffect()
        
        let svapi:TagSVAPI = TagSVAPI()
        svapi.getTags(10,
            {(somejson)-> Void in
                if let json: AnyObject = somejson {
                    let myJSON = JSON(json)
                    for (index: String, itemJSON: JSON) in myJSON["items"] {
                        let tag:JSON = itemJSON[0]
                        self.pickerData.append(tag.stringValue)
                    }
                    self.pickerViewInit()
                    
                }
            },
            { () -> Void in
            
            })
    }
    
    func addBlurEffect() {
        let blurEffect:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        let bluredEffectView = UIVisualEffectView(effect: blurEffect)
        let screenFrame = UIScreen.mainScreen().bounds
        
        bluredEffectView.frame = screenFrame
        self.insertSubview(bluredEffectView, atIndex: 1)
        
        
        let vibrancyEffect:UIVibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
        let vibrancyEffectView:UIVisualEffectView = UIVisualEffectView(effect: vibrancyEffect)
        
        vibrancyEffectView.frame = CGRect(x: 0, y: 400, width: screenFrame.width, height: 80)//bluredEffectView.frame
        println(vibrancyEffectView.frame)
        //CGRect(x: 0, y: 400, width: screenFrame.width, height: 40)
        
        // Add Label to Vibrancy View
        var swipeLabel:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenFrame.width, height: 30))
        swipeLabel.textAlignment = NSTextAlignment.Center
        swipeLabel.font = UIFont(name: swipeLabel.font.description, size: 20)
        swipeLabel.text = "HIHIHIHIHIHIHI"
        println(swipeLabel.frame.origin)
        
        vibrancyEffectView.contentView.addSubview(swipeLabel)
        
        // Add Vibrancy View to Blur View
        bluredEffectView.contentView.insertSubview(vibrancyEffectView, atIndex: 1)
        
        //self.insertSubview(bluredEffectView, aboveSubview: self)
        //self.addSubview(bluredEffectView)
    }
    
    func pickerViewInit() {
        let screenRect:CGRect = UIScreen.mainScreen().bounds
        let screenWidth:CGFloat = screenRect.size.width
        
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        self.myPickerView.showsSelectionIndicator = false
        self.myPickerView.hidden = false
        
        self.myPickerView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        self.myPickerView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
        self.myPickerView.frame = CGRectMake(147.0, 40, 26.0, 216.0);
        self.myPickerView.alpha = 1.0
        //println(pickerView.bounds.size)
        
        var t0:CGAffineTransform = CGAffineTransformMakeTranslation (0, self.myPickerView.bounds.size.height/2);
        var s0:CGAffineTransform = CGAffineTransformMakeScale(1.481, 1.481);
        var t1:CGAffineTransform = CGAffineTransformMakeTranslation (0, -self.myPickerView.bounds.size.height/2);
        
        self.myPickerView.transform = CGAffineTransformConcat(t0, CGAffineTransformConcat(s0, t1));
        self.myPickerView.transform = CGAffineTransformRotate(self.myPickerView.transform, CGFloat(-M_PI/2))
        
        self.myPickerView.reloadAllComponents()
        
        UIView.animateWithDuration(1.4, animations: {
                self.myPickerView.alpha = 1.0
            },
            completion: {
                (value:Bool) in
                self.myPickerView.selectRow(1, inComponent: 0, animated: true)
                self.const.setConst("search", key: "tag", value: self.pickerData[1])
        })
    
    }
    
    func locationInit(){
        if let locality = const.getConst("location", key: "locality") {
            let locationString = " > " + locality
            swipeLocationButton.setTitle(locationString, forState: UIControlState.Normal)
            swipeLocationButton.setTitle(locationString, forState: UIControlState.Selected)
        }
    }
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView,
        rowHeightForComponent component: Int) -> CGFloat{
        return 216.0
    }
    
    func pickerView(pickerView: UIPickerView,
        viewForRow row: Int,
        forComponent component: Int,
        reusingView view: UIView!) -> UIView{
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            let labelWidth:CGFloat = screenSize.width * 0.65
            let labelHeight:CGFloat = 216.0
            
            
            var rect:CGRect = CGRectMake(0, 0, labelWidth, labelHeight)
            var label:UILabel = UILabel(frame: rect)
            label.text = pickerData[row]
            label.adjustsFontSizeToFitWidth = true
            label.opaque = false
            label.textAlignment = NSTextAlignment.Center
            label.textColor = UIColor.whiteColor()//UIColor(red: (255/255.0), green: (118/255.0), blue: (25/255.0), alpha: 1.0)
            label.clipsToBounds = false
            label.transform = CGAffineTransformRotate(label.transform, CGFloat(M_PI/2))
            return label
    }
    
    func pickerView(pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int){
            const.setConst("search", key: "tag", value: pickerData[row])
    
    }
    
    
}