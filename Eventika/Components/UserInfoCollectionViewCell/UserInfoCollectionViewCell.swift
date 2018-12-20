//
//  UserInfoCollectionViewCell.swift
//  App
//
//  Created by Zarko Popovski on 11/18/18.
//  Copyright © 2018 App. All rights reserved.
//

import UIKit

protocol UserInfoCollectionViewCellDelegate {
    func executedCellWithID(cellID:Int)
}

class UserInfoCollectionViewCell: UICollectionViewCell {

    var delegate:UserInfoCollectionViewCellDelegate?
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblProfession: UILabel!
    @IBOutlet weak var btnView: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.width / 2
//        self.imgAvatar.layer.borderWidth = 0.5
//        self.imgAvatar.layer.borderColor = (UIColor.red).cgColor
        
        self.btnView.layer.borderWidth = 0.5
        self.btnView.layer.borderColor = (UIColor.red).cgColor
    }

    @IBAction func btnViewAction(_ sender: UIButton) {
        self.delegate?.executedCellWithID(cellID: self.tag)
    }
}
