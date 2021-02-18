//
//  DetailViewController.swift
//  autoLayout_Test02
//
//  Created by 이민우 on 2021/02/17.
//

import UIKit

// test values
var strDate = ""
var strTitle = ""
var strContent = ""

class DetailViewController: UIViewController {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtViewContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // test setting
        strDate = "2021-02-01"
        
        lblDate.text = strDate
        txtTitle.text = strTitle
        txtViewContent.text = strContent

    }
    
    @IBAction func btnUpdate(_ sender: UIButton) {
        
    }
    @IBAction func btnDelete(_ sender: UIButton) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
