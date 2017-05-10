//
//  loveOrNotVCTableViewCell.swift
//  sinopacFinalDemo
//
//  Created by 品軒 on 2017/5/10.
//  Copyright © 2017年 品軒. All rights reserved.
//

import UIKit

class loveOrNotVCTableViewCell: UITableViewCell {

    @IBOutlet weak var loveOrNotVCTableViewCellImage: UIImageView!
    @IBOutlet weak var loveOrNotVCTableViewCellLabel: UILabel!
    @IBOutlet weak var loveOrNotVCTableViewCellSubLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
