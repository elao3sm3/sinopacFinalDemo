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
    
    var getValueFromUpperView: String?
    
    let customPresentAnimationController = CustomPresentAnimationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        print("loveOrNotResturantDetail")
        
        //MARK: - NavigationSettig
        self.navigationItem.title = (self.getValueFromUpperView!)
        
        //MARK: - 啟動資料庫
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let sqlitePath = urls[urls.count-1].absoluteString+"CardDb.sqlite3"
        
        db = SQLiteConnect(path : sqlitePath)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let mydb = db{
            let statement = mydb.fetch(tableName: "diaryRecord", cond: nil/*"DR_name = "*/, order: nil)
            if sqlite3_step(statement) == SQLITE_ROW{
                if let count = sqlite3_column_text(statement, 0){
                    var a:String? = String(cString: count)
                    print(a!)
                    detailCount.append(a!)
                }
                if let photo = sqlite3_column_text(statement, 2){
                    var a:String? = String(cString: photo)
                    print(a!)
                    detailPhoto.append(a!)
                }
                if let date = sqlite3_column_text(statement, 5){
                    var a:String? = String(cString: date)
                    print(a!)
                    detailDate.append(a!)
                }
                if let meal = sqlite3_column_text(statement, 6){
                    var a:String? = String(cString: meal)
                    
                    print(a!)
                    
                    detailMeal.append(a!)
                }
            }else{
                detailCount.append("")
                detailPhoto.append("")
                detailDate.append("")
                detailMeal.append("")
            }
            sqlite3_finalize(statement)
        }
        
        //navigationController?.delegate = self
        
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
        let url = URL(string: "\((detailPhoto[0])!)")
        //let data = try!Data(contentsOf: url!)
        //imageView.image = UIImage(data: data)
        
        let mealLebal = cell.viewWithTag(2) as! UILabel
        //mealLebal.text = detailMeal[indexPath.row]
        
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


