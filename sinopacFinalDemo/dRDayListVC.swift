//
//  dRDayListVC.swift
//  sinopacFinalDemo
//
//  Created by 品軒 on 2017/3/22.
//  Copyright © 2017年 品軒. All rights reserved.
//

import UIKit

class dRDayListVC: UIViewController {

    var db : SQLiteConnect?
    
    @IBOutlet weak var dRDayListTableView: UITableView!
    @IBOutlet weak var dRDayListView: UIView!
    
    var resturantCount: [String?] = []
    var resturantName: [String?] = []
    var resturantPhoto: [String?] = []
    var resturantStyle: [String?] = []
    var resturantPrice: [String?] = []
    var resturantDate: [String?] = []
    
    var testPhoto: [String?] = []
    
    var searchController = UISearchController()
    var filtered:[String] = [String](){
        didSet  {dRDayListTableView.reloadData()}
    }
    
    var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("dRDayListVC")
        
        // MARK: - NavigationSetting
        navigationItem.title = "美食總覽"
        
        let navigationRightNewButton = UIBarButtonItem(title: "新增日誌", style: .plain, target: self, action: #selector(addDayRecord))
        navigationItem.rightBarButtonItem = navigationRightNewButton
        
        //MARK: - 啟動資料庫
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let sqlitePath = urls[urls.count-1].absoluteString+"CardDb.sqlite3"
        
        db = SQLiteConnect(path : sqlitePath)
            
        // MARK: - UISearchController
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = true
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.searchBar.searchBarStyle = .prominent
        self.searchController.searchBar.sizeToFit()
        
        self.dRDayListView.addSubview(searchController.searchBar)
        dRDayListTableView.tableHeaderView = dRDayListView
        
        dRDayListTableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let mydb = db{
            let statement = mydb.fetch(tableName: "diaryRecord", cond: nil, order: nil)
            while sqlite3_step(statement) == SQLITE_ROW{
                if let count = sqlite3_column_text(statement, 0){
                    var a:String? = String(cString: count)
                    
                    resturantCount.append(a!)
                }
                if let name = sqlite3_column_text(statement, 1){
                    var a:String? = String(cString: name)
                    
                    resturantName.append(a!)
                }
                if let photo = sqlite3_column_text(statement, 2){
                    var a:String? = String(cString: photo)
                    
                    resturantPhoto.append(a!)
                }
                if let style = sqlite3_column_text(statement, 3){
                    var a:String? = String(cString: style)
                    
                    resturantStyle.append(a!)
                }
                if let price = sqlite3_column_text(statement, 4){
                    var a:String? = String(cString: price)
                    
                    resturantPrice.append(a!)
                }
                if let date = sqlite3_column_text(statement, 5){
                    var a:String? = String(cString: date)
                    
                    resturantDate.append(a!)
                }
                
            }
            sqlite3_finalize(statement)
            
            let statement1 = mydb.fetch(tableName: "ResturantTypeAndPictureGet", cond: nil, order: nil)
            if sqlite3_step(statement1) == SQLITE_ROW{
                if let photo = sqlite3_column_text(statement1, 8){
                    var a:String? = String(cString: photo)
                    
                    testPhoto.append(a!)
                }
            }
            sqlite3_finalize(statement1)

        }
        
        if resturantCount[0] == nil{
            resturantCount.append("")
            resturantName.append("")
            resturantPhoto.append("")
            resturantStyle.append("")
            resturantPrice.append("")
            resturantDate.append("")
        }

        
        print("123\(resturantPhoto[0]!)")
        
        dRDayListTableView.dataSource = self
        dRDayListTableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        dRDayListTableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        resturantCount = []
        resturantName = []
        resturantPhoto = []
        resturantStyle = []
        resturantPrice = []
        resturantDate = []
    }
    
    func showMonth(){
       self.performSegue(withIdentifier: "goToPopViewMonth", sender: nil)
    }
    // MARK: - 傳遞資訊
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPopViewMonth" {
            let popView = segue.destination
            popView.preferredContentSize = CGSize(width: 300, height: 300)
            let con = popView.popoverPresentationController
            if con != nil{
                con?.delegate = self
            }
        }
    }
    
    func addDayRecord(){
        let goToDRDayDetail = storyboard?.instantiateViewController(withIdentifier: "dRDayDetailVC") as!dRDayDetailVC
        navigationController?.pushViewController(goToDRDayDetail, animated: true)
    }
}
// MARK: - UITableViewDataSource
extension dRDayListVC : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive{
            return 1
        }else{
            return resturantDate.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive{
            return "搜尋結果"
        }else{
            return resturantDate[section]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive{
            return filtered.count
        }else{
            return resturantCount.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dRDayListTableViewCell", for: indexPath) as! dRDayListVCTableViewCell
        
        cell.layer.borderColor = UIColor.orange.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        if searchController.isActive{
//            label.text = "老吳滷肉飯"
//            subLabel.text = "\(filtered[indexPath.row])"
//            image.image = UIImage(named: "/Users/wei/Desktop/sinopacFinalDemo/圖片/test.png")
            return cell
        }else{
            //let url = URL(string: "\((resturantPhoto[indexPath.row])!)")
            //let data = try!Data(contentsOf: url!)

            print((self.resturantPhoto[indexPath.row])!)
            
            let url = URL(string: "\((self.resturantPhoto[indexPath.row])!)")
            let data = try!Data(contentsOf: url!)
            
            cell.dRDayListVCTableViewCellLabel.text = resturantName[indexPath.row]
            cell.dRDayListVCTableViewCellSubLabel.text = resturantStyle[indexPath.row]
            cell.dRDayListVCTableViewCellImage.image = UIImage(data: data)
            
            return cell
        }
    }
}
// MARK: - UITableViewDelegate
extension dRDayListVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let goTodRDayDetail = storyboard?.instantiateViewController(withIdentifier: "dRDayDetailVC") as! dRDayDetailVC
        goTodRDayDetail.getValueFromUpperView = "\((resturantCount[indexPath.row])!)"
        //goTodRDayDetail.getPageFromUpperView = "DRDayList"
        
        navigationController?.pushViewController(goTodRDayDetail, animated: true)
    }
}
// MARK: - UISearchResultsUpdating
extension dRDayListVC : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let seachText = searchController.searchBar.text else {
            return
        }
        
        self.filtered = self.resturantName.filter({
            (dataList) -> Bool in
            let dataListText : NSString = dataList as! NSString
            return (dataListText.range(of: seachText, options:NSString.CompareOptions.caseInsensitive).location)
                != NSNotFound
        }) as! [String]
    }
}
// MARK: - UIPopoverPresentationControllerDelegate
extension dRDayListVC : UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}








