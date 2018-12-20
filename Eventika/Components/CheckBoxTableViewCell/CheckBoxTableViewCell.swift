//
//  CheckBoxTableView.swift
//  App
//
//  Created by Zarko Popovski on 11/5/18.
//  Copyright © 2018 App. All rights reserved.
//

import UIKit

class CheckBoxTableViewCell: UITableViewCell {

    @IBOutlet weak var imgCheckBox: UIImageView!
    var checkStatus:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chkBoxChangeState))
        self.imgCheckBox.addGestureRecognizer(gesture)
    }

    func setCheckBoxState(status: Bool) {
        self.checkStatus = status
        
        if self.checkStatus {
            self.imgCheckBox.image = UIImage(named: "checkbox-checked")
        } else {
            self.imgCheckBox.image = UIImage(named: "checkbox-unchecked")
        }
    }
    
    @objc func chkBoxChangeState() {
        self.checkStatus = !self.checkStatus
        
        if self.checkStatus {
            self.imgCheckBox.image = UIImage(named: "checkbox-checked")
        } else {
            self.imgCheckBox.image = UIImage(named: "checkbox-unchecked")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
