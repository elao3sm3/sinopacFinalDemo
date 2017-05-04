//
//  loveOrNotResturantInformation.swift
//  sinopacFinalDemo
//
//  Created by 品軒 on 2017/4/24.
//  Copyright © 2017年 品軒. All rights reserved.
//

import UIKit

class loveOrNotResturantInformation: UIViewController {

    var db : SQLiteConnect?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("loveOrNotResturantInformation")
        
        //MARK: - 啟動資料庫
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let sqlitePath = urls[urls.count-1].absoluteString+"CardDb.sqlite3"
        
        db = SQLiteConnect(path : sqlitePath)

        if let mydb = db{
            
            let statement = mydb.fetch(tableName: "ResturantInformation", cond: nil, order: nil)
            
            if sqlite3_step(statement) == SQLITE_ROW{
                if let count = sqlite3_column_text(statement, 0){
                    var a:String? = String(cString: count)
                    print(a)
                    
                }
                if let id = sqlite3_column_text(statement, 1){
                    var a:String? = String(cString: id)
                    
                }
                if let name = sqlite3_column_text(statement, 2){
                    var a:String? = String(cString: name)
                    
                }
                if let address = sqlite3_column_text(statement, 3){
                    var a:String? = String(cString: address)
                    
                }
                if let phone = sqlite3_column_text(statement, 4){
                    var a:String? = String(cString: phone)
                    
                }
                if let latitude = sqlite3_column_text(statement, 5){
                    var a:String? = String(cString: latitude)
                    
                }
                if let longtitude = sqlite3_column_text(statement, 6){
                    var a:String? = String(cString: longtitude)
                    
                }
                if let price = sqlite3_column_text(statement, 7){
                    var a:String? = String(cString: price)
                    
                }
                if let open = sqlite3_column_text(statement, 8){
                    var a:String? = String(cString: open)
                    
                }
                if let close = sqlite3_column_text(statement, 9){
                    var a:String? = String(cString: close)
                    
                }
                if let photo = sqlite3_column_text(statement, 10){
                    var a:String? = String(cString: photo)
                    
                }
                if let style = sqlite3_column_text(statement, 11){
                    var a:String? = String(cString: style)
                    
                }
                if let preference = sqlite3_column_text(statement, 12){
                    var a:String? = String(cString: preference)
                    
                }
            }else{
                
            }
            sqlite3_finalize(statement)
        }
    }
    func goBackToloveOrNotResturantDetail(){
        self.navigationController?.popViewController(animated: true)
    }
}
