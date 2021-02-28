//
//  PasswordViewController.swift
//  MyDiary
//
//  Created by MinWoo Lee on 2021/02/18.
//

import UIKit

class PasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var swOnOff: UISwitch!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var btnUpdate: UIButton!
    
    // Store when user input password
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtPassword.delegate = self
        
        checkSwitchValue()
        constraintSwitch()
    }
    
    override func viewWillAppear(_ animated: Bool) {        
        checkSwitchValue()
        constraintSwitch()
    }

    // Switch for using password lock
    @IBAction func swChangeOnOff(_ sender: UISwitch) {
        constraintSwitch()
    }
    
    // Button when change password
    @IBAction func btnUpdatePassword(_ sender: UIButton) {
        checkPassword()
    }
    
    // to limit minimum and maximum input characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
     
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
     
        return updatedText.count <= 8
    }
    
    // Lower keyboard when click outside click
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
    }
    
    // Exception handling for incorrect password
    func checkPassword(){
        var alert = UIAlertController(title: "알림", message: "비밀번호를 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
        var okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
        
        if txtPassword.text!.isEmpty == true{
            
        }else if txtPassword.text!.count >= 4 && txtPassword.text!.count <= 8{
            if UserDefaults.standard.string(forKey: "password") != nil{
                alert = UIAlertController(title: "알림", message: "비밀번호가 수정되었습니다.", preferredStyle: UIAlertController.Style.alert)
            }else{
                alert = UIAlertController(title: "알림", message: "비밀번호가 설정되었습니다.", preferredStyle: UIAlertController.Style.alert)
                UserDefaults.standard.set("true", forKey: "switchValue")
            }
            okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {ACTION in
                self.navigationController?.popViewController(animated: true)
            })
            UserDefaults.standard.set(self.txtPassword.text!, forKey: "password")
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // For constraint when on and off switch
    func constraintSwitch(){
        if swOnOff.isOn == false{
            UserDefaults.standard.set("false", forKey: "switchValue")
            txtPassword.isEnabled = false
            btnUpdate.isEnabled = false
            lblText.text = "비밀번호 OFF"
        }else{
            if UserDefaults.standard.string(forKey: "password") != nil {
                print("비밀번호 설정 하고 스위치 ON!")
                UserDefaults.standard.set("true", forKey: "switchValue")
                txtPassword.isEnabled = true
                btnUpdate.isEnabled = true
                lblText.text = "비밀번호 ON"
            }else{
                print("비밀번호 설정 안하고 스위치 ON!")
                txtPassword.isEnabled = true
                btnUpdate.isEnabled = true
                lblText.text = "비밀번호를 입력해주세요\n(4자리 ~ 8자리)"
                
            }
        }
    }
    
    // Check value when switch on and off
    func checkSwitchValue(){
        
        if let switchValue = UserDefaults.standard.string(forKey: "switchValue"){
            
            if switchValue == "true"{
                
                swOnOff.isOn = true
            }else{
                
                swOnOff.isOn = false
            }
        }
    }
}
