//
//  rRRandomMain.swift
//  sinopacFinalDemo
//
//  Created by 品軒 on 2017/3/27.
//  Copyright © 2017年 品軒. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class rRRandomMain: UIViewController {

    var db : SQLiteConnect?
    var activityIndicator: UIActivityIndicatorView!
    
    let now = NSDate()
    var goalTime: Double?
    var transferDataArray: [AnyObject] = []
    var countTime: Int = 0
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    
    @IBOutlet weak var rRRandomMainPicker: UIPickerView!
    @IBOutlet weak var rRRandomMainTimeLabel: UILabel!
    
    var testTimeData :String? = nil
    var testTimeNumber : Int? = nil
    var autoTimer : Timer?
    
    var RI_tableID: [Int] = []
    
    var restaurantName: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("rRRandomMain")
        
        // MARK: - 設定環形進度條
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.center = self.view.center
       // activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        
        // MARK: - WebAPI POST RestaurantName
        activityIndicator.startAnimating()
        let webapiQueue = DispatchQueue(label: "com.rRRandomMain.webapiData")
        webapiQueue.sync {
            activityIndicator.startAnimating()

            var url = URL(string: "http://10.11.24.95/eatwhat/api/getgps_name")
            
            var request = URLRequest(url: url!)
            
            request.httpMethod = "POST"
            
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            let postString = ["S_latitude": "25.049481","S__longitude": "121.580030"]
            
            let postdata = try!JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
            
            request.httpBody = postdata

            let task = URLSession.shared.dataTask(with: request){ data, response, error in
                guard let data = data, error == nil else{
                    print("error = \(error)")
                    return
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{
                    print("error")
                    print("error")
                }
                let json = try?JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
                
                for i in 0...((json!.count) - 1){
                    
                    let name = ((json![i]["S_name"])!)! as! String
                    
                    self.restaurantName.append(name)
                }
                
                print(self.restaurantName)
                
                let responseString = String(data: data,encoding: .utf8)
                print("responseString = \(responseString!)")
               /*
                DispatchQueue.main.async {
                 self.activityIndicator.stopAnimating()
                }*/

            }
            task.resume()
            self.activityIndicator.stopAnimating()
        }
        
//        // MARK: - GoogleMap 目前位置
//        locationManager = CLLocationManager()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestAlwaysAuthorization()
//        locationManager.distanceFilter = 50
//        locationManager.startUpdatingLocation()
//        locationManager.delegate = self
//        
//        placesClient = GMSPlacesClient.shared()
//
    }

    override func viewWillAppear(_ animated: Bool) {
        
        // MARK: - 開啟資料庫
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let sqlitePath = urls[urls.count-1].absoluteString+"CardDb.sqlite3"
        
        db = SQLiteConnect(path : sqlitePath)
        if let mydb = self.db{
            
            let statement1 = mydb.fetch(tableName: "GoalTime", cond: nil, order: nil)
            if sqlite3_step(statement1) == SQLITE_ROW{
                
                if let timeData = sqlite3_column_text(statement1, 0){
                    var a: String? = String(cString: timeData)
                    print("目標時間戳為："+a!)
                    
                    goalTime = Double(a!)
                }
            }else{
                mydb.insert(tableName: "GoalTime", rowInfo: ["GT_goaltime":"'0'"])
                goalTime = 0
            }
            sqlite3_finalize(statement1)
            
            let statement2 = mydb.fetch(tableName: "DiaryRecord", cond: nil, order: nil)
            while sqlite3_step(statement2) == SQLITE_ROW{
                if let tableID = sqlite3_column_text(statement2, 0){
                    var a: String? = String(cString: tableID)
                    
                    self.RI_tableID.append((Int)(a!)!)
                }else{
                    self.RI_tableID = []
                }
            }
        }
        
        // MARK: - 當前時間(格林威治時間，加上28800為台灣時間)
        let timeInternal: TimeInterval = now.timeIntervalSince1970
        print("台灣當前時間時間戳"+"\((Int)(timeInternal)+28800)")
        
        // MARK: - 倒數計時Label 進行非同步執行
        let queue = DispatchQueue(label: "com.rRRandomMain.countdown")
        
        queue.async {
            
            if self.goalTime != 0{
                
                self.countTime = Int(self.goalTime! - (timeInternal as Double))
                print(self.countTime)
                
                    self.rRRandomMainTimeLabel.text = "\(Int(self.countTime))"
                    self.testTimeNumber = Int(self.countTime)
                
                    self.countdowd()
                
                if self.countTime == 0 || self.countTime < 0{
                    if let mydb = self.db{
                        mydb.update(tableName: "GoalTime", cond: nil, rowInfo: ["GT_goaltime":"'0'"])
                    }
                }
            }else{
                
                self.rRRandomMainTimeLabel.text = "00:00:00"
            }
            
        }
        
        self.countdowd()
        
        self.rRRandomMainPicker.dataSource = self
        self.rRRandomMainPicker.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.rRRandomMainPicker.dataSource = self
        self.rRRandomMainPicker.delegate = self
        
        self.rRRandomMainPicker.reloadComponent(0)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        self.RI_tableID = []
    }
    
    // MARK: - 拉霸按鈕
    @IBAction func pullButton(_ sender: UIButton) {
        print("countdown"+"\(countTime)")
        if countTime == 0{
        
        let value = arc4random()%(UInt32)(self.restaurantName.count)
        rRRandomMainPicker.selectRow(Int(value), inComponent: 0, animated: true)
        
        let postRestaurantQueue = DispatchQueue(label: "com.rRRandomMain.postRestaurant")
        
        postRestaurantQueue.sync {

            postRestaurant(restaurantName: ((restaurantName[Int(value)])) as! String)
        
        }
        
        let delayQueue = DispatchQueue(label: "com.rRRandomMain.randomAlert")
        
        delayQueue.asyncAfter(deadline: .now() + 0.3){
        let alert = UIAlertController(title: "選中的是", message: "\((self.restaurantName[(Int)(value)]))", preferredStyle: .alert)
        
            let cancelButton = UIAlertAction(title: "取消", style: .cancel, handler:nil)
        let pushButton = UIAlertAction(title: "確定", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            var tableID = self.RI_tableID.count
            print(tableID)
            
            if let mydb = self.db{
                mydb.insert(tableName: "ResturantInformation", rowInfo: ["RI_tableID":"'\(String(tableID))'","RI_id":"'\(((self.transferDataArray[0]["S_id"])!)!)'","RI_name":"'\(self.restaurantName[(Int)(value)])'","RI_address":"'\(((self.transferDataArray[0]["S_address"])!)!)'","RI_phone":"'\(((self.transferDataArray[0]["S_phone"])!)!)'","RI_latitude":"'\(((self.transferDataArray[0]["S_latitude"])!)!)'","RI_longitude":"'\(((self.transferDataArray[0]["S__longitude"])!)!)'","RI_price":"'\(((self.transferDataArray[0]["S_price"])!)!)'","RI_opentime":"'\(((self.transferDataArray[0]["S_opentime"])!)!)'","RI_closetime":"'\(((self.transferDataArray[0]["S_closetime"])!)!)'","RI_photo":"'\(((self.transferDataArray[0]["S_id"])!)!)'","RI_style":"'\(((self.transferDataArray[0]["T_name"])!)!)'","RI_preference":"'like'"])
                
                mydb.insert(tableName: "DiaryRecord", rowInfo: ["DR_tableID":"'\(String(tableID))'","DR_name":"'\(((self.transferDataArray[0]["S_name"])!)!)'","DR_photo":"'\(((self.transferDataArray[0]["S_id"])!)!)'","DR_style":"'\(((self.transferDataArray[0]["T_name"])!)!)'","DR_price":"'\(((self.transferDataArray[0]["S_price"])))'","DR_date":"'\(self.now)'"])
                
                mydb.insert(tableName: "ResturantPicture", rowInfo: ["RP_tableID":"'\(String(tableID))'","RP_resturantName":"'\(((self.transferDataArray[0]["S_name"])!)!)'"])
            }
            print(((self.transferDataArray[0]["S_name"])!)!)
            print("3")
            self.goTorRFoodMap(resturantNameTorRFoodMap: (self.restaurantName[(Int)(value)]))
        })
        alert.addAction(cancelButton)
        alert.addAction(pushButton)
        
        self.present(alert,animated: true,completion: nil)
        }
            let rightNow = NSDate()
            
        if let mydb = self.db{
            mydb.update(tableName: "GoalTime", cond: nil, rowInfo: ["GT_goaltime":"'\(Double(now.timeIntervalSince1970)+10)'"])
        }
            
            let timeInternal: TimeInterval = rightNow.timeIntervalSince1970
            goalTime = timeInternal + 10
            
            //self.viewWillAppear.reloadComponent
       }
    }
    // MARK: - 選擇按鈕
    @IBAction func popViewConditionView(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToPopViewConditionView", sender: nil)
    }
    
    // MARK: - 傳遞資料
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToPopViewConditionView"{
            
            let popView = segue.destination
            
            
            popView.preferredContentSize = CGSize(width: self.view.bounds.width/2, height: self.view.bounds.height/2)
            let con = popView.popoverPresentationController
            
            if con != nil{
                
                con?.delegate = self
            }
        }
    }
    // MARK: - 倒數計時器
    func countdowd(){
        
        autoTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdownMethod), userInfo: nil, repeats: true)
    }
    func countdownMethod(){
        
        if testTimeNumber != nil{
            
            testTimeNumber = testTimeNumber! - 1
            
            if self.testTimeNumber! >= 0{
                
                let hour = self.testTimeNumber! / 3600
                let minute = testTimeNumber! % 3600 / 60
                let second = testTimeNumber! % 60
                
                rRRandomMainTimeLabel.text = "\(hour) : \(minute) : \(second)"
            }
        }
    }
    
    // MARK: - post 餐廳名稱 response 餐廳資訊
    func postRestaurant(restaurantName: String?){
        
        var url = URL(string: "http://10.11.24.95/eatwhat/api/get_inform")
        
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let postString = ["S_name": "\(restaurantName!)"]
        
        let postdata = try!JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        
        request.httpBody = postdata
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            guard let data = data, error == nil else{
                
                print("error = \(error)")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{
                
                print("error : 請檢查網路")
            }
            let json = try?JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
            
            self.transferDataArray = json!
            print(((self.transferDataArray[0]["S__longitude"])!)!)
            
            let responseString = String(data: data,encoding: .utf8)
            print("responseString = \(responseString!)")
            
        }
            task.resume()
        
    }
    
    // MARK: - 前往GoogleMap
    func goTorRFoodMap(resturantNameTorRFoodMap: String){
        
        let goTorRFoodMap = storyboard?.instantiateViewController(withIdentifier: "rRFoodMap") as! rRFoodMap
        
        goTorRFoodMap.getValueFromUpperView = resturantNameTorRFoodMap
        
        navigationController?.pushViewController(goTorRFoodMap, animated: true)
    }
}
// MARK: - CLLocationManagerDelegate
extension rRRandomMain: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location: CLLocation = locations.last!
        
        print("Location:\(locations)")
        print("\(location.coordinate.latitude)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 16)
        
        if mapView.isHidden{
            
            mapView.isHidden = false
            mapView.camera = camera
        }else{
            
            mapView.animate(to: camera)
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not deternind")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK")
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

// MARK: - UIPickerViewDataSource
extension rRRandomMain : UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (restaurantName.count)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
// MARK: - UIPickerViewDelegate
extension rRRandomMain : UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return rRRandomMainPicker.layer.bounds.width
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "拉霸機"
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        
        pickerLabel.text = (restaurantName[row]) as! String
        pickerLabel.textAlignment = .center
        
        return pickerLabel
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         }
}
// MARK: - UIPopoverPresentationControllerDelegate
extension rRRandomMain : UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}










