//
//  loveOrNot.swift
//  sinopacFinalDemo
//
//  Created by 品軒 on 2017/3/22.
//  Copyright © 2017年 品軒. All rights reserved.
//

import UIKit

class loveOrNot: UIViewController {

    
    @IBOutlet weak var loveOrNotLeftTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "我的最愛"
        
        let navigationRightButton = UIBarButtonItem(title : "黑名單",style : .plain,target : self, action : #selector(navigationPushToloveOrNotBlackListVC))
        navigationItem.rightBarButtonItem = navigationRightButton
        
        loveOrNotLeftTableView.dataSource = self
        loveOrNotLeftTableView.delegate = self
        
    loveOrNotLeftTableView.backgroundColor = UIColor.orange
        
    }
    func navigationPushToloveOrNotBlackListVC(){
        let pushToloveOrNotBlackListVC = storyboard?.instantiateViewController(withIdentifier: "loveOrNotBlackListVC") as! loveOrNotBlackListVC
        
        self.navigationController?.pushViewController(pushToloveOrNotBlackListVC, animated: true)
    }

}
extension loveOrNot : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "loveOrNotTableViewCell", for: indexPath)
        
        return cell
    }
}
extension loveOrNot : UITableViewDelegate{
    
}
