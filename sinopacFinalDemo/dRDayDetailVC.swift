//
//  dRDayDetailVC.swift
//  sinopacFinalDemo
//
//  Created by 品軒 on 2017/3/22.
//  Copyright © 2017年 品軒. All rights reserved.
//

import UIKit

class dRDayDetailVC: UIViewController {

    var dataArray : [String] = ["餐廳","午餐","日期","評價","評論"]
    
    @IBOutlet weak var dRDayDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dRDayDetailTableView.dataSource = self
        dRDayDetailTableView.delegate = self
        
        let dRNavigationRightButton = UIBarButtonItem(title : "總覽",style : .plain,target : self, action : #selector(navigationPushTodRDayListVC))
        self.navigationItem.rightBarButtonItem = dRNavigationRightButton
        
        
        
    }

    func navigationPushTodRDayListVC(){
        let pushTodRDayListVC = storyboard?.instantiateViewController(withIdentifier: "dRDayListVC") as! dRDayListVC
        
        self.navigationController?.pushViewController(pushTodRDayListVC, animated: true)
    }
}
extension dRDayDetailVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dRDayDetailTableViewCell", for: indexPath)
        
        let label = UILabel(frame : .null)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(dataArray[indexPath.row])"
        
        cell.contentView.addSubview(label)
        
        cell.layer.masksToBounds = true
        
        let views = ["label":label]
        cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[label(100)]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
        cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-11-[label(20)]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
        
        
        return cell
    }
}
extension dRDayDetailVC : UITableViewDelegate{
    
}
