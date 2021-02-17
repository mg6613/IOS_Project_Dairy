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
    
    // sqlite3
    var db: OpaquePointer?
    
    //var contentsList: [Contents] = [] // Students 타입, 빈에서 가져온걸 담는다
    var countList: [Int] = []
    var pieChart = PieChartView()
    
    // count를 받아와서 1과 0으로 나눈다
    // 1의 개수와 0의 갯수를 다시 센다
    // 그리고 1의 총 개수를 x1, 0의 총 개수를 x2
    
    // 긍정 값  = x1, 부정 값은 = x2
    
    var PositiveCNT = 0
    var NegativeCNT = 0
    
    // x1.count

    override func viewDidLoad() {
        super.viewDidLoad()
        pieChart.delegate = self
        
        // SQLite 생성하기
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("MyDiaryData.sqlite") // 폴더 명
        
        // 파일 열기
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK{
            print("error opening database")
        }
        
        readValues()

    }
    
    func readValues() {
        //contentsList.removeAll()
        
        let queryString = "SELECT cCount From Contents"
        var stmt : OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)") // 입력시 에러
            return
        }
        
        // 현재 날짜 2021-02-17  --> 현재 달 == 02
        // WHERE 2021-\(현재 달)
        
        while sqlite3_step(stmt) == SQLITE_ROW{ // SQLITE_ROW 읽어올 데이터가 있는지 확인
            let cCount = String(cString: sqlite3_column_text(stmt, 0)) // 스트링으로 변환해서 넣어준다
            
            // Positive, Negative Count
            print("차트 Count \(cCount)")
                if cCount == "0"{
                    PositiveCNT += 1
                }else if cCount == "1"{
                    NegativeCNT += 1
                }
            //print("Positive === \(PositiveCNT)")
            //print("countList ======  \(countList.append(contentsOf: [pCNT, nCNT]))")
//            print("PCNT = \(countList.popLast())")
            }
        
        
        print(PositiveCNT)
        print(NegativeCNT)
        print("countList \(countList.count - 1)")
        
        }
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        pieChart.frame = CGRect(x: 0, y: 0,
                                                    width: self.view.frame.size.width,
                                                    height: self.view.frame.size.width)
        pieChart.center = view.center
        view.addSubview(pieChart)
        
        var entries = [ChartDataEntry]()
        
        print("Entries ==  \(entries)")
        let temp = [PositiveCNT,NegativeCNT]
        
        for i in 0..<2 {
            
            entries.append(ChartDataEntry(x: Double(i),
                                          y: Double(temp[i])))
        }
        
        let set = PieChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.joyful()
        
        
        
        let data = PieChartData(dataSet: set)
        pieChart.data = data
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getDocumentDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }


}
