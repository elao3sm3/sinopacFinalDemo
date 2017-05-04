//
//  postData.swift
//  sinopacFinalDemo
//
//  Created by 品軒 on 2017/4/24.
//  Copyright © 2017年 品軒. All rights reserved.
//

import UIKit

class postData: UIViewController {

    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
//        activityIndicator.center = self.view.center
//        self.view.addSubview(activityIndicator)
//     
//        activityIndicator.hidesWhenStopped = true
//
//        
//        play()
//        
//        let afterQueue = DispatchQueue(label: "com.postData.activityIndicatorStopAndGoToTabbar")
//            afterQueue.asyncAfter(deadline: .now() + 5){
//                self.stop()
//        }
    }

    func play(){
        activityIndicator.startAnimating()
    }
    func stop(){
        activityIndicator.stopAnimating()
    }
    @IBAction func postData(_ sender: Any) {
    
        
        
        
    }
    
}//http://10.11.24.95/eatwhat/api/getgps_store












