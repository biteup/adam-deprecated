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

class DiscoverView: UIView {

    @IBOutlet weak var myPickerView: UIPickerView!
    
    var pickerData:[String] = ["Surprised ME!"]
    var const:Const         = Const.sharedInstance
    var horizonPicker:HorizontalPicker
    
    required init(coder aDecoder: NSCoder) {
        self.horizonPicker = HorizontalPicker(pickerData: self.pickerData)
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.locationInit()
        self.addBlurEffect()
        
        let svapi:TagSVAPI = TagSVAPI()
        /*
        UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        activityView.center=self.view.center;
        
        [activityView startAnimating];
        
        [self.view addSubview:activityView];*/
        
        var activityView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityView.center = self.center
        activityView.startAnimating()
        self.addSubview(activityView)
        svapi.getTags(10,
            {(somejson)-> Void in
                if let json: AnyObject = somejson {
                    let myJSON = JSON(json)
                    for (index: String, itemJSON: JSON) in myJSON["items"] {
                        let tag:JSON = itemJSON[0]
                        self.pickerData.append(tag.stringValue)
                    }
                    self.horizonPicker.pickerData = self.pickerData
                    self.addSubview(self.horizonPicker.myUIPickerView)
                    self.horizonPicker.createHorizontalPicker()
                    //activityView.stopAnimating()
                    
                }
            },
            { () -> Void in
            
            })
    }
    
    func addBlurEffect() {
        self.backgroundColor = UIColor.clearColor()
        let blurEffect:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let bluredEffectView = UIVisualEffectView(effect: blurEffect)
        let screenFrame = UIScreen.mainScreen().bounds
        
        bluredEffectView.frame = screenFrame
        self.insertSubview(bluredEffectView, atIndex: 1)
        
        
        let vibrancyEffect:UIVibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
        
        let vibrancyEffectView:UIVisualEffectView = UIVisualEffectView(effect: vibrancyEffect)
        
        let swipeLabelPostion = CGPoint(x: 0, y: screenFrame.height - 88)
        
        vibrancyEffectView.frame = CGRect(x: 0, y: 0, width: screenFrame.width, height: screenFrame.height)
        vibrancyEffectView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // Add Label to Vibrancy View
        
        let button   = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        button.frame = CGRectMake(swipeLabelPostion.x, swipeLabelPostion.y, screenFrame.width, 88)
        button.backgroundColor = UIColor.clearColor()
        button.setTitle("Search for Your Selection", forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 22)

        
        
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)

        
        var swipeLabel:UILabel = UILabel(frame: CGRect(x: swipeLabelPostion.x, y: swipeLabelPostion.y, width: screenFrame.width, height: 88))
       // swipeLabel.textAlignment = NSTextAlignment.Center
       // swipeLabel.font = UIFont(name: swipeLabel.font.description, size: 34)
       // swipeLabel.text = "Search for Your Selection"
        
        vibrancyEffectView.contentView.addSubview(swipeLabel)
        vibrancyEffectView.contentView.addSubview(button)
        // Add Vibrancy View to Blur View
        bluredEffectView.contentView.insertSubview(vibrancyEffectView, atIndex: 1)
        
        //self.insertSubview(bluredEffectView, aboveSubview: self)
        //self.addSubview(bluredEffectView)
    }
    
    func buttonAction(sender:UIButton!)
    {
        println("Button tapped")
    }
    
    
    func locationInit(){
        if let locality = const.getConst("location", key: "locality") {
            let locationString = " > " + locality
           // swipeLocationButton.setTitle(locationString, forState: UIControlState.Normal)
           // swipeLocationButton.setTitle(locationString, forState: UIControlState.Selected)
        }
    }

    
    
}