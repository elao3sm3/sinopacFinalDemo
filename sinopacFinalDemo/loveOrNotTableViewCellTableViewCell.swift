//
//  loveOrNotTableViewCellTableViewCell.swift
//  sinopacFinalDemo
//
//  Created by 品軒 on 2017/3/29.
//  Copyright © 2017年 品軒. All rights reserved.
//

import UIKit

class loveOrNotTableViewCellTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var detail: UIButton!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
