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
    
    
    // Empty constructor
    override init() {
        
    }
    
    //Constructors must be created unconditionally 
    init(cTitle: String){
        self.cTitle = cTitle
    }
    
}
