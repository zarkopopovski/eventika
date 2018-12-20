//
//  ProfileInfoTableViewCell.swift
//  App
//
//  Created by Zarko Popovski on 11/25/18.
//  Copyright © 2018 App. All rights reserved.
//

import UIKit

protocol ProfileInfoTableViewCellDelegate {
    func btnPressWithID(btnID: Int)
}

class ProfileInfoTableViewCell: UITableViewCell {

    var delegate:ProfileInfoTableViewCellDelegate?
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblDateJoin: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    
    @IBOutlet weak var btnFB: UIButton!
    
    @IBOutlet weak var btnInsta: UIButton!
    @IBOutlet weak var btnLi: UIButton!
    
    var profileData:MemberEntity?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.width / 2
        self.imgAvatar.layer.borderWidth = 0.5
        self.imgAvatar.layer.borderColor = (UIColor.red).cgColor
        
        if ((GlobalData.sharedInstance.memberEntity?.memberFBAccount) == nil || GlobalData.sharedInstance.memberEntity?.memberFBAccount == "-") {
            self.btnFB.setImage(UIImage(named: "facebook_gray_logo.png"), for: .normal)
            self.btnFB.isEnabled = false
        }
        
        if ((GlobalData.sharedInstance.memberEntity?.memberINAccount) == nil || GlobalData.sharedInstance.memberEntity?.memberINAccount == "-") {
            self.btnInsta.setImage(UIImage(named: "instagram_gray_logo.png"), for: .normal)
            self.btnInsta.isEnabled = false
        }
        
        if ((GlobalData.sharedInstance.memberEntity?.memberLIAccount) == nil || GlobalData.sharedInstance.memberEntity?.memberLIAccount == "-") {
            self.btnLi.setImage(UIImage(named: "linkedin_gray_logo.png"), for: .normal)
            self.btnLi.isEnabled = false
        }
    }

    @IBAction func btnFBAction(_ sender: UIButton) {
        self.delegate?.btnPressWithID(btnID: 0)
    }
    
    @IBAction func btnInstaAction(_ sender: UIButton) {
        self.delegate?.btnPressWithID(btnID: 1)
    }
    
    @IBAction func btnLiAction(_ sender: UIButton) {
        self.delegate?.btnPressWithID(btnID: 2)
    }
    
    func setProfileDataToElements(profileData:MemberEntity) {
        self.profileData = profileData
        
        
        
        
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
