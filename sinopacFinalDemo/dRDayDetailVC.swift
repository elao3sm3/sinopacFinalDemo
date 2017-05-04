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
    var base64pic : String?
    var getValueFromUpperView: String?
    var getPageFromUpperView: String?
    
    @IBOutlet weak var dRDayDetailTableView: UITableView!
    @IBOutlet weak var dRDayDetailImageView: UIImageView!
    
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
    
        print("ok")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
            if let mydb = db{
                print("asd"+(self.getValueFromUpperView!))
                let statement = mydb.fetch(tableName: "DiaryRecord", cond: "DR_tableID = '\(((self.getValueFromUpperView!)))'", order: nil)
                
                if sqlite3_step(statement) == SQLITE_ROW{
                    
                    if let count = sqlite3_column_text(statement, 0){
                        var a:String? = String(cString: count)
                        print(a!)
                        dataRecord[0] = a!
                    }
                    if let name = sqlite3_column_text(statement, 1){
                        var a:String? = String(cString: name)
                        print(a!)
                        dataRecord[1] = a!
                    }
                    if let date = sqlite3_column_text(statement, 5){
                        var a:String? = String(cString: date)
                        print(a!)
                        dataRecord[2] = a!
                    }
                    if let meal = sqlite3_column_text(statement, 6){
                        var a:String? = String(cString: meal)
                        print(a!)
                        if a == nil{
                            a = "尚未輸入餐點"
                            dataRecord[3] = a!
                        }else{
                            dataRecord[3] = a!
                        }
                    }
                    if let preference = sqlite3_column_text(statement, 7){
                        var a:String? = String(cString: preference)
                        print(a!)
                        if a == nil{
                            a == "like"
                            dataRecord[4] = a!
                        }else{
                            dataRecord[4] = a!
                        }
                    }
                    if let comment = sqlite3_column_text(statement, 8){
                        var a:String? = String(cString: comment)
                        print(a!)
                        if a == nil{
                            a = "尚未輸入評論"
                            dataRecord[5] = a!
                        }else{
                            dataRecord[5] = a!
                        }
                    }
                    
                }
                sqlite3_finalize(statement)
            }

        dRDayDetailTableView.dataSource = self
        dRDayDetailTableView.delegate = self
    
    }

    override func viewDidAppear(_ animated: Bool) {
        
        dRDayDetailTableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }

    func navigationComplete(){
        
       self.navigationController?.popViewController(animated: true
        )
    }
    @IBAction func addPicture(_ sender: UIButton) {
        
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
    }
    
    @IBAction func takePicture(_ sender: Any) {
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dRDayDetailTableViewCell", for: indexPath)
        
        let label = UILabel(frame : .null)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(dataArray[indexPath.row])"
        cell.contentView.addSubview(label)
        
        let labelName = UILabel()
        labelName.translatesAutoresizingMaskIntoConstraints = false
        
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        cell.layer.masksToBounds = true
        
        let views = ["label":label,"labelName":labelName,"textField":textField,"textView":textView]
        
        switch indexPath.row {
            
        case 0:
            labelName.text = dataRecord[1]
            
            cell.contentView.addSubview(labelName)
            
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[label(100)]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[label(20)]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[label(100)]-10-[labelName]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[labelName(20)]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
            
            return cell
            
        case 1:
            labelName.text = dataRecord[2]
            
            cell.contentView.addSubview(labelName)
            
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[label(100)]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-11-[label(20)]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[label(100)]-10-[labelName]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[labelName(20)]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
            

            return cell
            
        case 2:
            textField.placeholder = dataRecord[3]
            cell.contentView.addSubview(textField)
            
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[label(100)]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-11-[label(20)]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
            
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[label(100)]-10-[textField]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-11-[textField(20)]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
            
            return cell
            
        case 3:
            labelName.text = dataRecord[4]
            
            cell.contentView.addSubview(labelName)
            
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[label(100)]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-11-[label(20)]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[label(100)]-10-[labelName]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[labelName(20)]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
            
            return cell
            
        default:
            textView.text = dataRecord[5]
            cell.contentView.addSubview(textView)
            
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[label(100)]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[label(20)]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[label(100)]-10-[textView]-20-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[textView]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
            
            return cell
        }
    }
}
// MARK: - UITableViewDelegate
extension dRDayDetailVC : UITableViewDelegate{
    
}
// MARK: - UINavigationControllerDelegate
extension dRDayDetailVC: UINavigationControllerDelegate {

}
// MARK: - UIImagePickerControllerDelegate
extension dRDayDetailVC : UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        dRDayDetailImageView.image = image
        picker.dismiss(animated: true, completion: {
            () -> Void in
        })
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        let stringBase64 = imageData?.base64EncodedString(options:NSData.Base64EncodingOptions(rawValue:0))
        base64pic = stringBase64
    }
}












