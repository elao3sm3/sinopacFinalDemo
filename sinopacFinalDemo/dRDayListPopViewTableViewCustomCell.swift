//
//  dRDayListPopViewTableViewCustomCell.swift
//  sinopacFinalDemo
//
//  Created by 品軒 on 2017/3/29.
//  Copyright © 2017年 品軒. All rights reserved.
//

import UIKit

class dRDayListPopViewTableViewCustomCell: UITableViewCell {

    @IBOutlet weak var tableViewCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewHeight : NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableViewCollectionView.dataSource = self
        tableViewCollectionView.delegate = self
        
        self.tableViewCollectionView.register(UINib(nibName: "dRDayListPopViewTableViewCollectionCustomCell", bundle: nil), forCellWithReuseIdentifier: "collectionViewCustomCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func reloadData() {
        
        self.tableViewCollectionView.reloadData()
        
        let contentSize = self.tableViewCollectionView.collectionViewLayout.collectionViewContentSize
        collectionViewHeight.constant = contentSize.height
    }
    
}
extension dRDayListPopViewTableViewCustomCell : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCustomCell", for: indexPath) as! dRDayListPopViewTableViewCollectionCustomCell
        
        cell.collectionViewCustomButton.setTitle("\(indexPath.row)", for: .normal)
        
        return cell
    }
}
extension dRDayListPopViewTableViewCustomCell : UICollectionViewDelegate{
    
}
