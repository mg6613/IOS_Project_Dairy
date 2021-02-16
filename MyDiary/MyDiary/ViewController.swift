//
//  ViewController.swift
//  autoLayout_Test02
//
//  Created by 이민우 on 2021/02/16.
//

import UIKit
import FSCalendar

class ViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    @IBOutlet weak var myCalendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // FSCalendar 연결
        myCalendar.delegate = self
        myCalendar.dataSource = self
        
    }
    
    @IBAction func btnPreview(_ sender: UIButton) {
        
    }
    @IBAction func btnNext(_ sender: UIButton) {
        
    }
    
    @IBAction func btnNew(_ sender: UIButton) {
        self.performSegue(withIdentifier: "moveSelectEmo", sender: self)
    }
    
    // 선택 날짜
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.performSegue(withIdentifier: "moveList", sender: self)
        
        
    }
    
}

