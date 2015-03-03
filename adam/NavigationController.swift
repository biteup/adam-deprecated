//
//  NavigationController.swift
//  adam
//
//  Created by Kittikorn Ariyasuk on 3/1/15.
//  Copyright (c) 2015 Benri. All rights reserved.
//

import Foundation

class NavigationController: UINavigationController, UIViewControllerTransitioningDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barStyle = UIBarStyle.Default
        self.navigationBar.setNeedsUpdateConstraints()
        // Status bar white font
        //self.navigationBar.tintColor = UIColor.whiteColor()
    }
}