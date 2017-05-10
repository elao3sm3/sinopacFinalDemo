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
    var dataArray: [String] = []
    
    @IBOutlet weak var rMDetailInformationTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        }

        rMDetailInformationTableView.dataSource = self
        rMDetailInformationTableView.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func addToDairyRecord(){
        
    }
}
extension rMDetailInformation: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
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
                    labelValue.text = "\(dataArray[5])"
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
            labelKey.text = ""
            labelValue.text = ""
        }
        
        return cell
    }
}
extension rMDetailInformation: UITableViewDelegate{
    
}
