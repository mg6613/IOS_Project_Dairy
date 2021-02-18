//
//  ListTableViewCell.swift
//  MyDiary
//
//  Created by 유민규 on 2021/02/18.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
