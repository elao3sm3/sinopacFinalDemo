//
//  loveOrNotBlackListVC.swift
//  sinopacFinalDemo
//
//  Created by 品軒 on 2017/3/22.
//  Copyright © 2017年 品軒. All rights reserved.
//

import UIKit

class loveOrNotBlackListVC: UIViewController {

    var db : SQLiteConnect?
    var stringData : [String] = []
    
    @IBOutlet weak var loveOrNotBlackListView: UIView!
    @IBOutlet weak var loveOrNotBlackListTableView: UITableView!
    
    var searchController = UISearchController()
    var dataList : [String] = ["rice","burger","fish","soup","banana"]
    var selectedCellIndexPath : [IndexPath] = []
    
    var filtered:[String] = [String](){
        didSet  {loveOrNotBlackListTableView.reloadData()}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "黑名單"
        
        loveOrNotBlackListTableView.dataSource = self
        loveOrNotBlackListTableView.delegate = self
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = true
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.searchBar.searchBarStyle = .prominent
        self.searchController.searchBar.sizeToFit()
        
        self.loveOrNotBlackListView.addSubview(searchController.searchBar)
        loveOrNotBlackListTableView.tableHeaderView = loveOrNotBlackListView
        
        self.loveOrNotBlackListTableView.register(UINib(nibName: "loveOrNotTableVIiewCell", bundle: nil), forCellReuseIdentifier: "tableViewCell")
        
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let sqlitePath = urls[urls.count-1].absoluteString+"CardDb.sqlite3"
        
        db = SQLiteConnect(path : sqlitePath)
        
        if let mydb = db{
            let statement = mydb.fetch(tableName: "test", cond: nil, order: nil)
            if sqlite3_step(statement) == SQLITE_ROW{
                if let meal = sqlite3_column_text(statement, 1){
                    let a = String(cString: meal)
                    stringData.append(a)
                } else{
                    print("not Found")
                }
                
            }
            sqlite3_finalize(statement)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loveOrNotBlackListTableView.reloadData()
    }
    
    func goTodRDayDetail(){
        let goTodRDayDetai = storyboard?.instantiateViewController(withIdentifier: "dRDayDetailVC") as! dRDayDetailVC
        
        navigationController?.pushViewController(goTodRDayDetai, animated: true)
    }

}
extension loveOrNotBlackListVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive {
            return self.filtered.count
        } else {
            return 5
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! loveOrNotTableVIiewCell
        
        cell.frame = tableView.bounds
        cell.layoutIfNeeded()
        cell.layer.masksToBounds = true
        
         cell.label.text = stringData[0]
        
        //cell.reloadData()
        //cell.tableView(tableView, numberOfRowsInSection: 5)
        //cell.tableView.tableView(<#T##tableView: UITableView##UITableView#>, numberOfRowsInSection: <#T##Int#>
        //cell.tableView.
        return cell        
    }
    
}
extension loveOrNotBlackListVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let index = selectedCellIndexPath.index(of: indexPath) {
            selectedCellIndexPath.remove(at: index)
        }else{
            selectedCellIndexPath.append(indexPath)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedCellIndexPath.contains(indexPath) {
            
            let rowHeight = CGFloat((indexPath.row + 1)*40+40)
            print(rowHeight)
            return rowHeight
        }
       // print(40)
        return 40
    }
}

extension loveOrNotBlackListVC : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let seachText = searchController.searchBar.text else {
            return
        }
        
        self.filtered = self.dataList.filter({
            (dataList) -> Bool in
            let dataListText : NSString = dataList as NSString
            return (dataListText.range(of: seachText, options:NSString.CompareOptions.caseInsensitive).location)
                != NSNotFound
        })
    }

}
