//
//  loveOrNotTableViewResturantCell.swift
//  sinopacFinalDemo
//
//  Created by 品軒 on 2017/4/12.
//  Copyright © 2017年 品軒. All rights reserved.
//

import UIKit

class loveOrNotTableViewResturantCell: UITableViewCell {

    @IBOutlet weak var tableViewResturantCellResturantNameLabel: UILabel!
    @IBOutlet weak var tableViewResturantCellTimeLabel: UILabel!
    @IBOutlet weak var tableViewResturantCellPriceLabel: UILabel!
    @IBOutlet weak var tableViewResturantCellAddressLabel: UILabel!
    
    @IBOutlet weak var tableViewResturantCellDetailButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
