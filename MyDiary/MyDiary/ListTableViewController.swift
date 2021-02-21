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
        
            // Cell custom. Cell height
            listTableView.rowHeight = 100
        
        }
    
    // DB select action
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
      
            ContentsList.append(ListContents(cTitle: String(describing: title), cInsertDate: String(describing: insertdate), cImageFileName: String(describing: imgfilename))
            )}
        
        self.listTableView.reloadData()
        }
    
    
    // Reload Data
    override func viewWillAppear(_ animated: Bool) {
        readValues()
    }
    
    // number Of Sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // ContentsList count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContentsList.count
    }
    
    // connect mycell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TableViewCell

        let contents: ListContents
        contents = ContentsList[indexPath.row]

        cell.lblCellTitle?.text = "\(contents.cTitle!)"
        cell.lblCellDate?.text = "\(contents.cInsertDate!)" 
        cell.imgCell?.image = UIImage(named: changeImageName(beforename : contents.cImageFileName!))

            return cell
        }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveDetail"{
            let cell = sender as! UITableViewCell
            let indexPath = self.listTableView.indexPath(for: cell)
            let item: ListContents = ContentsList[indexPath!.row]
            let cinsertdate = item.cInsertDate!
            strDate = cinsertdate
        }
    }
    
    // Change imagefilename for show on calendar
    func changeImageName(beforename : String) -> String{
        switch beforename{
        case "beige.png":
            return "list_beige.png"
        case "deepgray.png":
            return "list_deepgray.png"
        case "green.png":
            return "list_green.png"
        case "deepPurple.png":
            return "list_deepPurple.png"
        case "liteblue.png":
            return "list_liteblue.png"
        case "yellow.png":
            return "list_yellow.png"
        case "purple.png":
            return "list_purple.png"
        case "pink2.png":
            return "list_pink2.png"
        case "deepRed.png":
            return "list_deepRed.png"
        case "laidgray.png":
            return "list_laidgray.png"
        case "orange.png":
            return "list_orange.png"
        case "navy.png":
            return "list_navy.png"
        default:
            return ""
        }
    }
    
}
