//
//  dRDayDetailVC.swift
//  sinopacFinalDemo
//
//  Created by 品軒 on 2017/3/22.
//  Copyright © 2017年 品軒. All rights reserved.
//

import UIKit

class dRDayDetailVC: UIViewController {

    var db : SQLiteConnect?
    
    var dataArray : [String] = ["餐廳","日期","餐點","評價","評論"]
    var dataRecord: [String?] = ["","","","","",""]
    var getValueFromUpperView: String?
    var getPageFromUpperView: String?
    
    var userAppraise: String? = "普通"
    
    var base64pic : String?
    var imageArray: [String] = ["","","","","","","","",""]
    var pictureString: String?
    var decodedData:NSData?
    var imageRecord = 0
    var check = true
    
    var collectionViewCanEdit: Bool = false
    
    var stay: Bool = true
    
    @IBOutlet weak var dRDayDetailTableView: UITableView!
    @IBOutlet weak var dRDayDetailImage: UIImageView!
    
    @IBOutlet weak var dRDayDetailCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("dRDayDetailVC")
        
        // MARK: - NavigationSetting
        let dRNavigationRightButton = UIBarButtonItem(title : "完成",style : .plain,target : self, action : #selector(navigationComplete))
        self.navigationItem.rightBarButtonItem = dRNavigationRightButton
        
        //MARK: - 啟動資料庫
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let sqlitePath = urls[urls.count-1].absoluteString+"CardDb.sqlite3"
        
        db = SQLiteConnect(path : sqlitePath)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if check == true{
            if let mydb = db{
               
                let statement = mydb.fetch(tableName: "DiaryRecord", cond: "DR_tableID = '\(((self.getValueFromUpperView!)))'", order: nil)
                
                if sqlite3_step(statement) == SQLITE_ROW{
                    
                    if let count = sqlite3_column_text(statement, 0){
                        
                        var a:String? = String(cString: count)
                    
                        dataRecord[0] = a!
                    }
                    if let name = sqlite3_column_text(statement, 1){
                        
                        var a:String? = String(cString: name)
                        
                        dataRecord[1] = a!
                    }
                    if let date = sqlite3_column_text(statement, 5){
                        
                        var a:String? = String(cString: date)
                        
                        dataRecord[2] = a!
                    }
                    if let meal = sqlite3_column_text(statement, 6){
                        
                        var a:String? = String(cString: meal)
                        
                        if a == nil{
                        
                            a = "尚未輸入餐點"
                            dataRecord[3] = a!
                        }else{
                            
                            print(a!)
                            dataRecord[3] = a!
                        }
                    }
                    if let preference = sqlite3_column_text(statement, 7){
                        
                        var a:String? = String(cString: preference)
                        
                        if a == nil{
                            
                            a == "like"
                            dataRecord[4] = a!
                        }else{
                            
                            dataRecord[4] = a!
                        }
                    }
                    if let comment = sqlite3_column_text(statement, 8){
                        var a:String? = String(cString: comment)
                        
                        if a == nil{
                            
                            a = "尚未輸入評論"
                            dataRecord[5] = a!
                        }else{
                            
                            dataRecord[5] = a!
                        }
                    }
                    
                }
                sqlite3_finalize(statement)
                
                 let statement1 = mydb.fetch(tableName: "ResturantPicture", cond: "RP_tableID = '\(((self.getValueFromUpperView!)))'", order: nil)
                
                if sqlite3_step(statement1) == SQLITE_ROW{
                    
                    if let picture1 = sqlite3_column_text(statement1, 2){
                        
                        var a:String? = String(cString: picture1)
                        if a != nil{
                            imageArray[0] = a!
                        }
                    }
                    if let picture1 = sqlite3_column_text(statement1, 3){
                        
                        var a:String? = String(cString: picture1)
                        if a != nil{
                            imageArray[1] = a!
                        }
                    }
                    if let picture1 = sqlite3_column_text(statement1, 4){
                        
                        var a:String? = String(cString: picture1)
                        if a != nil{
                            imageArray[2] = a!
                        }
                    }
                    if let picture1 = sqlite3_column_text(statement1, 5){
                        
                        var a:String? = String(cString: picture1)
                        if a != nil{
                            imageArray[3] = a!
                        }
                    }
                    if let picture1 = sqlite3_column_text(statement1, 6){
                        
                        var a:String? = String(cString: picture1)
                        if a != nil{
                            imageArray[4] = a!
                        }
                    }
                    if let picture1 = sqlite3_column_text(statement1, 7){
                        
                        var a:String? = String(cString: picture1)
                        if a != nil{
                            imageArray[5] = a!
                        }
                    }
                    if let picture1 = sqlite3_column_text(statement1, 8){
                        
                        var a:String? = String(cString: picture1)
                        if a != nil{
                            imageArray[6] = a!
                        }
                    }
                    if let picture1 = sqlite3_column_text(statement1, 9){
                        
                        var a:String? = String(cString: picture1)
                        if a != nil{
                            imageArray[7] = a!
                        }
                    }
                    if let picture1 = sqlite3_column_text(statement1, 10){
                        
                        var a:String? = String(cString: picture1)
                        if a != nil{
                            
                            imageArray[8] = a!
                        }
                    }
                }
                sqlite3_finalize(statement1)
            }
        }
        
        dRDayDetailTableView.dataSource = self
        dRDayDetailTableView.delegate = self
    
        dRDayDetailCollectionView.dataSource = self
        dRDayDetailCollectionView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        
        stay = false
        dRDayDetailTableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        if stay == false{
            self.navigationController?.popToRootViewController(animated: true)
            
            for i in 0...8{
                imageArray[i] = ""
            }
            imageRecord = 0
            check = true
            collectionViewCanEdit = false
        }
        collectionViewCanEdit = false
    }

    func navigationComplete(){
       
        let cell = dRDayDetailTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! dRDayDetailVCTableViewCellMeal
        let textField = cell.dRDayDetailVCTableViewCellMealTextField.text
        
        let cell1 = dRDayDetailTableView.cellForRow(at: IndexPath(row: 4,section: 0)) as! dRDayDetailVCTableViewCellTextView
        let textView = cell1.dRDayDetailVCTableViewCellAppraiseTextView.text
        
        if let mydb = db{
        
            mydb.update(tableName: "DiaryRecord", cond: "DR_tableID = '\(((self.getValueFromUpperView!)))'", rowInfo: ["DR_meal":"'\(textField!)'","DR_preference":"'\(userAppraise!)'","DR_comment":"'\(textView!)'"])
            
            mydb.update(tableName: "ResturantPicture", cond: "RP_tableID = '\(((self.getValueFromUpperView!)))'", rowInfo: ["RP_picture1":"'\(self.imageArray[0])'","RP_picture2":"'\(self.imageArray[1])'","RP_picture3":"'\(self.imageArray[2])'","RP_picture4":"'\(self.imageArray[3])'","RP_picture5":"'\(self.imageArray[4])'","RP_picture6":"'\(self.imageArray[5])'","RP_picture7":"'\(self.imageArray[6])'","RP_picture8":"'\(self.imageArray[7])'","RP_picture9":"'\(self.imageArray[8])'",])
        }
        
        collectionViewCanEdit = false
        for i in 0...8{
            imageArray[i] = ""
        }
        imageRecord = 0
        check = true
        
        let alert = UIAlertController(title: "要把評論推送至雲端嗎？", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "不要",style: .cancel){
            (action: UIAlertAction) -> Void in
            
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(cancelAction)
        let okAction = UIAlertAction(title: "可以", style: .default) { (action: UIAlertAction) -> Void in
            
            var url = URL(string: "http://10.11.24.95/eatwhat/api/addComments")
            
            var request = URLRequest(url: url!)
            
            request.httpMethod = "POST"
            
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            print(self.dataRecord[1])
            print(textView!)
            
            let postString = ["S_name":"\(self.dataRecord[1]!)","Comment": "\(textView!)"]
            
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
                
                let responseString = String(data: data,encoding: .utf8)
                print("responseString = \(responseString!)")
            }
            task.resume()
            
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        
        self.present(alert,animated: true,completion: nil)
    }
    // MARK: - 允許編輯collection view
    @IBAction func addPicture(_ sender: UIButton) {
        
        collectionViewCanEdit = true
        
    }
    
    // MARK: - 增加照片的方式
    @IBAction func takePicture(_ sender: Any) {
        
        let alert = UIAlertController(title: "新增圖片", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(
            title: "取消",
            style: .cancel,
            handler: nil)
        alert.addAction(cancelAction)
        
        let takePictureButton = UIAlertAction(title: "拍照", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            
            self.stay = true
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = UIImagePickerControllerSourceType.camera
                picker.allowsEditing = true
                
                self.present(picker, animated: true, completion: {
                    () -> Void in
                })
            }else{
                print("找不到相機")
            }
            
        })
        alert.addAction(takePictureButton)
        
        let addPictureButton = UIAlertAction(title: "相冊", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            
            self.stay = true
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                
                self.present(picker, animated: true, completion: {
                    () -> Void in
                })
            }else{
                print("讀取相冊失敗")
            }
            
        })
        alert.addAction(addPictureButton)
        
        self.present(alert,animated: true,completion: nil)
        
    }
    
    func appraiseChange(sender: UISegmentedControl){
        
        print(sender.titleForSegment(at: sender.selectedSegmentIndex)!)
        
        userAppraise = sender.titleForSegment(at: sender.selectedSegmentIndex)!
    }
    
}
// MARK: - UITableViewDataSource
extension dRDayDetailVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4{
            return 132
        }else{
            return 44
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dRDayDetailTableViewCell", for: indexPath)
            
            let restaurantName = cell.viewWithTag(1) as! UILabel
            restaurantName.text = dataArray[0]
            
            let restaurantNameValue = cell.viewWithTag(2) as! UILabel
            restaurantNameValue.text = dataRecord[1]
            
            return cell
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "dRDayDetailTableViewCell", for: indexPath)
            
            let restaurantName = cell.viewWithTag(1) as! UILabel
            restaurantName.text = dataArray[1]
            
            let restaurantNameValue = cell.viewWithTag(2) as! UILabel
            restaurantNameValue.text = dataRecord[2]
            
            return cell
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "dRDayDetailTableViewCellMeal", for: indexPath) as! dRDayDetailVCTableViewCellMeal
            
            cell.dRDayDetailVCTableViewCellMealLabel.text = dataArray[2]
            cell.dRDayDetailVCTableViewCellMealTextField.text = dataRecord[3]
            
            return cell
        case 3:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "dRDayDetailTableViewCellAppraise", for: indexPath) as! dRDayDetailVCTableViewCellAppraise
            
            cell.dRDayDetailVCTableViewCellAppraiseLabel.text = dataArray[3]
            cell.dRDayDetailVCTableViewCellAppraiseSegment.addTarget(self, action: #selector(appraiseChange), for: .valueChanged)
            
            return cell
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "dRDayDetailTableViewCellTextView", for: indexPath) as! dRDayDetailVCTableViewCellTextView
            
            cell.dRDayDetailVCTableViewCellTextViewLabel.text = dataArray[4]
            cell.dRDayDetailVCTableViewCellAppraiseTextView.text = dataRecord[5]
            
            return cell
        }
    }
}
// MARK: - UITableViewDelegate
extension dRDayDetailVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
// MARK: - UINavigationControllerDelegate
extension dRDayDetailVC: UINavigationControllerDelegate {

}
// MARK: - UICollectionViewDataSource
extension dRDayDetailVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! UICollectionViewCell
        
        var image = cell.viewWithTag(1) as! UIImageView
        
        self.decodedData = NSData(base64Encoded: self.imageArray[0], options:  NSData.Base64DecodingOptions(rawValue: 0))
        
        if decodedData != nil{
            let decodedimage = UIImage(data: decodedData! as Data)
            image.image = decodedimage
        }
        
        return cell
    }

}
// MARK: - UICollectionViewDelegate
extension dRDayDetailVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionViewCanEdit == true{
            
            let alertView = UIAlertController(title: "確定要刪除？", message: "", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(
                title: "取消",
                style: .cancel,
                handler: nil)
            alertView.addAction(cancelAction)
            
            let okAction = UIAlertAction(
                title: "確認",
                style: .default,
                handler: {
                    (action: UIAlertAction!) -> Void in
                    
                    print("你刪除了\(self.imageArray[indexPath.row])")
                    self.imageArray.remove(at: indexPath.row)
                    self.imageArray.append("")
                    //self.collectionViewEdit = false
                    self.dRDayDetailCollectionView.reloadData()
                    
            })
            alertView.addAction(okAction)
            
            self.present(
                alertView,
                animated: true,
                completion: nil)
            
        }
    }

}
// MARK: - UIImagePickerControllerDelegate
extension dRDayDetailVC : UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //dRDayDetailImageView.image = image
        picker.dismiss(animated: true, completion: {
            () -> Void in
        })
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        let stringBase64 = imageData?.base64EncodedString(options:NSData.Base64EncodingOptions(rawValue:0))
        base64pic = stringBase64
        
            imageArray[1] = base64pic!
            imageRecord = imageRecord + 1
            check = false
        
            print(imageArray.count)
        
            dRDayDetailCollectionView.reloadData()
        
    }
}












