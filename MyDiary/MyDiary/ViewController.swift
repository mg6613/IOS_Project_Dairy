//
//  ViewController.swift
//  autoLayout_Test02
//
//  Created by 이민우 on 2021/02/16.
//

import UIKit
import FSCalendar
import SQLite3

var test = 0

@IBDesignable
class ViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    @IBOutlet weak var myCalendar: FSCalendar!
    @IBOutlet weak var btnPreviewOutlet: UIButton!
    @IBOutlet weak var btnNextOutlet: UIButton!
    
    // For Connect SQLite3
    var db : OpaquePointer?
    
//    var eventDateList : [Contents] = []
    
    // Variable for save selected date
    var selectDate = ""
    
    // Variable for check current date
    var current_date_string = ""
    
    // 현재 날짜 (currentPage)
    var currentPageDate = ""
    
    // For DateFormatter
    let dateFormatter = DateFormatter()
    
    // 이벤트 추가할 날짜 배열(글 등록한 날을 저장해야할 듯)
    var eventDates = [Date]()
    
    // Variables for func called moveCurrentPage
    private var currentPage: Date?
    private lazy var today: Date = {
        return Date()
    }()
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Calendar design
        calendarDesign()
        
        // Block move next month on first loaded view
        btnNextOutlet.isHidden = true
        
        // Connect FSCalendar
        myCalendar.delegate = self
        myCalendar.dataSource = self

        // For get current date
        dateFormatter.dateFormat = "YYYY-MM-dd"
        current_date_string = dateFormatter.string(from: Date())
        print("초기 날짜 : \(Date())")
        
        // For when use button with other buttons on same view
        view.addSubview(myCalendar)
        myCalendar.addSubview(btnPreviewOutlet)
        myCalendar.addSubview(btnNextOutlet)
        
        // Create SQLite DB
        createSQLite()
        
        // DB select action
        readValues()

        // Check path of simulator
        print(self.getDocumentDirectory())
        
        myCalendar.register(FSCalendarCell.self, forCellReuseIdentifier: "CELL")
    }
    
    // Reload data when back from other view
    override func viewWillAppear(_ animated: Bool) {
        // DB select action
        print("viewWillAppear")
        myCalendar.reloadData()

        // DB select action
        readValues()
        
        // Connect FSCalendar
        myCalendar.delegate = self
        myCalendar.dataSource = self
    }
    
    
    @IBAction func openChart(_ sender: UIBarButtonItem) {
        let chartViewController = ChartViewController(nibName: "ChartViewController", bundle: nil)
        present(chartViewController, animated: true)
    }
    
    
    // Button for move to last month on Calendar
    @IBAction func btnLastMonth(_ sender: UIButton) {
        btnNextOutlet.isHidden = false
        self.moveCurrentPage(moveUp: false)
    }
    
    // Button for move to next month on Calendar
    @IBAction func btnNextMonth(_ sender: UIButton) {
        cantMoveNextMonth()
    }
    
    // Button for move to SelectEmotionViewController
    @IBAction func btnNew(_ sender: UIButton) {
        // Exception handling when if don't select any date
        if selectDate == ""{
            // Show alert
            let shouldSelectAlert = UIAlertController(title: "", message: "날짜를 선택해주세요.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "네, 알겠습니다.", style: UIAlertAction.Style.destructive, handler: nil)

            shouldSelectAlert.addAction(onAction)
            present(shouldSelectAlert, animated: true, completion: nil) // alert실행
        }else{
            // Move to next view
            selectDate_EmotionView = selectDate
            self.performSegue(withIdentifier: "moveSelectEmo", sender: self)
        }
        
    }

    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell: FSCalendarCell = calendar.dequeueReusableCell(withIdentifier: "CELL", for: date, at: position)
        let dateFromStringFormatter = DateFormatter();
        dateFromStringFormatter.dateFormat = "YYYY-MM-dd";
        let calendarDate = dateFromStringFormatter.string(from: date)
        
        // Disable date is string Array of Dates
        if self.eventDates.contains(date){
            print("여기여기여기")
            cell.isUserInteractionEnabled = false;
        }
        
        print("CELL : \(cell.isUserInteractionEnabled), DATE : \(calendarDate)")
        return cell
    }
    
    
    
    // Func for Calendar Design
    func calendarDesign(){
        // Remove placeholder
        myCalendar.placeholderType = .none
        
        // Backgroud color
//        myCalendar.backgroundColor = UIColor(red: 241/255, green: 249/255, blue: 255/255, alpha: 1)
        
        // Click date color
        myCalendar.appearance.selectionColor = UIColor(red: 38/255, green: 153/255, blue: 251/255, alpha: 1)
        
        // Today date color
//        myCalendar.appearance.todayColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        // Allow multiple selection
//        myCalendar.allowsMultipleSelection = true
        
        // Allow multiple swipe
//        myCalendar.swipeToChooseGesture.isEnabled = true
        
        // Allow scroll
        myCalendar.scrollEnabled = true
        
        // Set scroll direction of calnedar
//        myCalendar.scrollDirection = .vertical
        
        // Set border radious of clicked date
        myCalendar.appearance.borderRadius = 1
        
        // Set color of weekday
        myCalendar.appearance.titleDefaultColor = .black

        // Set color of weekend
        myCalendar.appearance.titleWeekendColor = .red

        // Set color title of year and month
        myCalendar.appearance.headerTitleColor = .systemPink

        // Set color weekday text
        myCalendar.appearance.weekdayTextColor = .orange
        
        // Set color title
        myCalendar.appearance.titleSelectionColor = .black
        
        // Set color subtitle
        myCalendar.appearance.subtitleSelectionColor = .black
        
        // Change header dateformat to Korea
        myCalendar.appearance.headerDateFormat = "YYYY년 M월"

        // First way to can change text of day of the week
        myCalendar.locale = Locale(identifier: "ko_KR")
                
        // Second way to can change text of day of the week
        myCalendar.calendarWeekdayView.weekdayLabels[0].text = "일"
        myCalendar.calendarWeekdayView.weekdayLabels[1].text = "월"
        myCalendar.calendarWeekdayView.weekdayLabels[2].text = "화"
        myCalendar.calendarWeekdayView.weekdayLabels[3].text = "수"
        myCalendar.calendarWeekdayView.weekdayLabels[4].text = "목"
        myCalendar.calendarWeekdayView.weekdayLabels[5].text = "금"
        myCalendar.calendarWeekdayView.weekdayLabels[6].text = "토"
        
        // Remove placeholder on calnedar
        myCalendar.appearance.headerMinimumDissolvedAlpha = 0

    }
    
    // When click a date
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        dateFormatter.dateFormat = "YYYY-MM-dd"
        selectDate = dateFormatter.string(from: date)
        print(dateFormatter.string(from: date) + " 선택됨")
        print(selectDate)
        
        // When the date is registered
        if self.eventDates.contains(date){
            self.performSegue(withIdentifier: "moveList", sender: self)
        }
    }
    
    // When uncheck date
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectDate = ""
    }
    
    // Image output instead of date
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        
        if self.eventDates.contains(date){
            print("데이트 타입 확인 : \(type(of: date))")
            print("날짜 : \(date)")

            return UIImage(named: "reresize.png")
        }
        return nil
    }
    
    // Maximum number of dates available
//    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
//            // 날짜 3개까지만 선택되도록
//            if calendar.selectedDates.count > 0 {
//                return false
//            } else {
//                return true
//            }
//    }
    
    // Can select date until today
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    // When move last mont or next month on calendar
    func moveCurrentPage(moveUp: Bool) {
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = moveUp ? 1 : -1 // If value is true then return 1 else return -1
        
        self.currentPage = calendar.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
        self.myCalendar.setCurrentPage(self.currentPage!, animated: true)
        
        currentPageDate = dateFormatter.string(from: currentPage!)
    }
    
    // Current monthly moving limit function for months
    func cantMoveNextMonth(){
        
        // Save current page on calendar
        let varDate = Int(String(currentPageDate.split(separator: "-")[0]) + String(currentPageDate.split(separator: "-")[1]))
        // Save current date on IOS
        let pixedDate = Int(String(current_date_string.split(separator: "-")[0]) + String(current_date_string.split(separator: "-")[1]))

        self.moveCurrentPage(moveUp: true)
        
        // Compare by varDate + 1 because the button must be hidden after pressing the button
        if (varDate! + 1) == pixedDate!{
            btnNextOutlet.isHidden = true
        }else{
            btnNextOutlet.isHidden = false
        }
    }
    
    // Create SQLite DB
    func createSQLite(){
        // SQLite 생성하기
          let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("MyDiaryData.sqlite")
          
          if sqlite3_open(fileURL.path, &db) != SQLITE_OK{
              print("error opening database")
          }
          
          // 테이블 없으면 만들고 있으면 패스
          if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS contents (cId INTEGER PRIMARY KEY AUTOINCREMENT, cTitle TEXT, cContent TEXT, cImageFileName TEXT, cInsertDate TEXT, cUpdateDate TEXT, cDeleteDate TEXT, cCount TEXT)", nil, nil, nil) != SQLITE_OK{
              let errmsg = String(cString: sqlite3_errmsg(db)!)
              print("error creating table : \(errmsg)")
          }
        
        print("sqlite 생성완료")
    }
    
    // DB SELECT Action
    func readValues(){
        let queryString = "SELECT * FROM contents"
        var stmt : OpaquePointer?
        
        // &stmt 에 ?에 대응하는 값을 넣어주면 된다
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select : \(errmsg)")
            return
        }
        
        // 읽어올 행이 있으면 데이터 가져오기
        while sqlite3_step(stmt) == SQLITE_ROW{
            let cInsertDate = String(cString: sqlite3_column_text(stmt, 4))
            
            print("DB에서 불러온 날짜 : \(cInsertDate)")
            
            eventDates.append(dateFormatter.date(from: cInsertDate)!)

        }
        print("eventDates : \(eventDates)")
        print("readValues()확인")
    }
    
    // Find to simulator path
    func getDocumentDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
