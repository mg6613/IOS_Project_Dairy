//
//  DetailViewController.swift
//  autoLayout_Test02
//
//  Created by 이민우 on 2021/02/17.
//

import UIKit
import SQLite3

// test values
var strDate = ""
var imageNum_DetailView = 1
var imageName_DetailView = ""
var whereValue = 0

class DetailViewController: UIViewController{

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtViewContent: UITextView!
    @IBOutlet weak var imgEmotion: UIImageView!
    
    // For connect SQLite3
    var db : OpaquePointer?
    
    // For use timer
    let timeSelector : Selector = #selector(DetailViewController.autoSave)
    
    // Time interval of timer
    let interval = 60.0
    
    // Declaration for use timer
    var mTimer : Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set GestureRecognizer each imageviews
        setGestureRecognizer()
        
        viewDesign()

        lblDate.text = strDate
        
        connectDB()
        readValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        mTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: timeSelector, userInfo: nil, repeats: true)

        if whereValue == 1{
            imgEmotion.image = UIImage(named: imageName_DetailView)
            print("이미지 ?? : \(imageName_DetailView)")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        mTimer?.invalidate()
    }

    // Button for db update action
    @IBAction func btnUpdate(_ sender: UIButton) {
        checkNil()
    }
    
    // Button for db delete action
    @IBAction func btnDelete(_ sender: UIButton) {
        print("선택한 이미지 넘버 : \(imageNum_DetailView)")
        
        showAlert(title: "삭제 확인", message: "정말로 삭제하시겠습니까?")
    }
    
    // Connect DB(SQLite3)
    func connectDB(){
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("MyDiaryData.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK{
            print("error opening database")
        }
    }
    
    // DB update action
    func updateAction(value : Int){

        var stmt : OpaquePointer?
        // 중요 (한글 문제 해결)
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        let cTitle = txtTitle.text!
        let cContent = txtViewContent.text!
        print("cContent = \(cContent)")
        
        let queryString = "UPDATE contents set cTitle = ?, cContent = ?, cImageFileName = ?, cUpdateDate = ?, cCount = ? WHERE cInsertDate = ?"
            
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing update : \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 1, cTitle, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding Title : \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 2, cContent, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding Content : \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 3, imageName_DetailView, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding UpdateDate : \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 4, getCurrentTime(), -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding UpdateDate : \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 5, getcCount(), -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding InsertDate : \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 6, strDate
                             , -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding InsertDate : \(errmsg)")
            return
        }

        print("제목 : \(cTitle)")
        print("내용 : \(cContent)")
        print("업데이트 날짜 : \(getCurrentTime())")
        print("Insert Date : \(strDate)")
        
        if sqlite3_step(stmt) != SQLITE_DONE{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure updating : \(errmsg)")
            showAlert(title: "오류 발생", message: "글 수정 중 오류가 발생했습니다.")
            return
        }

        if value == 0{
            showAlert(title: "글 저장 성공", message: "글 저장이 완료되었습니다.")
        }else{
            showToast()
        }
    }
    
    // DB update action
    func deleteAction(){

        var stmt : OpaquePointer?
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

        let queryString = "DELETE FROM contents WHERE cInsertDate = ?"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing delete : \(errmsg)")
            return
        }
        
       
        if sqlite3_bind_text(stmt, 1, strDate, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding InsertDate : \(errmsg)")
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure deleting : \(errmsg)")
            showAlert(title: "오류 발생", message: "글 삭제 중 오류가 발생했습니다.")
            return
        }
    }
    
    // DB select action
    func readValues(){
        var cTitle = ""
        var cContent = ""
        var cImageFileName = ""

        var stmt : OpaquePointer?
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

        let queryString = "SELECT * FROM contents WHERE cInsertDate = ?"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing delete : \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 1, strDate, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding InsertDate : \(errmsg)")
            return
        }
        
        
        while sqlite3_step(stmt) == SQLITE_ROW{
            cTitle = String(cString: sqlite3_column_text(stmt, 1))
            cContent = String(cString: sqlite3_column_text(stmt, 2))
            cImageFileName = String(cString: sqlite3_column_text(stmt, 3))
            
            print("DB에서 불러온 제목 : \(cTitle)")
            print("DB에서 불러온 내용 : \(cContent)")
            print("DB에서 불러온 사진 : \(cImageFileName)")
            imageName_DetailView = cImageFileName
        }
        
        txtTitle.text = cTitle
        txtViewContent.text = cContent
        imgEmotion.image = UIImage(named: cImageFileName)
        

        print("이미지 ?? : \(cImageFileName)")
    }
    
    // Alert Function
    func showAlert(title : String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        var okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: nil)

        if title == "삭제 확인"{
            okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.destructive, handler: { [self]ACTION in
                deleteAction()
                self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(cancelAction)
        }
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // Exception handling when if don't type anything
    func checkNil(){
        if txtTitle.text?.isEmpty == true || txtViewContent.text?.isEmpty == true{
            showAlert(title: "알림", message: "제목과 내용을 빈칸없이 입력해주세요.")
        }else{
            updateAction(value : 0)
        }
    }
    
    // Function when using timer
    @objc func autoSave(){
        updateAction(value : 1)
    }
    
    // Check current time when db update action
    func getCurrentTime() -> String{
        let date = NSDate()
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "yyyy-MM-dd EEE a hh:mm:ss"
        
        print("현재시간 : \(formatter.string(from: date as Date))")

        return formatter.string(from: date as Date)
    }
    
    // Design view
    func viewDesign(){
        txtViewContent.layer.borderWidth = 2
        txtViewContent.layer.borderColor = UIColor.black.cgColor
    }

    // Lower keyboard when click outside click
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }
    
    // Set GestureRecognizer each buttons
    func setGestureRecognizer(){
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        imgEmotion.isUserInteractionEnabled = true
        imgEmotion.addGestureRecognizer(tapGR)
    }
    
    // When touch imgEmotion
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "moveChangeEmotion", sender: self)
    }
    
    // Return cCount(DB Column)
    func getcCount() -> String{
        print("선택한 이미지 넘버 : \(imageNum_DetailView)")
        if imageNum_DetailView >= 1, imageNum_DetailView <= 5{
            return "0"
        }else{
            return "1"
        }
    }
    
    // Show toast message when complete autosave
    func showToast(){
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.boldSystemFont(ofSize: 14)
        toastLabel.textAlignment = .center
        toastLabel.text = "자동으로 저장되었습니다."
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: { toastLabel.alpha = 0.0 }, completion: {(isCompleted) in toastLabel.removeFromSuperview() })
    }
}
