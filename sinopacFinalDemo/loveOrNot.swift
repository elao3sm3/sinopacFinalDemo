//
//  loveOrNot.swift
//  sinopacFinalDemo
//
//  Created by 品軒 on 2017/3/22.
//  Copyright © 2017年 品軒. All rights reserved.
//

import UIKit

class loveOrNot: UIViewController {
    
    var db : SQLiteConnect?
    
    @IBOutlet weak var loveOrNotLeftTableView: UITableView!
    @IBOutlet weak var loveOrNotView: UIView!
    @IBOutlet weak var loveOrNotSegment: UISegmentedControl!
    
    var resturantCount: [String] = []
    var resturantName: [String] = []
    var resturantPhoto: [String] = []
    
    var resturantCountCommon: [String] = []
    var resturantNameCommon: [String] = []
    var resturantPhotoCommon: [String] = []
    var resturantCountLike: [String] = []
    var resturantNameLike: [String] = []
    var resturantPhotoLike: [String] = []
    var resturantCountHate: [String] = []
    var resturantNameHate: [String] = []
    var resturantPhotoHate: [String] = []
    
    var check = true
    
    var arrayRepeat = ["a","a","b","c"]
    //var arrayNotRepeat = Array(Set(arrayrepeat))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("loveOrNot")
        
        //MARK: - NavigationSettig
        navigationItem.title = "我的最愛"
        
        let navigationRightButton = UIBarButtonItem(title : "黑名單",style : .plain,target : self, action : #selector(navigationPushToloveOrNotBlackListVC))
        navigationItem.rightBarButtonItem = navigationRightButton
        
        //MARK: - 啟動資料庫
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let sqlitePath = urls[urls.count-1].absoluteString+"CardDb.sqlite3"
        
        db = SQLiteConnect(path : sqlitePath)
        
        // MARK: - Segment func
        loveOrNotSegment.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        if let mydb = db{
            
            let statementLike = mydb.fetch(tableName: "ResturantInformation", cond: "RI_preference = 'like'", order: nil)
            while sqlite3_step(statementLike) == SQLITE_ROW{
                if let count = sqlite3_column_text(statementLike, 0){
                    var a:String? = String(cString: count)
                    print(a!)
                    resturantCountLike.append(a!)
                }
                if let name = sqlite3_column_text(statementLike, 2){
                    var a:String? = String(cString: name)
                    resturantNameLike.append(a!)
                }
                if let photo = sqlite3_column_text(statementLike, 10){
                    var a:String? = String(cString: photo)
                    resturantPhotoLike.append(a!)
                }

            }
            sqlite3_finalize(statementLike)
            
            let statementCommon = mydb.fetch(tableName: "ResturantInformation", cond: "RI_preference = 'common'", order: nil)
            while sqlite3_step(statementCommon) == SQLITE_ROW{
                if let count = sqlite3_column_text(statementCommon, 0){
                    var a:String? = String(cString: count)
                    print(a!)
                    resturantCountCommon.append(a!)
                }
                if let name = sqlite3_column_text(statementCommon, 2){
                    var a:String? = String(cString: name)
                    resturantNameCommon.append(a!)
                }
                if let photo = sqlite3_column_text(statementCommon, 10){
                    var a:String? = String(cString: photo)
                    resturantPhotoCommon.append(a!)
                }
            }
            sqlite3_finalize(statementCommon)
            
            let statementHate = mydb.fetch(tableName: "ResturantInformation", cond: "RI_preference = 'hate'", order: nil)
            while sqlite3_step(statementHate) == SQLITE_ROW{
                if let count = sqlite3_column_text(statementHate, 0){
                    var a:String? = String(cString: count)
                    print(a!)
                    resturantCountHate.append(a!)
                }
                if let name = sqlite3_column_text(statementHate, 2){
                    var a:String? = String(cString: name)
                    resturantNameHate.append(a!)
                }
                if let photo = sqlite3_column_text(statementHate, 10){
                    var a:String? = String(cString: photo)
                    resturantPhotoHate.append(a!)
                }
            }
            
            sqlite3_finalize(statementHate)
        }
        
        if check ==  true{
            
            resturantCount = resturantCountLike
            resturantName = resturantNameLike
            resturantPhoto = resturantPhotoLike
        }
            
        loveOrNotLeftTableView.dataSource = self
        loveOrNotLeftTableView.delegate = self
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        loveOrNotSegment.selectedSegmentIndex = 0
        
        check = true
        
        resturantCountLike = []
        resturantNameLike = []
        resturantPhotoLike = []
        
        resturantCountCommon = []
        resturantNameCommon = []
        resturantPhotoCommon = []
        
        resturantCountHate = []
        resturantNameHate = []
        resturantPhotoHate = []
    }
    
    func valueChanged(sender: UISegmentedControl){
        print(sender.titleForSegment(at: sender.selectedSegmentIndex)!)
        
        self.resturantCount = []
        self.resturantName = []
        self.resturantPhoto = []
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.resturantCount = self.resturantCountLike
            self.resturantName = self.resturantNameLike
            self.resturantPhoto = self.resturantPhotoLike
            
        case 1:
            self.resturantCount = self.resturantCountCommon
            self.resturantName = self.resturantNameCommon
            self.resturantPhoto = self.resturantPhotoCommon
        
        default:
            self.resturantCount = self.resturantCountHate
            self.resturantName = self.resturantNameHate
            self.resturantPhoto = self.resturantPhotoHate
        }
        
        check = false
        
        self.loveOrNotLeftTableView.reloadData()
    }
    
    func navigationPushToloveOrNotBlackListVC(){
        let pushToloveOrNotBlackListVC = storyboard?.instantiateViewController(withIdentifier: "loveOrNotBlackListVC") as! loveOrNotBlackListVC
        
        self.navigationController?.pushViewController(pushToloveOrNotBlackListVC, animated: true)
    }
}
// MARK: - UITableViewDataSource
extension loveOrNot : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print(resturantCount.count)
            return resturantName.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "loveOrNotTableViewCell", for: indexPath) as! loveOrNotVCTableViewCell
        
        cell.layer.borderColor = UIColor.orange.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        let url = URL(string: "\((resturantPhoto[indexPath.row]))")
        let data = try!Data(contentsOf: url!)
        
        cell.loveOrNotVCTableViewCellLabel.text = resturantName[indexPath.row]
        cell.loveOrNotVCTableViewCellSubLabel.text = "來店次數：\((resturantCount[indexPath.row])) 次"
        cell.loveOrNotVCTableViewCellImage.image = UIImage(data: data)
        
        return cell
    }
}
// MARK: - UITableViewDelegate
extension loveOrNot : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pushToLoveOrNotResturantDetail = storyboard?.instantiateViewController(withIdentifier: "loveOrNotResturantDetail") as! loveOrNotResturantDetail
        
        pushToLoveOrNotResturantDetail.getValueFromUpperView = "\(resturantName[indexPath.row])"
        
        self.navigationController?.pushViewController(pushToLoveOrNotResturantDetail, animated: true)
    }
    
}














