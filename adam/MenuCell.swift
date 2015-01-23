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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
    
    func setImageByName(imgName: String) {
        self.menuImageView.image = UIImage(named: imgName)
    }
    
    func setMenuCell(inMenuName: String, storeName: String, imgName:String) {
        self.setMenuNameLabel(inMenuName)
        self.setStoreNameLabel(storeName)
        self.setImageByName(imgName)
    }
}
