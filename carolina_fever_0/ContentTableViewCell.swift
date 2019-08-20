//
//  ContentTableViewCell.swift
//  carolina_fever_0
//
//  Created by Caleb Kang on 7/26/19.
//  Copyright © 2019 Caleb Kang. All rights reserved.
//

import UIKit

class ContentTableViewCell: UITableViewCell {

    @IBOutlet var date: UILabel!
    @IBOutlet var gameString: UILabel!
    @IBOutlet var points: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }

}