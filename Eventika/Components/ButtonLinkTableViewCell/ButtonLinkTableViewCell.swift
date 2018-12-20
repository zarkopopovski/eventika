//
//  ButtonLinkTableViewCell.swift
//  App
//
//  Created by Zarko Popovski on 11/4/18.
//  Copyright © 2018 App. All rights reserved.
//

import UIKit

protocol ButtonLinkTableViewCellDelegate {
    func pressBtnLink()
}

class ButtonLinkTableViewCell: UITableViewCell {

    var delegate:ButtonLinkTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func btnSignInAction(_ sender: Any) {
        self.delegate?.pressBtnLink()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
