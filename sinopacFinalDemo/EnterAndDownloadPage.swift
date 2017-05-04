//
//  EnterAndDownloadPage.swift
//  sinopacFinalDemo
//
//  Created by 品軒 on 2017/4/26.
//  Copyright © 2017年 品軒. All rights reserved.
//

import UIKit

class EnterAndDownloadPage: UIViewController {

    var db: SQLiteConnect?
    
    var activityIndicator: UIActivityIndicatorView!
    var restaurantName: [AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("EnterAndDownloadPage")
        
        // MARK: - 開啟資料庫
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let sqlitePath = urls[urls.count-1].absoluteString+"CardDb.sqlite3"
        
        db = SQLiteConnect(path : sqlitePath)
       
        // MARK: - 設定環形進度條
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        /*let queue = DispatchQueue(label: "com.EnterAndDownloadPage.dowwnload")
        queue.sync {
             startDownloadRestaurantName()
        }*/
      startDownloadRestaurantName()
        self.performSegue(withIdentifier: "goToTabbarVC", sender: nil)
    }
    
    func startDownloadRestaurantName(){
        
        self.activityIndicator.startAnimating()
        
        let url = NSURL(string: "http://10.11.24.95/eatwhat/api/selectall")
        
        let sessionWithConfigure = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: OperationQueue.main)
        
        let dataTask = session.downloadTask(with: url! as URL)
        
        dataTask.resume()

        self.activityIndicator.stopAnimating()
        
    }
}
// MARK: - URLSessionDownloadDelegate
extension EnterAndDownloadPage: URLSessionDownloadDelegate{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
            
        do{
            let dataDic = try JSONSerialization.jsonObject(with: NSData(contentsOf: location)! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
            
            self.restaurantName = dataDic
            print(((self.restaurantName![0]["S_name"])!)!)
            print(((self.restaurantName![0]["P_photes"])!)!)
            print(self.restaurantName!)
            
//            var photo: [String] = ((self.restaurantName![0]["P_photes"])!)! as! [String]
//            print("******")
//            print(photo)
//            print(photo[0])
            
            if let mydb = db{
               /* for i in 0...(self.restaurantName?.count)!-1{
                    mydb.insert(tableName: "RestaurantGet", rowInfo: ["RN_restaurantName":"'\((((self.restaurantName?[i]["S_name"])!)!)!)'"])
                }*/
                
                for i in 0...(self.restaurantName?.count)!-1{
                    mydb.insert(tableName: "ResturantGet", rowInfo: ["RG_tableID":"'\(i)'","RG_id":"'\(((self.restaurantName?[i]["S_id"])!)!)'","RG_name":"'\(((self.restaurantName?[i]["S_name"])!)!)'","RG_address":"'\(((self.restaurantName?[i]["S_address"])!)!)'","RG_phone":"'\(((self.restaurantName?[i]["S_phone"])!)!)'","RG_latitude":"'\(((self.restaurantName?[i]["S_latitude"])!)!)'","RG_longitude":"'\(((self.restaurantName?[i]["S__longitude"])!)!)'","RG_price":"'\(((self.restaurantName?[i]["S_price"])!)!)'","RG_opentime":"'\(((self.restaurantName?[i]["S_opentime"])!)!)'","RG_closetime":"'\(((self.restaurantName?[i]["S_closetime"])!)!)'"/*,"RG_photo":"'\(((self.restaurantName?[i]["P_photos"])!)!)'"*/,"RG_style":"'\(((self.restaurantName?[i]["T_name"])!)!)'"])

                    let photo: [String] = ((self.restaurantName![0]["P_photes"])!)! as! [String]
                    
                        mydb.insert(tableName: "ResturantTypeAndPictureGet", rowInfo: ["RTPG_tableID":"'\(i)'","RTPG_name":"'\(((self.restaurantName?[i]["S_id"])!)!)'","RTPG_type1":"'nil'","RTPG_type2":"'nil'","RTPG_type3":"'nil'","RTPG_type4":"'nil'","RTPG_type5":"'nil'","RTPG_picture1":"'\(photo[0])'","RTPG_picture2":"'\(photo[0])'","RTPG_picture3":"'\(photo[0])'","RTPG_picture4":"'\(photo[0])'","RTPG_picture5":"'\(photo[0])'","RTPG_picture6":"'\(photo[0])'","RTPG_picture7":"'\(photo[0])'","RTPG_picture8":"'\(photo[0])'","RTPG_picture9":"'\(photo[0])'"])
                    
                    print("ok"+photo[0])
                }
            }
        }catch{
            print("Error!")
        
        }
    }
}
