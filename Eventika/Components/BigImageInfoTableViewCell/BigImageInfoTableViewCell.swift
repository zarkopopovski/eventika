//
//  BigImageInfoTableViewCell.swift
//  App
//
//  Created by Zarko Popovski on 11/16/18.
//  Copyright © 2018 App. All rights reserved.
//

import UIKit

protocol BigImageInfoTableViewCellDelegate {
    func executeCellWithID(cellID: Int)
}

class BigImageInfoTableViewCell: UITableViewCell {

    var delegate:BigImageInfoTableViewCellDelegate?
    
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var readMore: UIButton!
    @IBOutlet weak var txtDescription: UILabel!
    
    var isTextLabelModified:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.readMore.layer.borderWidth = 0.5
        self.readMore.layer.borderColor = (UIColor.white).cgColor
        self.readMore.layer.cornerRadius = 5.0
    }

    @IBAction func btnReadMoreAction(_ sender: UIButton) {
        delegate?.executeCellWithID(cellID: self.tag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
