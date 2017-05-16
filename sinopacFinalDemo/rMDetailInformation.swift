//
//  rMDetailInformation.swift
//  sinopacFinalDemo
//
//  Created by 品軒 on 2017/5/8.
//  Copyright © 2017年 品軒. All rights reserved.
//

import UIKit

class rMDetailInformation: UIViewController {

    var db : SQLiteConnect?
    
    var getValueFromUpperView: String?
    var getArrayValueFromUpperView: [String]?
    var getListValueFromUpperView: [String]? = ["","","","","","","","",""]
    var dataArray: [String] = []
    
    var checkRestaurantName: [String] = []
    
    var RI_tableID: [Int] = []
    
    @IBOutlet weak var rMDetailInformationTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("rMDetailInformation")
        
        //MARK: - NavigationSettig
        self.navigationItem.title = (self.getValueFromUpperView!)
        
        var addInToDairyRecord = UIBarButtonItem(title: "加進日誌", style: .plain, target: self, action: #selector(addToDairyRecord))
        navigationItem.rightBarButtonItem = addInToDairyRecord
        
        //MARK: - 啟動資料庫
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let sqlitePath = urls[urls.count-1].absoluteString+"CardDb.sqlite3"
        
        db = SQLiteConnect(path : sqlitePath)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let mydb = db{
            
            let statement = mydb.fetch(tableName: "ResturantGet", cond: "RG_name = '\(self.getValueFromUpperView!)'", order: nil)
            
            if sqlite3_step(statement) == SQLITE_ROW{
                if let address = sqlite3_column_text(statement, 3){
                    let a = String(cString: address)
                    dataArray.append(a)
                }
                if let phone = sqlite3_column_text(statement, 4){
                    let a = String(cString: phone)
                    dataArray.append(a)
                }
                if let price = sqlite3_column_text(statement, 7){
                    let a = String(cString: price)
                    dataArray.append(a)
                }
                if let open = sqlite3_column_text(statement, 8){
                    let a = String(cString: open)
                    dataArray.append(a)
                }
                if let close = sqlite3_column_text(statement, 9){
                    let a = String(cString: close)
                    dataArray.append(a)
                }
                if let style = sqlite3_column_text(statement, 11){
                    let a = String(cString: style)
                    dataArray.append(a)
                }
            }
            
            sqlite3_finalize(statement)
            
            let statement2 = mydb.fetch(tableName: "DiaryRecord", cond: nil, order: nil)
            while sqlite3_step(statement2) == SQLITE_ROW{
                if let tableID = sqlite3_column_text(statement2, 0){
                    var a: String? = String(cString: tableID)
                    
                    self.RI_tableID.append((Int)(a!)!)
                }else{
                    self.RI_tableID = []
                }
            }
            sqlite3_finalize(statement2)
            
            let statement3 = mydb.fetch(tableName: "ResturantInformation", cond: nil, order: nil)
            while sqlite3_step(statement3) == SQLITE_ROW{
                if let restaurantName = sqlite3_column_text(statement3, 2){
                    var a: String? = String(cString: restaurantName)
                    
                    self.checkRestaurantName.append((a!))
                }else{
                    self.checkRestaurantName = []
                }
            }
            sqlite3_finalize(statement3)
        }

        rMDetailInformationTableView.dataSource = self
        rMDetailInformationTableView.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func addToDairyRecord(){
        
        let a = checkRestaurantName.filter{ $0 == self.getValueFromUpperView! }
        if !a.isEmpty{
            print(a)
        }
        var tableID = self.RI_tableID.count
        
        let now = Date()
        
        if let mydb = self.db{
            mydb.insert(tableName: "ResturantInformation", rowInfo: ["RI_tableID":"'\(String(tableID))'","RI_id":"'\(self.getListValueFromUpperView![0])'","RI_name":"'\(self.getValueFromUpperView!)'","RI_address":"'\(dataArray[0])'","RI_phone":"'\(dataArray[1])'","RI_latitude":"'\(self.getListValueFromUpperView![1])'","RI_longitude":"'\(self.getListValueFromUpperView![2])'","RI_price":"'\(dataArray[2])'","RI_opentime":"'\(dataArray[3])'","RI_closetime":"'\(dataArray[4])'","RI_photo":"'\(self.getListValueFromUpperView![3])'","RI_style":"'\(self.getListValueFromUpperView![4]) \(self.getListValueFromUpperView![5]) \(self.getListValueFromUpperView![6]) \(self.getListValueFromUpperView![7]) \(self.getListValueFromUpperView![8])'","RI_preference":"'like'"])
            
            mydb.insert(tableName: "DiaryRecord", rowInfo: ["DR_tableID":"'\(String(tableID))'","DR_name":"'\(self.getValueFromUpperView!)'","DR_photo":"'\(self.getListValueFromUpperView![3])'","DR_style":"'\(self.getListValueFromUpperView![4]) \(self.getListValueFromUpperView![5]) \(self.getListValueFromUpperView![6]) \(self.getListValueFromUpperView![7]) \(self.getListValueFromUpperView![8])'","DR_price":"'\(dataArray[2])'","DR_date":"'\(now)'"])
            
            mydb.insert(tableName: "ResturantPicture", rowInfo: ["RP_tableID":"'\(String(tableID))'","RP_resturantName":"'\(self.getValueFromUpperView!)'"])
        }

        self.navigationController?.popViewController(animated: true)
    }
}
extension rMDetailInformation: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1{
            
            return self.getArrayValueFromUpperView!.count
        }else{
        
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1{
           return "評論"
        }
        return "基本資料"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4{
            return 99
        }
        return 66
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rMDetailInformationTableViewCell", for: indexPath) as! UITableViewCell
        
        let labelKey = cell.viewWithTag(1) as! UILabel
        let labelValue = cell.viewWithTag(2) as! UILabel
        
        let section = indexPath.section
        
        if section == 0{
            switch indexPath.row {
                case 0:
                    labelKey.text = "類別"
                    labelValue.text = "\(self.getListValueFromUpperView![4]) \(self.getListValueFromUpperView![5]) \(self.getListValueFromUpperView![6]) \(self.getListValueFromUpperView![7]) \(self.getListValueFromUpperView![8])"
                case 1:
                    labelKey.text = "價格"
                    labelValue.text = "\(dataArray[2])"
                case 2:
                    labelKey.text = "時間"
                    labelValue.text = "\(dataArray[3])~\(dataArray[4])"
                case 3:
                    labelKey.text = "電話"
                    labelValue.text = "\(dataArray[1])"
                default:
                    labelKey.text = "地址"
                    labelValue.numberOfLines = 2
                    labelValue.text = "\(dataArray[0])"
            }
        }else{
            labelKey.text = "\(indexPath.row + 1)."
            labelValue.text = "\(self.getArrayValueFromUpperView![indexPath.row])"
        }
        
        return cell
    }
}
extension rMDetailInformation: UITableViewDelegate{
    
}
