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

class DetailViewController: UIViewController {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtViewContent: UITextView!
    @IBOutlet weak var imgEmotion: UIImageView!
    
    var db : OpaquePointer?
    
    let timeSelector : Selector = #selector(DetailViewController.updateTime) // 현재 ViewController에 있는 updateTime이라는 함수를 이용!
    let interval = 1.0 // 시간 interval 1초

    var currentTime = ""
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
        print("선택한 이미지 넘버 : \(imageNum_DetailView)")
    }
    
    
    
    @IBAction func btnUpdate(_ sender: UIButton) {
        checkNil()
    }
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
    func updateAction(){

        var stmt : OpaquePointer?
        // 중요 (한글 문제 해결)
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        let cTitle = txtTitle.text!
        let cContent = txtViewContent.text!
        print("cContent = \(cContent)")
        
        let queryString = "UPDATE contents set cTitle = ?, cContent = ?, cImageFileName = ?, cUpdateDate = ?, cCount = ? WHERE cInsertDate = ?"
        
//        let queryString = "UPDATE contents set cTitle = ?, cContent = ?, cImageFileName = ?, cCount = ? WHERE cInsertDate = ?"
        
        // &stmt 에 ?에 대응하는 값을 넣어주면 된다
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing update : \(errmsg)")
            return
        }
        
        // ?에 값을 넣는 것 (컬럼마다 if로 체크해주는 것이 좋다)
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
        
        if sqlite3_bind_text(stmt, 3, "heart.png", -1, SQLITE_TRANSIENT) != SQLITE_OK{
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
        
        // 실행하기 (잘 끝나지 않았으면 에러 출력)
        if sqlite3_step(stmt) != SQLITE_DONE{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure updating : \(errmsg)")
            showAlert(title: "오류 발생", message: "글 수정 중 오류가 발생했습니다.")
            return
        }

        showAlert(title: "글 저장 성공", message: "글 저장이 완료되었습니다.")
    }
    
    // DB update action
    func deleteAction(){

        var stmt : OpaquePointer?
        // 중요 (한글 문제 해결)
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

        let queryString = "DELETE FROM contents WHERE cInsertDate = ?"
        
        // &stmt 에 ?에 대응하는 값을 넣어주면 된다
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
        
        // 실행하기 (잘 끝나지 않았으면 에러 출력)
        if sqlite3_step(stmt) != SQLITE_DONE{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure deleting : \(errmsg)")
            showAlert(title: "오류 발생", message: "글 삭제 중 오류가 발생했습니다.")
            return
        }

        showAlert(title: "글 삭제 성공", message: "글 삭제가 완료되었습니다.")

    }
    
    // DB select action
    func readValues(){
        var cTitle = ""
        var cContent = ""
        var cImageFileName = ""
        
        var stmt : OpaquePointer?
        // 중요 (한글 문제 해결)
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

        let queryString = "SELECT * FROM contents WHERE cInsertDate = ?"
        
        // &stmt 에 ?에 대응하는 값을 넣어주면 된다
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

        }
        
        txtTitle.text = cTitle
        txtViewContent.text = cContent
        imgEmotion.image = UIImage(named: "heart.png")
    }
    
    // Alert Function
    func showAlert(title : String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        var okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
        
        
        if title != "알림"{
            okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {ACTION in
            })
        }
        
        if title == "삭제 확인"{
            okAction = UIAlertAction(title: "삭제", style: UIAlertAction.Style.default, handler: { [self]ACTION in
                deleteAction()
            })
            let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(cancelAction)
        }
        
        if title == "글 삭제 성공"{
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Exception handling when if don't type anything
    func checkNil(){
        if txtTitle.text?.isEmpty == true || txtViewContent.text?.isEmpty == true{
            showAlert(title: "알림", message: "제목과 내용을 빈칸없이 입력해주세요.")
        }else{
            updateAction()
        }
    }
    
    // Async Task로 1초당 1번씩 구동
    // objc 타입으로 func을 생성
    @objc func updateTime(){
       
    }
    
    func getCurrentTime() -> String{
        let date = NSDate() // NS : Next Step // OS로 부터 Date를 가져오는 것
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "ko") // 한국 지역에 맞추기
        formatter.dateFormat = "yyyy-MM-dd EEE a hh:mm:ss"
        
        print("현재시간 : \(formatter.string(from: date as Date))")

        return formatter.string(from: date as Date)
    }
    
    func viewDesign(){
        txtViewContent.layer.borderWidth = 2
        txtViewContent.layer.borderColor = UIColor.black.cgColor
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }
    
    // Set GestureRecognizer each buttons
    func setGestureRecognizer(){
        
        imgEmotion.isUserInteractionEnabled = true
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        imgEmotion.addGestureRecognizer(tapGR)
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        print("imageTapped")
        let vcName = self.storyboard?.instantiateViewController(withIdentifier: "ChangeEmotionView")
        vcName?.modalPresentationStyle = .formSheet

        self.present(vcName!, animated: true, completion: nil)
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
    
    public func changeImage(){
        imgEmotion.image = UIImage(named: imageName_DetailView)
    }
}
