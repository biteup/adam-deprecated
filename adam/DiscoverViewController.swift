//
//  DiscoverViewController.swift
//  adam
//
//  Created by Kittikorn Ariyasuk on 2/7/15.
//  Copyright (c) 2015 Benri. All rights reserved.
//

import Foundation
import UIKit

class DiscoverViewConroller : UIViewController {
    
    @IBOutlet var myView: DiscoverView!
    @IBOutlet weak var myPickerView: UIPickerView!
    
    @IBOutlet weak var swipeButton: UIButton!
    @IBAction func onClickCancel(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(discoverNotificationKey, object: self)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    let startPosition:CGPoint = CGPoint(x: 0, y: 1000)
    let targetPosition:CGPoint = CGPoint(x: 0, y: 19)
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.myView.frame.origin = self.startPosition
        
        UIView.animateWithDuration(0.5, animations: {
            self.myView.frame.origin = self.targetPosition
            }
        )
        self.settingSwipeToSearchGesture()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func slideToRightWithGestureRecognizer() {
        NSNotificationCenter.defaultCenter().postNotificationName(discoverNotificationKey, object: self)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    func settingSwipeToSearchGesture() {
        var swipeRightSearch: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "slideToRightWithGestureRecognizer")
        swipeRightSearch.direction = UISwipeGestureRecognizerDirection.Right
        self.swipeButton.addGestureRecognizer(swipeRightSearch)

    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}