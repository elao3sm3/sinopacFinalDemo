//
//  dRDayListVC.swift
//  sinopacFinalDemo
//
//  Created by 品軒 on 2017/3/22.
//  Copyright © 2017年 品軒. All rights reserved.
//

import UIKit

class dRDayListVC: UIViewController {

    var tableViewSection : [String] = ["2017/3/22","2017/3/23","2017/3/24"]
    var dataArray : [String] = ["早餐","午餐","晚餐","宵夜"]
    
    @IBOutlet weak var dRDayListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem?.title = "返回"
        navigationItem.title = "美食總覽"
        
        dRDayListTableView.dataSource = self
        dRDayListTableView.delegate = self
        
    }
}
extension dRDayListVC : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewSection.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableViewSection[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dRDayListTableViewCell", for: indexPath)
        
//        cell.layer.shadowOffset = CGSize.init(width: 5, height: 5)
//        cell.layer.shadowOpacity = 0.7
//        cell.layer.shadowRadius = 5
//        cell.layer.shadowColor = UIColor(red:44.0/255.0,green:62.0/255.0,blue:80.0/255.0,alpha:1.0).cgColor
        cell.layer.borderColor = UIColor.orange.cgColor
        cell.layer.borderWidth = 1
        
        cell.textLabel?.text = "\(dataArray[indexPath.row])"
        cell.textLabel?.backgroundColor = UIColor.orange
        
        return cell
    }
}
extension dRDayListVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let pushTodRDayDetail = storyboard?.instantiateViewController(withIdentifier: "dRDayDetailVC")) as! dRDayDetailVC
        
        
    }
}
