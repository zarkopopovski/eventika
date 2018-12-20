//
//  LabeledTitleArrowTableViewCell.swift
//  App
//
//  Created by Zarko Popovski on 11/25/18.
//  Copyright © 2018 App. All rights reserved.
//

import UIKit

protocol LabeledTitleArrowTableViewCellDelegate {
    func labeledTitlePressedWithID(cellID:Int)
}

class LabeledTitleArrowTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    
    var delegate:LabeledTitleArrowTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureEvent))
        self.lblTitle.addGestureRecognizer(tapGesture)
    }

    @objc func tapGestureEvent() {
        self.delegate?.labeledTitlePressedWithID(cellID: self.tag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
