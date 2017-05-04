//
//  loveOrNotTableVIiewCell.swift
//  sinopacFinalDemo
//
//  Created by 品軒 on 2017/3/29.
//  Copyright © 2017年 品軒. All rights reserved.
//

import UIKit

class loveOrNotTableVIiewCell: UITableViewCell {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        label.text = "123"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = true
        
        
        self.tableView.register(UINib(nibName: "loveOrNotTableViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: "tableViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadData(){
        //let rowHeight = self.tableView.rowHeight
        //self.tableView.rowHeight = rowHeight + 40
    }
    func goToDRDayDetail(){
    
        
    }
    
    
}
extension loveOrNotTableVIiewCell : UITableViewDataSource{
    func testHAHA() {}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! loveOrNotTableViewCellTableViewCell
        
        cell.detail.addTarget(self, action: #selector(goToDRDayDetail), for: .touchUpInside)
        
        cell.label.text = "asd"
        print(tableView.numberOfRows(inSection: 0))
        return cell
    }
}
extension loveOrNotTableVIiewCell : UITableViewDelegate{

}
