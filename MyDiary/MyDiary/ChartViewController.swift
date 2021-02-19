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
    
  
    // PieChart View
    @IBOutlet weak var pieChartView: PieChartView!
    
    // Variable to accumulate value
    var PositiveCNT = 0.0
    var NegativeCNT = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Find SQLite folder
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("MyDiaryData.sqlite") // 폴더 명
        
        // Open File
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK{
            
        }
        readValues()
        
        // Values of Chart
        let Emotion = ["Positive", "Negative"]
        let unitsSold = [PositiveCNT, NegativeCNT]
       
        setChart(dataPoints: Emotion, values: unitsSold)
    

    }
    
    func readValues() {

        // Select cCount Value
        let queryString = "SELECT cCount From Contents"
        var stmt : OpaquePointer?
        
        // Prepare SQLite3 With Error Sign
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            _ = String(cString: sqlite3_errmsg(db)!)
            return
        }
     
        // Checking in SQLite for Data
        while sqlite3_step(stmt) == SQLITE_ROW{
            
            // Convert to string and input
            let cCount = String(cString: sqlite3_column_text(stmt, 0))
            
            // Positive, Negative Count
                if cCount == "0"{
                    PositiveCNT += 1
                }else if cCount == "1"{
                    NegativeCNT += 1
                }
            }
        
        
        }
    
    // Setting For Chart
    func setChart(dataPoints: [String], values: [Double]) {
    
        // Put values in chart format
      var dataEntries: [ChartDataEntry] = []
      for i in 0..<dataPoints.count {
          let dataEntry1 = PieChartDataEntry(value: Double(values[i]*10), label: dataPoints[i], data:  dataPoints[i] as AnyObject)
        dataEntries.append(dataEntry1)
      }

        let pieChartDataSet = PieChartDataSet(entries: dataEntries)
                
      let pieChartData = PieChartData(dataSet: pieChartDataSet)
      pieChartView.data = pieChartData
       

      let Lengend = self.pieChartView.legend
        
        let formSize =  CGFloat.nan

        let legendEntry1 = LegendEntry(label: "Positive", form: .default, formSize: formSize, formLineWidth: .nan, formLineDashPhase: .nan, formLineDashLengths: .none, formColor: NSUIColor(displayP3Red: CGFloat(Double(245)/255), green: CGFloat(Double(200)/255), blue: CGFloat(Double(250)/255), alpha: 1))
        
        //set formSize, formLizeWidth, and formLineDashLengths to .nan to use default
        let legendEntry2 = LegendEntry(label: "Negative", form: .default, formSize: formSize, formLineWidth: .nan, formLineDashPhase: .nan, formLineDashLengths: .none, formColor: NSUIColor(displayP3Red: CGFloat(Double(175)/255), green: CGFloat(Double(212)/255), blue: CGFloat(Double(220)/255), alpha: 1))
        



        let customLegendEntries = [legendEntry1, legendEntry2]
        Lengend.setCustom(entries: customLegendEntries)
        Lengend.orientation = .horizontal
        Lengend.textColor = UIColor.black
        // l.font = myFonts.openSansRegular.of(size: 6)
        Lengend.font = NSUIFont.boldSystemFont(ofSize: 10)
      
        let NegativeCustomColor = UIColor(red: CGFloat(Double(175)/255), green: CGFloat(Double(212)/255), blue: CGFloat(Double(220)/255), alpha: 1)
        
        let PositiveCustomColor = UIColor(red: CGFloat(Double(245)/255), green: CGFloat(Double(200)/255), blue: CGFloat(Double(250)/255), alpha: 1)
        
        
        var colors: [UIColor] = []

        // Set Colors
        colors.append(PositiveCustomColor)
        colors.append(NegativeCustomColor)
        
        
        pieChartDataSet.colors = colors
    }
    


}
