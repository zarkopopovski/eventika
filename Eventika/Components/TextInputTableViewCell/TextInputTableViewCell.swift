//
//  TextInputTableViewCell.swift
//  App
//
//  Created by Zarko Popovski on 11/4/18.
//  Copyright © 2018 App. All rights reserved.
//

import UIKit

protocol TextInputTableViewCellDelegate {
    func keyDidPress()
    func executeTextActionWithTag(tagID:Int)
    func activeCellByTag(tagID:Int)
}

class TextInputTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var inputTextView: UITextField!
    @IBOutlet weak var inputImageView: UIImageView!
    
    var delegate:TextInputTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.inputTextView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setImageVisible() {
        self.inputImageView.isHidden = false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.delegate?.keyDidPress()
        
        self.delegate?.activeCellByTag(tagID: self.tag)
        self.delegate?.executeTextActionWithTag(tagID: self.tag)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
