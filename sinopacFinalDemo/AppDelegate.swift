//
//  AppDelegate.swift
//  sinopacFinalDemo
//
//  Created by 品軒 on 2017/3/22.
//  Copyright © 2017年 品軒. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var db: SQLiteConnect?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // MARK: - GoogleMap 金鑰
        GMSServices.provideAPIKey("AIzaSyAaapsqoMfnQUOCM1B37L_tHL-3eEEgNu8")
        GMSPlacesClient.provideAPIKey("AIzaSyAaapsqoMfnQUOCM1B37L_tHL-3eEEgNu8")
        
        // MARK: - 資料庫路徑
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let sqlitePath = urls[urls.count-1].absoluteString+"CardDb.sqlite3"
        
        db = SQLiteConnect(path : sqlitePath)
        
        db!.createTable(tableName: "countdownTest", columnsInfo: ["randomGoalTime VARCHAR (100) DEFAULT '030000'","selectGoalTime VARCHAR (100)"])
 
        // MARK: - 建立資料表
        db?.createTable(tableName: "ResturantGet", columnsInfo: ["RG_tableID VARCHAR (100)","RG_id VARCHAR (100)","RG_name VARCHAR (100)","RG_address VARCHAR (100)","RG_phone VARCHAR (100)","RG_latitude VARCHAR (100)","RG_longitude VARCHAR (100)","RG_price VARCHAR (100)","RG_opentime VARCHAR (100)","RG_closetime VARCHAR (100)","RG_photo VARCHAR (100)","RG_style VARCHAR (100)"])
        
        db?.createTable(tableName: "ResturantTypeAndPictureGet", columnsInfo: ["RTPG_tableID VARCHAR (100)","RTPG_name VARCHAR (100)","RTPG_type1 VARCHAR (100)","RTPG_type2 VARCHAR (100)","RTPG_type3 VARCHAR (100)","RTPG_type4 VARCHAR (100)","RTPG_type5 VARCHAR (100)","RTPG_picture1 VARCHAR (10000)","RTPG_picture2 VARCHAR (10000)","RTPG_picture3 VARCHAR (10000)","RTPG_picture4 VARCHAR (10000)","RTPG_picture5 VARCHAR (10000)","RTPG_picture6 VARCHAR (10000)","RTPG_picture7 VARCHAR (10000)","RTPG_picture8 VARCHAR (10000)","RTPG_picture9 VARCHAR (10000)",])
        
        db?.createTable(tableName: "RestaurantName", columnsInfo: ["RN_restaurantName VARCHAR (100)"])
        
        db!.createTable(tableName: "GoalTime", columnsInfo: ["GT_goaltime VARCHAR (100)"])
         
        db!.createTable(tableName: "DiaryRecord", columnsInfo: ["DR_tableID VARCHAR (100)","DR_name VARCHAR (100)","DR_photo VARCHAR (100)","DR_style VARCHAR (100)","DR_price VARCHAR (100)","DR_date VARCHAR (100)","DR_meal VARCHAR (100)","DR_preference VARCHAR (100)","DR_comment VARCHAR (100)"])
         
        db!.createTable(tableName: "ResturantPicture", columnsInfo: ["RP_resturantName VARCHAR (100)","RP_picture1 VARCHAR (100000000000000) ","RP_picture2 VARCHAR (100000000000000) ","RP_picture3 VARCHAR (100000000000000) ","RP_picture4 VARCHAR (100000000000000) ","RP_picture5 VARCHAR (100000000000000) ","RP_picture6 VARCHAR (100000000000000) ","RP_picture7 VARCHAR (100000000000000) ","RP_picture8 VARCHAR (100000000000000) ","RP_picture9 VARCHAR (100000000000000) "])
         
        db!.createTable(tableName: "ResturantInformation", columnsInfo: ["RI_tableID VARCHAR (100)","RI_id VARCHAR (100)","RI_name VARCHAR (100)","RI_address VARCHAR (100)","RI_phone VARCHAR (100)","RI_latitude VARCHAR (100)","RI_longitude VARCHAR (100)","RI_price VARCHAR (100)","RI_opentime VARCHAR (100)","RI_closetime VARCHAR (100)","RI_photo VARCHAR (100)","RI_style VARCHAR (100)","RI_preference VARCHAR (100)"])
        
        
        // MARK: - WebAPI GET
        let url = NSURL(string: "http://10.11.24.95/eatwhat/api/selectall")
        
        let sessionWithConfigure = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: OperationQueue.main)
        
        let dataTask = session.downloadTask(with: url! as URL)
        
        //dataTask.resume()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        db?.delete(tableName: "ResturantGet", cond: nil)
        db?.delete(tableName: "ResturantTypeAndPictureGet", cond: nil)
    }


}
// MARK: - URLSessionDelegate
extension AppDelegate: URLSessionDelegate{
    
}
// MARK: - URLSessionDownloadDelegate
extension AppDelegate: URLSessionDownloadDelegate{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        do {
            
            let dataDic: [AnyObject] = try JSONSerialization.jsonObject(with: NSData(contentsOf: location)! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
            
            let dataArray: [AnyObject] = dataDic
            
            if let mydb = db{
                mydb.insert(tableName: "countdownTest", rowInfo: ["randomGoalTime":"'\(((dataArray[0]["S_price"])!)!)'","selectGoalTime":"010000"])
                
                for i in 0...dataArray.count-1{
                    mydb.insert(tableName: "ResturantGet", rowInfo: ["RG_tableID":"'\(i)'","RG_id":"'\(((dataArray[i]["S_id"])!)!)'","RG_name":"'\(((dataArray[i]["S_name"])!)!)'","RG_address":"'\(((dataArray[i]["S_address"])!)!)'","RG_phone":"'\(((dataArray[i]["S_phone"])!)!)'","RG_latitude":"'\(((dataArray[i]["S_latitude"])!)!)'","RG_longitude":"'\(((dataArray[i]["S__longitude"])!)!)'","RG_price":"'\(((dataArray[i]["S_price"])!)!)'","RG_opentime":"'\(((dataArray[i]["S_opentime"])!)!)'","RG_closetime":"'\(((dataArray[i]["S_closetime"])!)!)'","RG_photo":"'\(((dataArray[i]["P_photos"])!)!)'","RG_style":"'\(((dataArray[i]["T_name"])!)!)'"])
                }
 
            }
            
        } catch {
            print("Error!")
        }

    }
}
