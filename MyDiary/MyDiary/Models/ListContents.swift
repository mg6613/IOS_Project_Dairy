//
//  ListContents.swift
//  MyDiary
//
//  Created by 유민규 on 2021/02/18.
//

import Foundation

class ListContents: NSObject{
    
    // Properties
    var cTitle: String?
    var cInsertDate: String?
    var cImageFileName: String?
    
    // Empty constructor
    override init() {
        
    }
    
    //Constructors must be created unconditionally 
    init(cTitle: String, cInsertDate: String, cImageFileName: String){
        self.cTitle = cTitle
        self.cInsertDate = cInsertDate
        self.cImageFileName = cImageFileName
    }
    
}
