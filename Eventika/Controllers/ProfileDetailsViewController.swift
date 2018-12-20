//
//  ProfileDetailsViewController.swift
//  App
//
//  Created by Zarko Popovski on 11/25/18.
//  Copyright © 2018 App. All rights reserved.
//

import UIKit
import ImageLoader
import MessageUI

import FacebookLogin
import FBSDKLoginKit
import FacebookCore

class ProfileDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDataSourcePrefetching, UITableViewDelegate, ProfileInfoTableViewCellDelegate, LabeledTitleArrowTableViewCellDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tvProfileDetails: UITableView!
    var tvCells:[UITableViewCell] = [UITableViewCell]()
    
    let CELL_PROFILE_INFO = 0

    let CELL_PROFILE_PASSWORD = 1
    let CELL_PROFILE_TERMS = 2
    let CELL_PROFILE_LOGOUT = 3
    let CELL_PROFILE_CONTACT = 4
    
    let CELL_BTN_FB = 0
    let CELL_BTN_INSTA = 1
    let CELL_BTN_LI = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //self.navigationItem.title = "Profile"
        let customFont = UIFont(name: "FreightBigMedium", size: 20.0)
        let customLabel = UILabel()
        customLabel.font = customFont
        customLabel.text = "Profile"
        
        self.navigationItem.titleView = customLabel
        
        self.tvProfileDetails.register(UINib.init(nibName: "ProfileInfoTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ProfileInfoTableViewCell")
        self.tvProfileDetails.register(UINib.init(nibName: "LabelDisplayTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "LabelDisplayTableViewCell")
        self.tvProfileDetails.register(UINib.init(nibName: "LabeledTitleArrowTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "LabeledTitleArrowTableViewCell")
    }

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 44.0
        
        if indexPath.row == CELL_PROFILE_INFO {
            height = 282.0
        } else {
            height = 44.0
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 44.0
        
        if indexPath.row == CELL_PROFILE_INFO {
            let cell:ProfileInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoTableViewCell") as! ProfileInfoTableViewCell
            cell.delegate = self
            
            cell.lblFullName.text = GlobalData.sharedInstance.memberEntity?.memberFullName
            cell.lblDateJoin.text = "Joined on " + (GlobalData.sharedInstance.memberEntity?.memberDateJoin)!
            cell.lblLocation.text = GlobalData.sharedInstance.memberEntity?.memberLocation
            cell.lblQuestion.text = GlobalData.sharedInstance.memberEntity?.memberReason
            
            var imageURL:String = ""
            
            if (GlobalData.sharedInstance.memberEntity?.isSocialMember)! {
                imageURL = (GlobalData.sharedInstance.memberEntity?.memberImage)!
            } else {
                imageURL = GlobalData.sharedInstance.API_MEMBERS_IMAGES+(GlobalData.sharedInstance.memberEntity?.memberImage)!
            }
            
            cell.imgAvatar.load.request(with: URL(string: imageURL)!)
            
            cell.profileData = GlobalData.sharedInstance.memberEntity
        
            cell.tag = CELL_PROFILE_INFO
            
            height = 282.0
            
            self.tvCells.append(cell)
        } else if indexPath.row == CELL_PROFILE_PASSWORD {
            let cell:LabeledTitleArrowTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LabeledTitleArrowTableViewCell") as! LabeledTitleArrowTableViewCell
            
            cell.lblTitle.text = "Change password"
            
            cell.delegate = self
            cell.tag = CELL_PROFILE_PASSWORD
            
            height = 44.0
            
            self.tvCells.append(cell)
        } else if indexPath.row == CELL_PROFILE_TERMS {
            let cell:LabeledTitleArrowTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LabeledTitleArrowTableViewCell") as! LabeledTitleArrowTableViewCell
            
            cell.lblTitle.text = "Terms"
            
            cell.delegate = self
            cell.tag = CELL_PROFILE_TERMS
            
            height = 44.0
            
            self.tvCells.append(cell)
        } else if indexPath.row == CELL_PROFILE_LOGOUT {
            let cell:LabeledTitleArrowTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LabeledTitleArrowTableViewCell") as! LabeledTitleArrowTableViewCell
            
            cell.lblTitle.text = "Logout"
            
            cell.delegate = self
            cell.tag = CELL_PROFILE_LOGOUT
            
            height = 44.0
            
            self.tvCells.append(cell)
        } else if indexPath.row == CELL_PROFILE_CONTACT {
            let cell:LabeledTitleArrowTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LabeledTitleArrowTableViewCell") as! LabeledTitleArrowTableViewCell
            
            cell.lblTitle.text = "Contact the EVENTIKA Team"
            
            cell.delegate = self
            cell.tag = CELL_PROFILE_CONTACT
            
            height = 44.0
            
            self.tvCells.append(cell)
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.tvCells[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func btnPressWithID(btnID: Int) {
        if btnID == CELL_BTN_FB {
            
        } else if btnID == CELL_BTN_INSTA {
            
        } else if btnID == CELL_BTN_LI {
            
        }
    }
    
    func labeledTitlePressedWithID(cellID: Int) {
        if cellID == CELL_PROFILE_PASSWORD {
            if !(GlobalData.sharedInstance.memberEntity?.isSocialMember)! {
                let changePasswordVC:ChangePasswordViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
                self.navigationController?.pushViewController(changePasswordVC, animated: true)
            } else {
                //alert
            }
        } else if cellID == CELL_PROFILE_TERMS {
            if let url = URL(string: "https://eventika.co/") {
                UIApplication.shared.open(url, options: [:])
            }
        } else if cellID == CELL_PROFILE_CONTACT {
            self.sendEmail()
        } else if cellID == CELL_PROFILE_LOGOUT {
            let loginVC:LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            
            let userDefaults = UserDefaults.standard
            
            if FBSDKAccessToken.currentAccessTokenIsActive() {
                let fbLoginManager = FBSDKLoginManager.init()
                fbLoginManager.logOut()
                
                userDefaults.setValue(nil, forKey: "fb_id")
            }
            
            userDefaults.set(false, forKey: "is_logged")
            userDefaults.setValue(nil, forKey: "user_id")
            
            userDefaults.setValue(nil, forKey: "email")
            
            userDefaults.synchronize()
            
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["contact@eventika.co"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
