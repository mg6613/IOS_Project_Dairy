//
//  ListTableViewController.swift
//  MyDiary
//
//  Created by 유민규 on 2021/02/18.
//

import UIKit
import SQLite3

var ListDateYear = ""
var ListDateMonth = ""
var ListDateYM = ""
var itemsImageFile = [String]()
class ListTableViewController: UITableViewController {


    @IBOutlet weak var lblYearMonth: UILabel!
    @IBOutlet var listTableView: UITableView!
    
    // sqlite3
    var db: OpaquePointer?
    // ListContents type, containing what was brought from Models
    var ContentsList: [ListContents] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create SQLite
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("MyDiaryData.sqlite") // SQLite Folder Name
            
            // Open File
            if sqlite3_open(fileURL.path, &db) != SQLITE_OK{
                print("error opening database")
            }
        
        lblYearMonth.text = "\(ListDateYear)년 \(ListDateMonth)월"
            listTableView.rowHeight = 100
        
        print("값 확인 : \(ListDateYM)")

        } // ================================== viewDidLoad
    
    
    
    // ==================================================  Select
    func readValues() {
        ContentsList.removeAll()
        
       
        let queryString = "Select cTitle, cInsertDate, cImageFileName From contents where cInsertDate like '\(ListDateYM)%' order by cInsertDate desc"
        var stmt : OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)") // Error Check
            return
        }
        
        while sqlite3_step(stmt) == SQLITE_ROW{ // SQLITE_ROW Checks whether there is data to be read
           
            let title = String(cString: sqlite3_column_text(stmt, 0)) // Convert it to a string and put it in
            let insertdate = String(cString: sqlite3_column_text(stmt, 1))
            let imgfilename = String(cString: sqlite3_column_text(stmt, 2))
            
            print(title)
            ContentsList.append(ListContents(cTitle: String(describing: title), cInsertDate: String(describing: insertdate), cImageFileName: String(describing: imgfilename))
            )}
        
        self.listTableView.reloadData()
        }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        readValues() // readValues 해주면 self.tvListView.reloadData()로 다시 데이터값을 불러올 수 있다
        // tvListView.reloadData()
    }
    
   
    // 테이블 반복 횟수
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // studentsList의 값만큼 보여준다
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContentsList.count
    }
    
    // mycell이랑 연결 해준다
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TableViewCell

            // Configure the cell...
            let contents: ListContents  // Students는 class. studentsList에 class타입으로 들어있기 때문에 정의해줌
        contents = ContentsList[indexPath.row]

            // Title과 subTitle은 변수명이 정해져있음
//        cell.imgCell
        cell.lblCellTitle?.text = "\(contents.cTitle!)"
        cell.lblCellDate?.text = "\(contents.cInsertDate!)" 
        cell.imgCell?.image = UIImage(named: contents.cImageFileName!)

            return cell
        }
        
        // Temporary Insert
        // tempInsert()
        // Table 내용 불러오기
        //readValues()
        
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveDetail"{
            let cell = sender as! UITableViewCell
            let indexPath = self.listTableView.indexPath(for: cell)
//            let detailView = segue.destination as! DetailViewController
            let item: ListContents = ContentsList[indexPath!.row]
            
            let cinsertdate = item.cInsertDate!
            strDate = cinsertdate
            print("detail넘기는 날짜 확인 : \(strDate)")
        }
    }
    

}
