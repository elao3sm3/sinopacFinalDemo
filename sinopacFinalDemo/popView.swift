//
//  popView.swift
//  sinopacFinalDemo
//
//  Created by 品軒 on 2017/3/27.
//  Copyright © 2017年 品軒. All rights reserved.
//

import UIKit

class popView: UIViewController {

    @IBOutlet weak var popViewTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popViewTableView.dataSource = self
        popViewTableView.delegate = self
        
        self.popViewTableView.register(UINib(nibName: "dRDayListPopViewTableViewCustomCell", bundle: nil), forCellReuseIdentifier: "tableViewCell")
        
    }

}
extension popView : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 75
        }else{
            return 225
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! dRDayListPopViewTableViewCustomCell
        
        cell.frame = tableView.bounds
        cell.layoutIfNeeded()
        
        return cell
    }
}

extension popView : UITableViewDelegate{
    
    
}
