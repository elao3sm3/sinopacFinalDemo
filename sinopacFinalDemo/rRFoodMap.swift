//
//  rRFoodMap.swift
//  sinopacFinalDemo
//
//  Created by 品軒 on 2017/3/27.
//  Copyright © 2017年 品軒. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class rRFoodMap: UIViewController {
    
    var db: SQLiteConnect?
    
    var dataArray: [Int:[String:String]]?
    var array: [String] = []
    var getValueFromUpperView: String?
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 16.0
    
    var likelyPlaces: [GMSPlace] = []
    var selectedPlace: GMSPlace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("rRFoodMap")
        print(getValueFromUpperView!)
        // MARK: - 資料庫
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let sqlitePath = urls[urls.count-1].absoluteString+"CardDb.sqlite3"
        
        db = SQLiteConnect(path : sqlitePath)
        
        if let mydb = db{
           
            let statement = mydb.fetch(tableName: "ResturantInformation", cond: "RI_name = '\(getValueFromUpperView!)'", order: nil)
            if sqlite3_step(statement) == SQLITE_ROW{
                print("asd")
                    if let name = sqlite3_column_text(statement, 2){
                        let a = String(cString: name)
                        array.append(a)
                    }
                if let latitude = sqlite3_column_text(statement, 5){
                    let a = String(cString: latitude)
                    array.append(a)
                }
                if let longtitude = sqlite3_column_text(statement, 6){
                    let a = String(cString: longtitude)
                    array.append(a)
                }

                }
            
            sqlite3_finalize(statement)
        
        }
        print("123")
        print(array.count)
        print(array[0],array[1],array[2])
        
        // MARK: - NavigationSetting
        navigationItem.title = array[0]
        
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
        
        view.addSubview(mapView)
        mapView.isHidden = true
        
        
        // MARK: - GoogleMap 設定marker
        mapView.clear()
        
        print(Double(array[1])!)
        
        marker(latitude: Double(array[1])!, longitude: Double(array[2])!, title: "\(array[0])", snippet: "hello")
        
 
    }

    func marker(latitude: CLLocationDegrees,longitude: CLLocationDegrees,title: String,snippet: String){
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = title
        marker.snippet = snippet
        marker.map = mapView
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mapView.clear()
        self.navigationController?.popViewController(animated: true)
    }
}
// MARK: - CLLocationManagerDelegate
extension rRFoodMap: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        print("Location:\(locations)")
        
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















