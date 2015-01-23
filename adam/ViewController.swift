//
//  ViewController.swift
//  adam
//
//  Created by Kittikorn Ariyasuk on 1/11/15.
//  Copyright (c) 2015 Benri. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var menuTableView: UITableView!

    
    var menuArray:[Menu] = [Menu]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupMenu()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupMenu()
    {
        var menu1 = Menu(menuName: "幕の内弁当", storeName: "六本木駅弁", imgName: "幕の内弁当.jpg")
        var menu2 = Menu(menuName: "ビ弁当", storeName: "六本木一丁目駅弁", imgName: "ビ弁当.jpg")
        var menu3 = Menu(menuName: "幕の内弁当", storeName: "六本木駅弁", imgName: "幕の内弁当.jpg")
        var menu4 = Menu(menuName: "ビ弁当", storeName: "六本木一丁目駅弁", imgName: "ビ弁当.jpg")
        
        menuArray.append(menu1)
        menuArray.append(menu2)
        menuArray.append(menu3)
        menuArray.append(menu4)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: MenuCell = tableView.dequeueReusableCellWithIdentifier("menuCell") as MenuCell
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 255, green: 255, blue: 50, alpha: 1.0)
        }
        else {
           // cell.backgroundColor = UIColor.greenColor()
        }
        
        let menu = menuArray[indexPath.row]
        
        cell.setMenuCell(menu.menuName, storeName: menu.storeName, imgName: menu.imgName)
        
        return cell
    }
}

