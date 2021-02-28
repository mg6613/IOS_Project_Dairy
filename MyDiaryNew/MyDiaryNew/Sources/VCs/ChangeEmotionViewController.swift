//
//  ChangeEmotionViewController.swift
//  MyDiary
//
//  Created by MinWoo Lee on 2021/02/19.
//

import UIKit

class ChangeEmotionViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set GestureRecognizer each imageviews
        setGestureRecognizer()

    }
    
    // When touch each images
    // -------------------------------------------------------
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        tapAction(imageName: "yellow.png")
    }
    
    @objc func imageTapped2(sender: UITapGestureRecognizer){
        tapAction(imageName: "green.png")
    }
    
    @objc func imageTapped3(sender: UITapGestureRecognizer){
        tapAction(imageName: "deepRed.png")
    }
    
    @objc func imageTapped4(sender: UITapGestureRecognizer){
        tapAction(imageName: "orange.png")
    }
    
    @objc func imageTapped5(sender: UITapGestureRecognizer){
        tapAction(imageName: "beige.png")
    }
    
    @objc func imageTapped6(sender: UITapGestureRecognizer){
        tapAction(imageName: "laidgray.png")
    }
    
    @objc func imageTapped7(sender: UITapGestureRecognizer){
        tapAction(imageName: "pink2.png")
    }
    
    @objc func imageTapped8(sender: UITapGestureRecognizer){
        tapAction(imageName: "purple.png")
    }
    
    @objc func imageTapped9(sender: UITapGestureRecognizer){
        tapAction(imageName: "deepPurple.png")
    }
    
    @objc func imageTapped10(sender: UITapGestureRecognizer){
        tapAction(imageName: "liteblue.png")
    }
    
    @objc func imageTapped11(sender: UITapGestureRecognizer){
        tapAction(imageName: "deepgray.png")
    }
    
    @objc func imageTapped12(sender: UITapGestureRecognizer){
        tapAction(imageName: "navy.png")
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

    // Action for when touch images
    func tapAction(imageName : String){
        imageName_DetailView = imageName
        whereValue = 1
        self.navigationController?.popViewController(animated: true)
    }
}
