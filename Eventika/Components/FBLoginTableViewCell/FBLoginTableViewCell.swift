//
//  FBLoginTableViewCell.swift
//  App
//
//  Created by Zarko Popovski on 11/4/18.
//  Copyright © 2018 App. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

import FacebookCore
import FacebookLogin

class FBLoginTableViewCell: UITableViewCell {

    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if (FBSDKAccessToken.current() != nil) {
            // User is logged in,
            NSLog("FB token: %@", FBSDKAccessToken.current())
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
