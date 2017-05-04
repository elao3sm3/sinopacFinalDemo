//
//  TestUrl.swift
//  sinopacFinalDemo
//
//  Created by 品軒 on 2017/4/11.
//  Copyright © 2017年 品軒. All rights reserved.
//

import UIKit

class TestUrl: UIViewController {
    
    var db: SQLiteConnect?

    var dataArray = [AnyObject]()
    @IBOutlet weak var tableview: UITableView!
    var testArray: [String]?
    
    var restaurantName: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("TestUrl")
        
        // MARK: - URL
        let url = NSURL(string: "http://10.11.24.95/eatwhat/api/select_store")
        //let url = NSURL(string: "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=a3e2b221-75e0-45c1-8f97-75acbd43d613")
        
        let sessionWithConfigure = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: OperationQueue.main)
        
        let Task = session.downloadTask(with: url! as URL)
        
        //Task.resume()
        
        // MARK: - 開啟資料庫
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let sqlitePath = urls[urls.count-1].absoluteString+"CardDb.sqlite3"
        
        db = SQLiteConnect(path : sqlitePath)
        
        // MARK: - post 取得店家名稱
        
    }

    override func viewWillAppear(_ animated: Bool) {
        /*if let mydb = self.db{
            let statement = mydb.fetch(tableName: "RestaurantName", cond: nil, order: nil)
            while sqlite3_step(statement) == SQLITE_ROW{
                if let restaurantName = sqlite3_column_text(statement, 0){
                    print("123")
                    var name: String = String(cString: restaurantName)
                    print(name)
                    self.testArray?.append("\(name)")
                }
            }
            sqlite3_finalize(statement)
        }
        
        print((self.testArray!.count))*/
        
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    @IBAction func postData(_ sender: UIButton) {
       // hud.start
        var url = URL(string: "http://10.11.24.95/eatwhat/api/getgps_name")
        
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let postString = ["S_latitude": "25.049481","S__longitude": "121.580030"]
        
        let postdata = try!JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        
        request.httpBody = postdata
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            guard let data = data, error == nil else{
                print("error = \(error)")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{
                print("error")
                print("error")
            }
            let json = try?JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
           // if let result = json[]
            print(json!)
            
            print(((json![0]["S_name"])!)!)
            
            for i in 0...((json!.count) - 1){
                
                let name = ((json![i]["S_name"])!)! as! String
                
                self.restaurantName.append(name)
            }
            
            print(self.restaurantName.count)
            
            print(self.restaurantName)
            
            let responseString = String(data: data,encoding: .utf8)
            print("responseString = \(responseString!)")
            
            //hud.stop
            
        }
        task.resume()
    }
}
extension TestUrl: URLSessionDelegate{
    
}
extension TestUrl: URLSessionDownloadDelegate{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            print("1")
            //[AnyObject]
            
            let dataDic = try JSONSerialization.jsonObject(with: NSData(contentsOf: location) as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]//[String:[String:AnyObject]]
            
            print("2")
            print(dataDic)
            print("3")
            
            tableview.reloadData()
            
        } catch {
            print("Error!")
        }
    }
}

extension TestUrl: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5//(testArray?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath)
        
        print("3")
        
        cell.textLabel?.text = "123"//(testArray?[indexPath.row])!//dataArray[indexPath.row]["S_address"] as? String
        
        
        
        return cell
    }
}
extension TestUrl: UITableViewDelegate{
    
}
