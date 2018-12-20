//
//  CustomFBLoginButtonTableViewCell.swift
//  App
//
//  Created by Zarko Popovski on 11/11/18.
//  Copyright © 2018 App. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import FacebookCore

protocol CustomFBLoginButtonTableViewCellDelegate {
    func receivedFBUserDetails(userDetails:[String:AnyObject])
}

class CustomFBLoginButtonTableViewCell: UITableViewCell {
    
    var delegate:CustomFBLoginButtonTableViewCellDelegate?
    
    @IBOutlet weak var btnExecute: UIButton!
    var parentVC:UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnExecute.layer.cornerRadius = 2.0
    }

    @IBAction func bntCustomFBAction(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions:[.publicProfile, .email ], viewController: parentVC) { (result) in
            switch result{
            case .cancelled:
                print("Cancel button click")
            case .success:
                let params = ["fields" : "id, name, first_name, last_name, picture.type(large), email "]
                let graphRequest = FBSDKGraphRequest.init(graphPath: "/me", parameters: params)
                let Connection = FBSDKGraphRequestConnection()
                Connection.add(graphRequest) { (Connection, result, error) in
                    let info = result as! [String : AnyObject]
                    print(info["name"] as! String)
                    
                    self.delegate?.receivedFBUserDetails(userDetails: info)
                }
                Connection.start()
            default:
                print("??")
            }
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
