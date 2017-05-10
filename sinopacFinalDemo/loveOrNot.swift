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
    
    var resturantCount: [String?] = []
    var resturantName: [String?] = []
    var resturantPhoto: [String?] = []
    
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        if let mydb = db{
            
            let statement = mydb.fetch(tableName: "ResturantInformation", cond: nil/*"RI_preference = like"*/, order: nil)
            
            while sqlite3_step(statement) == SQLITE_ROW{
                if let count = sqlite3_column_text(statement, 0){
                    var a:String? = String(cString: count)
                    print(a!)
                    resturantCount.append(a!)
                }
                if let name = sqlite3_column_text(statement, 2){
                    var a:String? = String(cString: name)
                    resturantName.append(a!)
                }
                print("拿資料庫資料囉")
            }
            sqlite3_finalize(statement)
            
            let statement1 = mydb.fetch(tableName: "ResturantTypeAndPictureGet", cond: nil, order: nil)
            if sqlite3_step(statement1) == SQLITE_ROW{
                if let photo = sqlite3_column_text(statement1, 8){
                    var a:String? = String(cString: photo)
                    
                    print("asdasdasd"+a!)
                    resturantPhoto.append(a!)
                }
            }
            sqlite3_finalize(statement1)
        }

        if resturantCount.count ==  0{
            resturantCount.append("0")
            resturantName.append("目前沒有資料")
        }
        
        loveOrNotLeftTableView.dataSource = self
        loveOrNotLeftTableView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        loveOrNotLeftTableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        resturantCount = []
        resturantName = []
        resturantPhoto = []
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
            return resturantCount.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "loveOrNotTableViewCell", for: indexPath) as! loveOrNotVCTableViewCell
        
        cell.layer.borderColor = UIColor.orange.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        cell.contentView.addSubview(label)
//        
//        let sublabel = UILabel()
//        sublabel.translatesAutoresizingMaskIntoConstraints = false
//        cell.contentView.addSubview(sublabel)
//        
//        var image = UIImageView()
//        image.translatesAutoresizingMaskIntoConstraints = false
//        cell.contentView.addSubview(image)
//        
//        let views = ["label":label,"subLabel":sublabel,"image":image] as [String : Any]
//        
//        cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[image(90)]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
//        cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[image(80)]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
//        cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[image(90)]-10-[label]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
//        cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[label(50)]-0-[subLabel(30)]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
//        cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[image(90)]-10-[subLabel]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
//        cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[label(50)]-0-[subLabel(30)]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
//        print("1 3")
        print(resturantPhoto[0])
        let url = URL(string: "\((resturantPhoto[0])!)")
        let data = try!Data(contentsOf: url!)
        print("1 4")
//        print(resturantName[indexPath.row])
//        label.text = resturantName[indexPath.row]
//        sublabel.text = "來店次數：\((resturantCount[indexPath.row])!) 次"
//        image.image = UIImage(data: data)
        print("1 4")
        
            cell.loveOrNotVCTableViewCellLabel.text = resturantName[indexPath.row]
        cell.loveOrNotVCTableViewCellSubLabel.text = "來店次數：\((resturantCount[indexPath.row])!) 次"
        cell.loveOrNotVCTableViewCellImage.image = UIImage(data: data)
        
        return cell
    }
}
// MARK: - UITableViewDelegate
extension loveOrNot : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pushToLoveOrNotResturantDetail = storyboard?.instantiateViewController(withIdentifier: "loveOrNotResturantDetail") as! loveOrNotResturantDetail
        
        pushToLoveOrNotResturantDetail.getValueFromUpperView = "\(resturantName[indexPath.row]!)"
        
        
        self.navigationController?.pushViewController(pushToLoveOrNotResturantDetail, animated: true)
    }
    
}














