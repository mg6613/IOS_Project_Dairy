//
//  SettingTableViewController.swift
//  autoLayout_Test02
//
//  Created by MinWoo Lee on 2021/02/17.
//

import UIKit

class SettingTableViewController: UITableViewController {

    @IBOutlet var listTableView: UITableView!
    
    // Items to be listed
    var datas = ["비밀번호 설정", "공유하기", "백업하기", "개발자에게"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = datas[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0 : performSegue(withIdentifier: "moveSettingPassword", sender: self)
        case 1:
            showAlert(title: "준비중", message: "준비중인 기능입니다.")
        case 2:
            showAlert(title: "준비중", message: "준비중인 기능입니다.")
        default:
            showAlert(title: "개발자에게", message: "문의사항 : tnctis21@naver.com")
        }
        
    }
    
    // Show alert
    func showAlert(title : String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

