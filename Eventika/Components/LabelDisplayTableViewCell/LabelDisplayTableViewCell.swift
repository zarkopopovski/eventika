//
//  LabelDisplayTableViewCell.swift
//  App
//
//  Created by Zarko Popovski on 11/25/18.
//  Copyright © 2018 App. All rights reserved.
//

import UIKit

class LabelDisplayTableViewCell: UITableViewCell {
    @IBOutlet weak var lblLeft: UILabel!
    @IBOutlet weak var lblRight: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
