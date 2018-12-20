//
//  LabeledCheckmarkTableViewCell.swift
//  App
//
//  Created by Zarko Popovski on 11/19/18.
//  Copyright © 2018 App. All rights reserved.
//

import UIKit

protocol LabeledCheckmarkTableViewCellDelegate {
    func selectImageFromGalleryForID()
}

class LabeledCheckmarkTableViewCell: UITableViewCell {

    var delegate:LabeledCheckmarkTableViewCellDelegate?
    
    @IBOutlet weak var imgCheckmark: UIImageView!
    @IBOutlet weak var lblProfileImage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let showGalleryTapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showImageGallery))
        self.lblProfileImage.addGestureRecognizer(showGalleryTapGesture)
    }
    
    @objc func showImageGallery() {
        self.delegate?.selectImageFromGalleryForID()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
