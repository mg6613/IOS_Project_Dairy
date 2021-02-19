//
//  AddContentViewController.swift
//  autoLayout_Test02
//
//  Created by 이민우 on 2021/02/16.
//

import UIKit
import SQLite3

var selectedDate_AddContentView = ""
var selectedImage_AddContentView = ""
var selectedImageNum_AddContentView = 0

class AddContentViewController: UIViewController {

    @IBOutlet weak var lblSelectedDate: UILabel!
    @IBOutlet weak var imgSelectedImage: UIImageView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtViewContent: UITextView!
    
    var db : OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show date, image from previous views
        lblSelectedDate.text = selectedDate_AddContentView
        imgSelectedImage.image = UIImage(named: selectedImage_AddContentView)

        // Connect DB
        connectDB()
    }
    
    // Button for DB insert action
    @IBAction func btnInsert(_ sender: UIButton) {
       checkNil()
    }
    
    // Exception handling when if don't type anything
    func checkNil(){
        if txtTitle.text?.isEmpty == true || txtViewContent.text?.isEmpty == true{
            showAlert(value : 0)
        }else{
            insertAction()
        }
    }
    
    // DB insert action
    func insertAction(){
        var stmt : OpaquePointer?
        // 중요 (한글 문제 해결)
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        let cTitle = txtTitle.text!
        let cContent = txtViewContent.text!
        let cImageFileName = selectedImage_AddContentView
        let cInsertDate = selectedDate_AddContentView
        
        let queryString = "INSERT INTO contents (cTitle, cContent, cImageFileName, cInsertDate, cCount) VALUES (?, ?, ?, ?, ?)"
        
        // &stmt 에 ?에 대응하는 값을 넣어주면 된다
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert : \(errmsg)")
            showAlert(value: 2)
            return
        }
        
        // ?에 값을 넣는 것 (컬럼마다 if로 체크해주는 것이 좋다)
        if sqlite3_bind_text(stmt, 1, cTitle, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding Title : \(errmsg)")
            showAlert(value: 2)
            return
        }
        
        if sqlite3_bind_text(stmt, 2, cContent, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding Content : \(errmsg)")
            showAlert(value: 2)
            return
        }
        
        if sqlite3_bind_text(stmt, 3, cImageFileName, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding ImageFileName : \(errmsg)")
            showAlert(value: 2)
            return
        }
        
        if sqlite3_bind_text(stmt, 4, cInsertDate, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding InsertDate : \(errmsg)")
            showAlert(value: 2)
            return
        }
        
        if sqlite3_bind_text(stmt, 5, getcCount(), -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding InsertDate : \(errmsg)")
            showAlert(value: 2)
            return
        }
       
        
        // 실행하기 (잘 끝나지 않았으면 에러 출력)
        if sqlite3_step(stmt) != SQLITE_DONE{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting : \(errmsg)")
            return
        }
        
        showAlert(value: 1)
        
        print("Contents saved successfully")
        
    }
    
    // Show Alert
    func showAlert(value : Int){
        let alert : UIAlertController
        var okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {ACTION in
//            self.navigationController?.popToRootViewController(animated: true)
            self.navigationController?.popToRootViewController(animated: true)
        })

        if value == 0{
            alert = UIAlertController(title: "알림", message: "빈칸없이 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
            okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
        }else if value == 1{
            alert = UIAlertController(title: "등록 성공!", message: "글 등록이 완료되었습니다.", preferredStyle: UIAlertController.Style.alert)
        }else{
            alert = UIAlertController(title: "등록 실패!", message: "오류가 발생했습니다.", preferredStyle: UIAlertController.Style.alert)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // Connect DB(SQLite3)
    func connectDB(){
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("MyDiaryData.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK{
            print("error opening database")
        }
    }
    
    // Return cCount(DB Column)
    func getcCount() -> String{
        print("선택한 이미지 넘버 : \(selectedImageNum_AddContentView)")
        if selectedImageNum_AddContentView >= 1, selectedImageNum_AddContentView <= 5{
            return "0"
        }else{
            return "1"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }
    
    func viewDesign(){
        txtViewContent.layer.borderWidth = 2
        txtViewContent.layer.borderColor = UIColor.black.cgColor
    }

}
