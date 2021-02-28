//
//  SelectEmotionViewController.swift
//  autoLayout_Test02
//
//  Created by MinWoo Lee on 2021/02/16.
//

import UIKit

// Variable for get selected date from previous view
var selectDate_EmotionView = ""

class SelectEmotionViewController: UIViewController {

    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    @IBOutlet weak var image6: UIImageView!
    @IBOutlet weak var image7: UIImageView!
    @IBOutlet weak var image8: UIImageView!
    @IBOutlet weak var image9: UIImageView!
    @IBOutlet weak var image10: UIImageView!
    @IBOutlet weak var image11: UIImageView!
    @IBOutlet weak var image12: UIImageView!
    @IBOutlet weak var lblEmotion: UILabel!

    // Variable for next view
    var clickImageName = "yellow.png"
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        // Store text change NSMutableAttributedString Type
        let attributedStr = NSMutableAttributedString(string: lblEmotion.text!)

        attributedStr.addAttribute(.foregroundColor, value: UIColor.black, range: (lblEmotion.text! as NSString).range(of: "느낌"))
        
        lblEmotion.attributedText = attributedStr
        
        // If don't select any image, image1 will selected
        clickImageOnlyOne(image: image1)
        
        // Set GestureRecognizer each imageviews
        setGestureRecognizer()
    }
    
    // Move next view
    @IBAction func btnSelectDone(_ sender: UIButton) {
        selectedDate_AddContentView = selectDate_EmotionView
        selectedImage_AddContentView = clickImageName
    }
    // When touch each images
    // -------------------------------------------------------
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        tapActions(imageName: "yellow.png", imageView: image1)
    }
    
    @objc func imageTapped2(sender: UITapGestureRecognizer){
        tapActions(imageName: "green.png", imageView: image2)
    }
    
    @objc func imageTapped3(sender: UITapGestureRecognizer){
        tapActions(imageName: "deepRed.png", imageView: image3)
    }
    
    @objc func imageTapped4(sender: UITapGestureRecognizer){
        tapActions(imageName: "orange.png", imageView: image4)
    }
    
    @objc func imageTapped5(sender: UITapGestureRecognizer){
        tapActions(imageName: "beige.png", imageView: image5)
    }
    
    @objc func imageTapped6(sender: UITapGestureRecognizer){
        tapActions(imageName: "laidgray.png", imageView: image6)
    }
    
    @objc func imageTapped7(sender: UITapGestureRecognizer){
        tapActions(imageName: "pink2.png", imageView: image7)
    }
    
    @objc func imageTapped8(sender: UITapGestureRecognizer){
        tapActions(imageName: "purple.png", imageView: image8)
    }
    
    @objc func imageTapped9(sender: UITapGestureRecognizer){
        tapActions(imageName: "deepPurple.png", imageView: image9)
    }
    
    @objc func imageTapped10(sender: UITapGestureRecognizer){
        tapActions(imageName: "liteblue.png", imageView: image10)
    }
    
    @objc func imageTapped11(sender: UITapGestureRecognizer){
        tapActions(imageName: "deepgray.png", imageView: image11)
    }
    
    @objc func imageTapped12(sender: UITapGestureRecognizer){
        tapActions(imageName: "navy.png", imageView: image12)
    }
    // -------------------------------------------------------

    // Set GestureRecognizer each buttons
    func setGestureRecognizer(){
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        let tapGR2 = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped2))
        let tapGR3 = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped3))
        let tapGR4 = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped4))
        let tapGR5 = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped5))
        let tapGR6 = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped6))
        let tapGR7 = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped7))
        let tapGR8 = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped8))
        let tapGR9 = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped9))
        let tapGR10 = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped10))
        let tapGR11 = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped11))
        let tapGR12 = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped12))
        
        image1.addGestureRecognizer(tapGR)
        image2.addGestureRecognizer(tapGR2)
        image3.addGestureRecognizer(tapGR3)
        image4.addGestureRecognizer(tapGR4)
        image5.addGestureRecognizer(tapGR5)
        image6.addGestureRecognizer(tapGR6)
        image7.addGestureRecognizer(tapGR7)
        image8.addGestureRecognizer(tapGR8)
        image9.addGestureRecognizer(tapGR9)
        image10.addGestureRecognizer(tapGR10)
        image11.addGestureRecognizer(tapGR11)
        image12.addGestureRecognizer(tapGR12)
    }

    // Set border of clicked Image
    func clickImageOnlyOne(image : UIImageView){
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.cornerRadius = 10
    }
    
    // Reset border of all buttons
    func resetBorder(){
        image1.layer.borderWidth = 0
        image2.layer.borderWidth = 0
        image3.layer.borderWidth = 0
        image4.layer.borderWidth = 0
        image5.layer.borderWidth = 0
        image6.layer.borderWidth = 0
        image7.layer.borderWidth = 0
        image8.layer.borderWidth = 0
        image9.layer.borderWidth = 0
        image10.layer.borderWidth = 0
        image11.layer.borderWidth = 0
        image12.layer.borderWidth = 0
    }
    
    // A collection of functions
    func tapActions(imageName : String, imageView : UIImageView){
        clickImageName = imageName
        resetBorder()
        clickImageOnlyOne(image: imageView)
    }
    
}
