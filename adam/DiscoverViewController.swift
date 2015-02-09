//
//  DiscoverViewController.swift
//  adam
//
//  Created by Kittikorn Ariyasuk on 2/7/15.
//  Copyright (c) 2015 Benri. All rights reserved.
//

import Foundation
import UIKit

class DiscoverViewConroller : UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var swipeView: UIView!
    
    @IBOutlet var panGestureHandle: [UIButton]!
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        recognizer.view!.center = CGPoint(x:recognizer.view!.center.x + translation.x,
            y:recognizer.view!.center.y + translation.y)
        recognizer.setTranslation(CGPointZero, inView: self.view)
        println("GOGOGOGOGO")
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        println("Hi there")
       // var swipeGesture: UIGestureRecognizer = UIGestureRecognizer(target: self.view, action: <#Selector#>)
        //UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToDoMethod)];
        //[swipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
        //[[self innerView] addGestureRecognizer: swipeGesture];
        var panGestureRecognizer: UIPanGestureRecognizer = 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    
}