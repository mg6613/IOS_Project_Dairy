//
//  TableViewCell.swift
//  MyDiary
//
//  Created by ssemm on 2021/02/19.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var lblCellTitle: UILabel!
    @IBOutlet weak var lblCellDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
