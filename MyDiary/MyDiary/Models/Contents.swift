//
//  Contents.swift
//  SideProject_Diary02
//
//  Created by 이민우 on 2021/02/15.
//

import Foundation

class Contents{
    
    var cId : Int
    var cTitle : String
    var cContent : String
    var cImageFileName : String
    var cInsertDate : String
    var cUpdateDate : String
    var cDeleteDate : String
   // var cCount : Int
    
    
    init(cId : Int, cTitle : String, cContent : String, cImageFileName : String, cInsertDate : String, cUpdateDate : String?, cDeleteDate : String?) {
        self.cId = cId
        self.cTitle = cTitle
        self.cContent = cContent
        self.cImageFileName = cImageFileName
        self.cInsertDate = cInsertDate
        self.cUpdateDate = cUpdateDate!
        self.cDeleteDate = cDeleteDate!
        
    }
    
  


}
