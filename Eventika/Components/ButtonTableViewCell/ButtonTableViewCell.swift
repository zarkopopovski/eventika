//
//  ButtonTableViewCell.swift
//  App
//
//  Created by Zarko Popovski on 11/4/18.
//  Copyright © 2018 App. All rights reserved.
//

import UIKit

protocol ButtonTableViewCellDelegate {
    func buttonDidPressOnTouch()
}

class ButtonTableViewCell: UITableViewCell {

    var delegate:ButtonTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func btnConfirmAction(_ sender: Any) {
        self.delegate?.buttonDidPressOnTouch()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
