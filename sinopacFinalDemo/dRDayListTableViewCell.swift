//
//  dRDayListTableViewCell.swift
//  sinopacFinalDemo
//
//  Created by 品軒 on 2017/3/28.
//  Copyright © 2017年 品軒. All rights reserved.
//

import UIKit

class dRDayListTableViewCell: UITableViewCell {

    @IBOutlet weak var tableViewView: UIView!
    @IBOutlet weak var tableViewImage: UIImageView!
    @IBOutlet weak var tableViewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tableViewView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
