//
//  loveOrNotResturantDetail.swift
//  sinopacFinalDemo
//
//  Created by 品軒 on 2017/4/13.
//  Copyright © 2017年 品軒. All rights reserved.
//

import UIKit

class loveOrNotResturantDetail: UIViewController {

    var db : SQLiteConnect?
    
    @IBOutlet weak var resturantDetailTableView: UITableView!
    
    var recordValue = 0
    var detailCount: [String?] = []
    var detailPhoto: [String?] = []
    var detailDate: [String?] = []
    var detailMeal: [String?] = []
    
    var ensurePhoto: [String] = []
    
    var decodedData:NSData?
    
    var getValueFromUpperView: String?
    
    let customPresentAnimationController = CustomPresentAnimationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        print("loveOrNotResturantDetail")
        print(self.getValueFromUpperView!)
        
        //MARK: - NavigationSettig
        self.navigationItem.title = (self.getValueFromUpperView!)
        
        //MARK: - 啟動資料庫
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let sqlitePath = urls[urls.count-1].absoluteString+"CardDb.sqlite3"
        
        db = SQLiteConnect(path : sqlitePath)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let mydb = db{
            
            let statement = mydb.fetch(tableName: "diaryRecord", cond: "DR_name = '\(self.getValueFromUpperView!)'", order: nil)
            while sqlite3_step(statement) == SQLITE_ROW{
                if let count = sqlite3_column_text(statement, 0){
                    var a:String = String(cString: count)
                    print(a)
                    
                    detailCount.append(a)
                }
                if let photo = sqlite3_column_text(statement, 2){
                    var a:String = String(cString: photo)
                    
                    ensurePhoto.append(a)
                }
                if let date = sqlite3_column_text(statement, 5){
                    var a:String = String(cString: date)
                    
                    detailDate.append(a)
                }
                if let meal = sqlite3_column_text(statement, 6){
                    var a:String = String(cString: meal)
                    
                    if a == nil||a == ""{
                        a = "尚未輸入餐點"
                        detailMeal.append(a)
                    }else{
                        detailMeal.append(a)
                    }
                }
            }
            sqlite3_finalize(statement)
            
            let statement1 = mydb.fetch(tableName: "ResturantPicture", cond: "RP_resturantName = '\(self.getValueFromUpperView!)'", order: nil)
            while sqlite3_step(statement1) == SQLITE_ROW{
                if let count = sqlite3_column_text(statement1, 2){
                    var a:String = String(cString: count)
                    print(a)
                    if a == nil||a == ""{
                        a = "a"
                        detailPhoto.append(a)
                    }else{
                        detailPhoto.append(a)
                    }
                }
            }
            sqlite3_finalize(statement1)
        }
        
        resturantDetailTableView.dataSource = self
        resturantDetailTableView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

        resturantDetailTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if recordValue == 0{
            self.navigationController?.popViewController(animated: true)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        
        detailCount = []
        detailPhoto = []
        detailDate = []
        detailMeal = []
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if segue.identifier == "goToResturantDetailInformation" {
//            let toViewController = segue.destination as UIViewController
//            toViewController.transitioningDelegate = self
//        }
//    }
    
    @IBAction func goToRestaurantDetailInformation(_ sender: UIBarButtonItem) {
        
        let lONResturantInformation = storyboard?.instantiateViewController(withIdentifier: "loveOrNotResturantInformation") as! loveOrNotResturantInformation
        lONResturantInformation.modalPresentationStyle = .custom
        lONResturantInformation.modalTransitionStyle = .crossDissolve
        navigationController?.pushViewController(lONResturantInformation, animated: true)
    }
    
    func goTodRDayDetailVC(indexPath: IndexPath){
        let goTodRDayDetailVC = storyboard?.instantiateViewController(withIdentifier: "dRDayDetailVC") as! dRDayDetailVC
        goTodRDayDetailVC.getValueFromUpperView = "\((detailCount[indexPath.row])!)"
        
        self.navigationController?.pushViewController(goTodRDayDetailVC, animated: true)
    }
}
//MARK: - UITableViewDataSource
extension loveOrNotResturantDetail: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return detailCount.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resturantDetailTableViewCell", for: indexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        
        if self.detailPhoto[indexPath.row]! != "a"{
            self.decodedData = NSData(base64Encoded: self.detailPhoto[indexPath.row]!, options:  NSData.Base64DecodingOptions(rawValue: 0))
            
            if self.decodedData != nil{
                let decodedimage = UIImage(data: self.decodedData! as Data)
                imageView.image = decodedimage
            }
        }
        
        let mealLebal = cell.viewWithTag(2) as! UILabel
        mealLebal.text = detailMeal[indexPath.row]
        
        let dataLebal = cell.viewWithTag(3) as! UILabel
        dataLebal.text = detailDate[indexPath.row]
        
        return cell
    }
}
//MARK: - UITableViewDelegate
extension loveOrNotResturantDetail: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recordValue = 1
        goTodRDayDetailVC(indexPath: indexPath)
    }
}
//MARK: - UINavigationControllerDelegate
extension loveOrNotResturantDetail: UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let transition = CustomPresentAnimationController()
        return transition
    }
}
////MARK: - UIViewControllerTransitioningDelegate
//extension loveOrNotResturantDetail: UIViewControllerTransitioningDelegate{
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return customPresentAnimationController
//    }
//}


