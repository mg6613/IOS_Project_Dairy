//
//  ChartViewController.swift
//  MyDiary
//
//  Created by MinGyu Yoo on 2021/02/17.
//

import UIKit
import Charts
import SQLite3

class ChartViewController: UIViewController, ChartViewDelegate {
    
    // ======================  sqlite3
    var db: OpaquePointer?
    
    var countList: [Int] = []
  
    @IBOutlet weak var pieChartView: PieChartView!
    var PositiveCNT = 0.0
    var NegativeCNT = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // SQLite 생성하기
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("MyDiaryData.sqlite") // 폴더 명
        
        // 파일 열기
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK{
            print("error opening database")
        }
        readValues()
        
        // Values of Chart
        let Emotion = ["Positive", "Negative"]
        print("\(Emotion)")
        let unitsSold = [PositiveCNT, NegativeCNT]
        print("\(unitsSold)")
        setChart(dataPoints: Emotion, values: unitsSold)
    

    }
    
    func readValues() {
        //contentsList.removeAll()
        print("readValues in()")
        let queryString = "SELECT cCount From Contents"
        var stmt : OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)") // 입력시 에러
            return
        }
     
        while sqlite3_step(stmt) == SQLITE_ROW{ // SQLITE_ROW 읽어올 데이터가 있는지 확인
            let cCount = String(cString: sqlite3_column_text(stmt, 0)) // 스트링으로 변환해서 넣어준다
            
            // Positive, Negative Count
            print("차트 Count \(cCount)")
                if cCount == "0"{
                    PositiveCNT += 1
                }else if cCount == "1"{
                    NegativeCNT += 1
                }
            }
        
        print(PositiveCNT)
        print(NegativeCNT)
        //print("countList \(countList.count - 1)")
        
        }
    
    func setChart(dataPoints: [String], values: [Double]) {
      var dataEntries: [ChartDataEntry] = []
      for i in 0..<dataPoints.count {
          let dataEntry1 = PieChartDataEntry(value: Double(values[i]*10), label: dataPoints[i], data:  dataPoints[i] as AnyObject)
        dataEntries.append(dataEntry1)
      }
      print(dataEntries[0].data as Any)
      let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "Units Sold")
      let pieChartData = PieChartData(dataSet: pieChartDataSet)
      pieChartView.data = pieChartData
      
      var colors: [UIColor] = []
      
      for _ in 0..<dataPoints.count {
        let red = Double(arc4random_uniform(256))
        let green = Double(arc4random_uniform(256))
        let blue = Double(arc4random_uniform(256))
          
        let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        colors.append(color)
      }
      pieChartDataSet.colors = colors
    }


}
