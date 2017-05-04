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
        
        view.addSubview(mapView)
        mapView.isHidden = true
        
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
                
            }
            
            sqlite3_finalize(statement)
            
        }
        print("123")
        print(arrayName.count)
        print(arrayName[0],arrayLatitude[0],arrayLongitude[0])
        
        // MARK: - GoogleMap 設定marker
        mapView.clear()
        
        for i in 0...(arrayName.count-1){
            marker(latitude: Double(arrayLatitude[i])!, longitude: Double(arrayLongitude[i])!, title: "\(arrayName[i])", snippet: "hello")
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
