//
//  rMGoogleMapMain.swift
//  sinopacFinalDemo
//
//  Created by 品軒 on 2017/4/19.
//  Copyright © 2017年 品軒. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class rMGoogleMapMain: UIViewController {

    var db: SQLiteConnect?
    
    var dataArray: [Int:[String:String]]?
    var arrayName: [String] = []
    var arrayLatitude: [String] = []
    var arrayLongitude: [String] = []
    var arrayImage: [String] = []
    
    var arrayType1: [String] = []
    var arrayType2: [String] = []
    var arrayType3: [String] = []
    var arrayType4: [String] = []
    var arrayType5: [String] = []
    
    var selectedComment: [AnyObject]?
    var arrayComment: [String] = []
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 16.0
    
    var likelyPlaces: [GMSPlace] = []
    var selectedPlace: GMSPlace?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("rMGoogleMapMain")
        
        //MARK: - NavigationSettig
        navigationItem.title = "美食地圖"
        
        // MARK: - 開啟資料庫
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let sqlitePath = urls[urls.count-1].absoluteString+"CardDb.sqlite3"
        
        db = SQLiteConnect(path : sqlitePath)
        
        // MARK: - GoogleMap 目前位置
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        // MARK: - GoogleMap 啟動地圖
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        
        view.addSubview(mapView)
        mapView.isHidden = true
        
        // MARK: - Navigation Setting
        navigationController?.title = "美食地圖"
        
    }

    override func viewWillAppear(_ animated: Bool) {
        if let mydb = db{
            
            let statement = mydb.fetch(tableName: "ResturantGet", cond: nil, order: nil)
            while sqlite3_step(statement) == SQLITE_ROW{
                if let id = sqlite3_column_text(statement, 2){
                    let a = String(cString: id)
                    arrayName.append(a)
                }
                if let id = sqlite3_column_text(statement, 5){
                    let a = String(cString: id)
                    arrayLatitude.append(a)
                }
                if let id = sqlite3_column_text(statement, 6){
                    let a = String(cString: id)
                    arrayLongitude.append(a)
                }
//                if let id = sqlite3_column_text(statement, 10){
//                    let a = String(cString: id)
//                    arrayImage.append(a)
//                }
            }
            sqlite3_finalize(statement)
            
            let statement1 = mydb.fetch(tableName: "ResturantTypeAndPictureGet", cond: nil, order: nil)
            while sqlite3_step(statement1) == SQLITE_ROW{
                if let photo = sqlite3_column_text(statement1, 8){
                    var a:String? = String(cString: photo)
                    
                    arrayImage.append(a!)
                }
                if let type = sqlite3_column_text(statement1, 2){
                    var a:String? = String(cString: type)
                    
                    arrayType1.append(a!)
                }
                if let type = sqlite3_column_text(statement1, 3){
                    var a:String? = String(cString: type)
                    
                    arrayType2.append(a!)
                }
                if let type = sqlite3_column_text(statement1, 4){
                    var a:String? = String(cString: type)
                    
                    arrayType3.append(a!)
                }
                if let type = sqlite3_column_text(statement1, 5){
                    var a:String? = String(cString: type)
                    
                    arrayType4.append(a!)
                }
                if let type = sqlite3_column_text(statement1, 6){
                    var a:String? = String(cString: type)
                    
                    arrayType5.append(a!)
                }
            }
            sqlite3_finalize(statement1)
        }
        
        // MARK: - Get 評論
        let url = NSURL(string: "http://10.11.24.95/eatwhat/api/selectComment")
        
        let sessionWithConfigure = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: OperationQueue.main)
        
        let dataTask = session.downloadTask(with: url! as URL)
        
        dataTask.resume()
        
        // MARK: - GoogleMap 設定marker
        mapView.clear()
        
        for i in 0...(arrayName.count-1){
            marker(latitude: Double(arrayLatitude[i])!, longitude: Double(arrayLongitude[i])!, title: "\(arrayName[i])", snippet: "長按可以獲得更多資訊喔！")
        }

    }
    
    func marker(latitude:CLLocationDegrees,longitude: CLLocationDegrees,title: String,snippet: String){
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = title
        marker.snippet = snippet
        marker.map = mapView
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mapView.clear()
    }

}
// MARK: - CLLocationManagerDelegate
extension rMGoogleMapMain: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        print("**************************************")
        print("Location:\(locations)")
        print("\(location.coordinate.latitude)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
        
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

extension rMGoogleMapMain: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        var selectedRestaurantName: String?
        var selectedRestaurantImage: String?
        
        let restaurantLatitude = NSString(format: "%.6f", marker.position.latitude)
        let restaurantLongitude = NSString(format: "%.6f", marker.position.longitude)
        
        for i in 0...(arrayName.count-1){
            if arrayLatitude[i] == restaurantLatitude as String && arrayLongitude[i] == restaurantLongitude as String{

                selectedRestaurantName = arrayName[i]
                selectedRestaurantImage = arrayImage[i]
            }
        }
        
        var markerView = UIView()
        markerView.frame = CGRect(x: 0, y: 0, width: 200, height: 210)
        markerView.backgroundColor = UIColor.white
        markerView.layer.cornerRadius = 20
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "\(selectedRestaurantName!)"
        label.textAlignment = .center
        markerView.addSubview(label)
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        
        let url = URL(string: "\(selectedRestaurantImage!)")
        let data = try!Data(contentsOf: url!)
        image.image = UIImage(data: data)
        markerView.addSubview(image)
        
        let viewDictionary : Dictionary = ["label":label,"image":image]
        
        let imageWidth = NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[image(150)]-25-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
        let imageHeight = NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[image(140)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
        
        markerView.addConstraints(imageWidth)
        markerView.addConstraints(imageHeight)

        
        let labelWidth = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[label]-10-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
        let labelHeight = NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[image(140)]-10-[label(30)]-10-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
        
        markerView.addConstraints(labelWidth)
        markerView.addConstraints(labelHeight)
        
        return markerView
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        var selectedRestaurant: String?
        
        let restaurantLatitude = NSString(format: "%.6f", marker.position.latitude)
        let restaurantLongitude = NSString(format: "%.6f", marker.position.longitude)
        
        var indexValue: Int?
        
        for i in 0...(arrayName.count-1){
            if arrayLatitude[i] == restaurantLatitude as String && arrayLongitude[i] == restaurantLongitude as String{
                print(arrayName[i])
                selectedRestaurant = arrayName[i]
                
                indexValue = i
                break
            }
        }
        
        print("選中的是："+"\(selectedRestaurant!)")
        
        arrayComment = ((selectedComment![indexValue!]["Comment"])!)! as! [String]
        print(arrayComment)
        
        let goToRMDetailInformation = storyboard?.instantiateViewController(withIdentifier: "rMDetailInformation") as! rMDetailInformation
        
        goToRMDetailInformation.getValueFromUpperView = selectedRestaurant!
        goToRMDetailInformation.getArrayValueFromUpperView = arrayComment
        
        let a = ((selectedComment![indexValue!]["S_id"])!)!
        
        print(arrayImage[indexValue!])
        
        goToRMDetailInformation.getListValueFromUpperView![0] = "\(a)"
        goToRMDetailInformation.getListValueFromUpperView![1] = arrayLatitude[indexValue!]
        goToRMDetailInformation.getListValueFromUpperView![2] = arrayLongitude[indexValue!]
        goToRMDetailInformation.getListValueFromUpperView![3] = arrayImage[indexValue!]
        
        goToRMDetailInformation.getListValueFromUpperView![4] = arrayType1[indexValue!]
        goToRMDetailInformation.getListValueFromUpperView![5] = arrayType2[indexValue!]
        goToRMDetailInformation.getListValueFromUpperView![6] = arrayType3[indexValue!]
        goToRMDetailInformation.getListValueFromUpperView![7] = arrayType4[indexValue!]
        goToRMDetailInformation.getListValueFromUpperView![8] = arrayType5[indexValue!]
        
        goToRMDetailInformation.modalTransitionStyle = .coverVertical
        goToRMDetailInformation.modalPresentationStyle = .fullScreen
        
        navigationController?.pushViewController(goToRMDetailInformation, animated: true)
    }
}

extension rMGoogleMapMain: URLSessionDownloadDelegate{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    
        do{
            let dataDic = try JSONSerialization.jsonObject(with: NSData(contentsOf: location)! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
        
            selectedComment = dataDic
            
        }catch{
            print("Error!")
            
        }
    }
}













