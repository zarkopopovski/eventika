//
//  RegisterViewController.swift
//  App
//
//  Created by Zarko Popovski on 11/2/18.
//  Copyright © 2018 App. All rights reserved.
//

import UIKit
import Alamofire
import PMJSON

class RegisterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ButtonTableViewCellDelegate, ButtonLinkTableViewCellDelegate, CustomFBLoginButtonTableViewCellDelegate, LabeledCheckmarkTableViewCellDelegate,
TextInputTableViewCellDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileDataTableView: UITableView!
    
    var tvCells:[UITableViewCell] = [UITableViewCell]()
    
    let CELL_FB_LOGIN = 0
    let CELL_FULL_NAME = 1
    let CELL_EMAIL = 2
    let CELL_PASSWORD = 3
    let CELL_PASSWORD_CONFIRM = 4
    let CELL_PROFILE_IMAGE = 5
    let CELL_DATE_JOIN = 6
    let CELL_PROFESSION = 7
    let CELL_QUESTION = 8
    let CELL_MOBILE = 9
    let CELL_LOCATION = 10
    
    let CELL_FB_ACCOUNT = 11
    let CELL_IN_ACCOUNT = 12
    let CELL_LI_ACCOUNT = 13
    
    
    let CELL_AGREE = 14
    let CELL_BUTTON_REGISTER = 15
    let CELL_BUTTON_LINK_SKIP = 16
    
    var imageObj:UIImage? = nil
    var isImageSelected:Bool = false
    
    var currentDateAsString:String?
    
    var activeCell:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.profileDataTableView.register(UINib.init(nibName: "CustomFBLoginButtonTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CustomFBLoginButtonTableViewCell")
        self.profileDataTableView.register(UINib.init(nibName: "TextInputTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TextInputTableViewCell")
        self.profileDataTableView.register(UINib.init(nibName: "LabeledCheckmarkTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "LabeledCheckmarkTableViewCell")
        self.profileDataTableView.register(UINib.init(nibName: "CheckBoxTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CheckBoxTableViewCell")
        self.profileDataTableView.register(UINib.init(nibName: "ButtonTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ButtonTableViewCell")
        self.profileDataTableView.register(UINib.init(nibName: "ButtonLinkTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ButtonLinkTableViewCell")
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM.dd.yy"
        
        self.currentDateAsString = dateFormatter.string(from: currentDate)
        
        let userDefaults:UserDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: "is_logged") {
            let tabBarCnt:BaseTabBarViewController = self.storyboard?.instantiateViewController(withIdentifier: "BaseTabBarViewController") as! BaseTabBarViewController
            
            self.navigationController?.pushViewController(tabBarCnt, animated: true)
        }
        
        let center = NotificationCenter.default
        
        center.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 17
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 0.0
        
        if indexPath.row == CELL_FB_LOGIN {
            height = 228.0
        } else if indexPath.row > CELL_FB_LOGIN && indexPath.row < CELL_BUTTON_REGISTER {
            height = 52.0
        } else if indexPath.row == CELL_BUTTON_REGISTER {
            height = 64.0
        } else if indexPath.row == CELL_BUTTON_LINK_SKIP {
            height = 44.0
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 0.0
        
        if indexPath.row == CELL_FB_LOGIN {
            let cell:CustomFBLoginButtonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomFBLoginButtonTableViewCell") as! CustomFBLoginButtonTableViewCell
            cell.delegate = self
            cell.parentVC = self
            
            cell.tag = CELL_FB_LOGIN
                
            height = 228.0
            
            self.tvCells.append(cell)
        } else if indexPath.row == CELL_FULL_NAME {
            let cell:TextInputTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TextInputTableViewCell") as! TextInputTableViewCell
            cell.inputTextView.placeholder = "Full Name"
            cell.inputTextView.returnKeyType = .default
            
            cell.inputTextView.borderStyle = UITextBorderStyle.line;
            cell.inputTextView.layer.borderColor = (UIColor.black).cgColor
            cell.inputTextView.layer.borderWidth = 0.5;
            
            cell.inputImageView.image = UIImage(named: "asterisk.png")
            cell.inputImageView.isHidden = false
            
            cell.tag = CELL_FULL_NAME
            
            height = 44.0
            
            self.tvCells.append(cell)
        } else if indexPath.row == CELL_EMAIL {
            let cell:TextInputTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TextInputTableViewCell") as! TextInputTableViewCell
            cell.inputTextView.placeholder = "Email"
            cell.inputTextView.returnKeyType = .default
            
            cell.inputTextView.borderStyle = UITextBorderStyle.line;
            cell.inputTextView.layer.borderColor = (UIColor.black).cgColor
            cell.inputTextView.layer.borderWidth = 0.5
            
            cell.inputImageView.image = UIImage(named: "asterisk.png")
            cell.inputImageView.isHidden = false
            
            cell.tag = CELL_EMAIL
            
            height = 52.0
            
            self.tvCells.append(cell)
        } else if indexPath.row == CELL_PASSWORD {
            let cell:TextInputTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TextInputTableViewCell") as! TextInputTableViewCell
            cell.inputTextView.placeholder = "Create password"
            cell.inputTextView.isSecureTextEntry = true
            cell.inputTextView.returnKeyType = .default
            
            cell.inputTextView.borderStyle = UITextBorderStyle.line;
            cell.inputTextView.layer.borderColor = (UIColor.black).cgColor
            cell.inputTextView.layer.borderWidth = 0.5;
            
            cell.inputImageView.image = UIImage(named: "asterisk.png")
            cell.inputImageView.isHidden = false
            
            cell.tag = CELL_PASSWORD
            
            height = 52.0
            
            self.tvCells.append(cell)
        } else if indexPath.row == CELL_PASSWORD_CONFIRM {
            let cell:TextInputTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TextInputTableViewCell") as! TextInputTableViewCell
            cell.inputTextView.placeholder = "Repeat password"
            cell.inputTextView.isSecureTextEntry = true
            cell.inputTextView.returnKeyType = .default
            
            cell.inputTextView.borderStyle = UITextBorderStyle.line;
            cell.inputTextView.layer.borderColor = (UIColor.black).cgColor
            cell.inputTextView.layer.borderWidth = 0.5;
            
            cell.inputImageView.image = UIImage(named: "asterisk.png")
            cell.inputImageView.isHidden = false
            
            cell.tag = CELL_PASSWORD_CONFIRM
            
            height = 52.0
            
            self.tvCells.append(cell)
        } else if indexPath.row == CELL_PROFILE_IMAGE {
            let cell:LabeledCheckmarkTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LabeledCheckmarkTableViewCell") as! LabeledCheckmarkTableViewCell
            cell.delegate = self
            
            cell.tag = CELL_PROFILE_IMAGE
            
            height = 52.0
            
            self.tvCells.append(cell)
        } else if indexPath.row == CELL_DATE_JOIN {
            let cell:TextInputTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TextInputTableViewCell") as! TextInputTableViewCell
            cell.inputTextView.placeholder = "Date joined club"
            
            cell.inputTextView.borderStyle = UITextBorderStyle.line;
            cell.inputTextView.layer.borderColor = (UIColor.black).cgColor
            cell.inputTextView.layer.borderWidth = 0.5;
            
            cell.inputTextView.isEnabled = false
            
            cell.tag = CELL_DATE_JOIN
            
//            let currentDate = Date()
//            let dateFormatter = DateFormatter()
//
//            dateFormatter.dateFormat = "MMMM/d/yyyy"
//
//            let dateFromString = dateFormatter.string(from: currentDate)
            cell.inputTextView.text = self.currentDateAsString
            
            height = 52.0
            
            self.tvCells.append(cell)
        } else if indexPath.row == CELL_PROFESSION {
            let cell:TextInputTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TextInputTableViewCell") as! TextInputTableViewCell
            cell.inputTextView.placeholder = "Profession"
            cell.inputTextView.returnKeyType = .default
            
            cell.inputTextView.borderStyle = UITextBorderStyle.line;
            cell.inputTextView.layer.borderColor = (UIColor.black).cgColor
            cell.inputTextView.layer.borderWidth = 0.5;
            
            cell.tag = CELL_PROFESSION
            
            height = 52.0
            
            self.tvCells.append(cell)
        } else if indexPath.row == CELL_QUESTION {
            let cell:TextInputTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TextInputTableViewCell") as! TextInputTableViewCell
            cell.inputTextView.placeholder = "I love EVENTIKA because..."
            cell.inputTextView.returnKeyType = .default
            
            cell.inputTextView.borderStyle = UITextBorderStyle.line;
            cell.inputTextView.layer.borderColor = (UIColor.black).cgColor
            cell.inputTextView.layer.borderWidth = 0.5;
            
            cell.tag = CELL_QUESTION
            
            height = 52.0
            
            self.tvCells.append(cell)
        } else if indexPath.row == CELL_MOBILE {
            let cell:TextInputTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TextInputTableViewCell") as! TextInputTableViewCell
            cell.inputTextView.placeholder = "Mobile number"
            cell.inputTextView.returnKeyType = .default
            
            cell.inputTextView.borderStyle = UITextBorderStyle.line;
            cell.inputTextView.layer.borderColor = (UIColor.black).cgColor
            cell.inputTextView.layer.borderWidth = 0.5;
            
            cell.tag = CELL_MOBILE
            
            height = 52.0
            
            self.tvCells.append(cell)
        } else if (indexPath.row == CELL_LOCATION) {
            let cell:TextInputTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TextInputTableViewCell") as! TextInputTableViewCell
            cell.inputTextView.placeholder = "Location"
            cell.inputTextView.returnKeyType = .default
            
            cell.inputTextView.borderStyle = UITextBorderStyle.line;
            cell.inputTextView.layer.borderColor = (UIColor.black).cgColor
            cell.inputTextView.layer.borderWidth = 0.5;
            
            cell.tag = CELL_LOCATION
            
            height = 52.0
            
            self.tvCells.append(cell)
        } else if (indexPath.row == CELL_FB_ACCOUNT) {
            let cell:TextInputTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TextInputTableViewCell") as! TextInputTableViewCell
            cell.inputTextView.placeholder = "Facebook Account"
            cell.inputTextView.returnKeyType = .default
            
            cell.inputTextView.borderStyle = UITextBorderStyle.line;
            cell.inputTextView.layer.borderColor = (UIColor.black).cgColor
            cell.inputTextView.layer.borderWidth = 0.5;
            
            cell.tag = CELL_FB_ACCOUNT
            
            height = 52.0
            
            self.tvCells.append(cell)
        } else if (indexPath.row == CELL_IN_ACCOUNT) {
            let cell:TextInputTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TextInputTableViewCell") as! TextInputTableViewCell
            cell.inputTextView.placeholder = "Instagram Account"
            cell.inputTextView.returnKeyType = .default
            
            cell.inputTextView.borderStyle = UITextBorderStyle.line;
            cell.inputTextView.layer.borderColor = (UIColor.black).cgColor
            cell.inputTextView.layer.borderWidth = 0.5;
            
            cell.tag = CELL_IN_ACCOUNT
            
            height = 52.0
            
            self.tvCells.append(cell)
        } else if (indexPath.row == CELL_LI_ACCOUNT) {
            let cell:TextInputTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TextInputTableViewCell") as! TextInputTableViewCell
            cell.inputTextView.placeholder = "LinkedIn Account"
            cell.inputTextView.returnKeyType = .default
            
            cell.inputTextView.borderStyle = UITextBorderStyle.line;
            cell.inputTextView.layer.borderColor = (UIColor.black).cgColor
            cell.inputTextView.layer.borderWidth = 0.5;
            
            cell.tag = CELL_LI_ACCOUNT
            
            height = 52.0
            
            self.tvCells.append(cell)
        } else if indexPath.row == CELL_AGREE {
            let cell:CheckBoxTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CheckBoxTableViewCell") as! CheckBoxTableViewCell
    
            cell.tag = CELL_AGREE
            
            height = 44.0
            
            self.tvCells.append(cell)
        } else if indexPath.row == CELL_BUTTON_REGISTER {
            let cell:ButtonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell") as! ButtonTableViewCell
            cell.delegate = self
            
            cell.tag = CELL_BUTTON_REGISTER
            
            height = 64.0
            
            self.tvCells.append(cell)
        } else if indexPath.row == CELL_BUTTON_LINK_SKIP {
            let cell:ButtonLinkTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ButtonLinkTableViewCell") as! ButtonLinkTableViewCell
            cell.delegate = self
            
            cell.tag = CELL_BUTTON_LINK_SKIP
            
            height = 44.0
            
            self.tvCells.append(cell)
        }
        
        return height
    }
    
    func resetInputFieldsBorder() {
        let cellFullName:TextInputTableViewCell = tvCells[CELL_FULL_NAME] as! TextInputTableViewCell;
        cellFullName.inputTextView.layer.borderColor = (UIColor.black).cgColor;
        
        let cellEmail:TextInputTableViewCell = tvCells[CELL_EMAIL] as! TextInputTableViewCell;
        cellEmail.inputTextView.layer.borderColor = (UIColor.black).cgColor;
        
        let cellPassword:TextInputTableViewCell = tvCells[CELL_PASSWORD] as! TextInputTableViewCell;
        cellPassword.inputTextView.layer.borderColor = (UIColor.black).cgColor;
        
        let cellConfirmPassword:TextInputTableViewCell = tvCells[CELL_PASSWORD_CONFIRM] as! TextInputTableViewCell;
        cellConfirmPassword.inputTextView.layer.borderColor = (UIColor.black).cgColor;
    }
    
    func buttonDidPressOnTouch() {
        self.resetInputFieldsBorder()
        
        let cellFullName:TextInputTableViewCell = tvCells[CELL_FULL_NAME] as! TextInputTableViewCell
        let cellEmail:TextInputTableViewCell = tvCells[CELL_EMAIL] as! TextInputTableViewCell
        let cellPassword:TextInputTableViewCell = tvCells[CELL_PASSWORD] as! TextInputTableViewCell
        let cellConfirmPassword:TextInputTableViewCell = tvCells[CELL_PASSWORD_CONFIRM] as! TextInputTableViewCell
        
        let cellDateJoin:TextInputTableViewCell = tvCells[CELL_DATE_JOIN] as! TextInputTableViewCell
        let cellProfession:TextInputTableViewCell = tvCells[CELL_PROFESSION] as! TextInputTableViewCell
        let cellQuestion:TextInputTableViewCell = tvCells[CELL_QUESTION] as! TextInputTableViewCell
        let cellMobile:TextInputTableViewCell = tvCells[CELL_MOBILE] as! TextInputTableViewCell
        let cellLocation:TextInputTableViewCell = tvCells[CELL_LOCATION] as! TextInputTableViewCell
        
        let cellFB:TextInputTableViewCell = tvCells[CELL_FB_ACCOUNT] as! TextInputTableViewCell
        let cellIN:TextInputTableViewCell = tvCells[CELL_IN_ACCOUNT] as! TextInputTableViewCell
        let cellLI:TextInputTableViewCell = tvCells[CELL_LI_ACCOUNT] as! TextInputTableViewCell
        
        let cellCheckBox:CheckBoxTableViewCell = tvCells[CELL_AGREE] as! CheckBoxTableViewCell
        
        if cellFullName.inputTextView.text == "" || cellEmail.inputTextView.text == "" || cellPassword.inputTextView.text == "" || cellConfirmPassword.inputTextView.text == "" {
            //error
            if cellFullName.inputTextView.text == "" {
                cellFullName.inputTextView.layer.borderColor = (UIColor.red).cgColor
            }
            
            if cellEmail.inputTextView.text == "" {
                cellEmail.inputTextView.layer.borderColor = (UIColor.red).cgColor
            }
            
            if cellPassword.inputTextView.text == "" {
                cellPassword.inputTextView.layer.borderColor = (UIColor.red).cgColor
            }
            
            if cellConfirmPassword.inputTextView.text == "" {
                cellConfirmPassword.inputTextView.layer.borderColor = (UIColor.red).cgColor
            }
            
            return
        } else {
            if cellPassword.inputTextView.text != cellConfirmPassword.inputTextView.text {
                //error
                
                cellPassword.inputTextView.layer.borderColor = (UIColor.red).cgColor
                cellConfirmPassword.inputTextView.layer.borderColor = (UIColor.red).cgColor
                
                return
            } else {
                // connect
//                let headers: HTTPHeaders = [
//                    "App-Token": GlobalData.sharedInstance.API_TOKEN
//                ]
                
                if cellCheckBox.checkStatus {
                    var imageData:Data
                    
                    if self.isImageSelected {
                        imageData = UIImageJPEGRepresentation(self.imageObj!, 0.10)!
                    } else {
                        imageData = UIImageJPEGRepresentation(UIImage(named: "user-anonymous")!, 0.10)!
                    }
                    
                    let headers: HTTPHeaders = [
                        /* "Authorization": "your_access_token",  in case you need authorization header */
                        "Content-type": "multipart/form-data"
                    ]
                        
                    let parameters:[String:String] = [
                        "user_email" : cellEmail.inputTextView.text!,
                        "user_password" : cellPassword.inputTextView.text!,
                        "user_mobile" : cellMobile.inputTextView.text!,
                        "user_full_name" : cellFullName.inputTextView.text!,
                        "user_datejoined" : cellDateJoin.inputTextView.text!,
                        "user_profession" : cellProfession.inputTextView.text!,
                        "question" : cellQuestion.inputTextView.text!,
                        "location" : cellLocation.inputTextView.text!,
                        "fb_account" : cellFB.inputTextView.text!,
                        "in_account" : cellIN.inputTextView.text!,
                        "li_account" : cellLI.inputTextView.text!
                        ]
                    
                    Alamofire.upload(
                        multipartFormData: { MultipartFormData in
                            
                            for (key, value) in parameters {
                                MultipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                            }
                            
                            MultipartFormData.append(imageData, withName: "file", fileName: "image_upload.jpg", mimeType: "image/jpg")

                    }, to: GlobalData.sharedInstance.API_REGISTER, method: .post, headers: headers) { (result) in
                        
                        switch result {
                        case .success(let upload, _, _):
                            
                            upload.responseString { response in
                                print(response.result.value)
                                
                                let stringResponse = response.result.value!
                                
                                var jsonData:JSON
                                
                                do
                                {
                                    jsonData = try JSON.decode(stringResponse)
                                    
                                    print(jsonData)
                                    
                                    let userID:String = try jsonData.getString("user_id")
                                    let userEmail:String = try jsonData.getString("user_email")
                                    
                                    let userDefaults:UserDefaults = UserDefaults.standard
                                    userDefaults.set(true, forKey: "is_logged")
                                    userDefaults.set(true, forKey: "is_registered")
                                    userDefaults.setValue(userID, forKey: "user_id")
                                    userDefaults.setValue(userEmail, forKey: "email")
                                    
                                    userDefaults.synchronize()
                                    
                                    let memberEntity:MemberEntity = MemberEntity()
                                    memberEntity.memberID = try jsonData.getString("user_id")
                                    memberEntity.memberFullName = try jsonData.getString("user_fullname")
                                    memberEntity.memberEmail = try jsonData.getString("user_email")
                                    memberEntity.memberProfession = try jsonData.getString("user_profession")
                                    memberEntity.memberImage = try jsonData.getString("user_image")
                                    memberEntity.memberDateJoin = try jsonData.getString("user_datejoined")
                                    memberEntity.memberReason = try jsonData.getString("question")
                                    memberEntity.memberTelephone = try jsonData.getString("user_mobile")
                                    memberEntity.memberLocation = try jsonData.getString("user_location")
                                    memberEntity.memberFBID = try jsonData.getString("user_facebook")
                                    
                                    memberEntity.memberFBAccount = try jsonData.getString("fb_account")
                                    memberEntity.memberINAccount = try jsonData.getString("in_account")
                                    memberEntity.memberLIAccount = try jsonData.getString("li_account")
                                    
                                    if memberEntity.memberFBID != "xxxxxxxxx" {
                                        memberEntity.isSocialMember = true
                                    }
                                    
                                    
                                    GlobalData.sharedInstance.memberEntity = memberEntity
                                    
                                    let tabBarCnt:BaseTabBarViewController = self.storyboard?.instantiateViewController(withIdentifier: "BaseTabBarViewController") as! BaseTabBarViewController
                                    
                                    self.navigationController?.pushViewController(tabBarCnt, animated: true)
                                }
                                catch
                                {
                                    print("Error:",error)
                                }
                            }
                            
                        case .failure(let encodingError): break
                        print(encodingError)
                        }
                        
                    }
                    
                } else {
                    let alertView = UIAlertController.init(title: "Info", message: "Please check the agree button?", preferredStyle: .alert)
                    let closeAction = UIAlertAction.init(title: "Close", style: .default) { (alert) in
                        alertView.dismiss(animated: true, completion: {
                            
                        })
                    }
                    alertView.addAction(closeAction)
                    
                    self.navigationController?.present(alertView, animated: true, completion: {
                        
                    })
                }
            }
        }
    }
    
    func receivedFBUserDetails(userDetails: [String : AnyObject]) {
        let imageArray = userDetails["picture"] as! [String : AnyObject]
        let userPhotos = imageArray["data"]
        let imageURL = userPhotos!["url"] as! String
        Alamofire.request(GlobalData.sharedInstance.API_REGISTER, method:.post,
                          parameters:
            [
                "user_email" : userDetails["email"]!,
                "user_password" : "fbxxxx",
                "user_mobile" : "",
                "user_full_name" : userDetails["name"]!,
                "user_datejoined" : self.currentDateAsString!,
                "question" : "",
                "location" : "",
                "user_facebook" : userDetails["id"]!,
                "picture_url" : imageURL
                ]).responseString(completionHandler: { (response) in
                    
                    let stringResponse = response.result.value!
                    
                    var jsonData:JSON
                    
                    do
                    {
                        jsonData = try JSON.decode(stringResponse)

                        print(jsonData)
                        
                        let userID:String = try jsonData.getString("user_id")
                        let fbID:String = try jsonData.getString("user_facebook")
                        let userEmail:String = try jsonData.getString("user_email")
                        
                        let userDefaults:UserDefaults = UserDefaults.standard
                        userDefaults.set(true, forKey: "is_logged")
                        userDefaults.set(true, forKey: "is_registered")
                        userDefaults.setValue(userID, forKey: "user_id")
                        userDefaults.setValue(fbID, forKey: "fb_id")
                        userDefaults.setValue(userEmail, forKey: "email")
                        
                        userDefaults.synchronize()
                        
                        let memberEntity:MemberEntity = MemberEntity()
                        memberEntity.memberID = try jsonData.getString("user_id")
                        memberEntity.memberFullName = try jsonData.getString("user_fullname")
                        memberEntity.memberEmail = try jsonData.getString("user_email")
                        memberEntity.memberProfession = try jsonData.getString("user_profession")
                        memberEntity.memberImage = try jsonData.getString("user_image")
                        memberEntity.memberDateJoin = try jsonData.getString("user_datejoined")
                        memberEntity.memberReason = try jsonData.getString("question")
                        memberEntity.memberTelephone = try jsonData.getString("user_mobile")
                        memberEntity.memberLocation = try jsonData.getString("user_location")
                        memberEntity.memberFBID = try jsonData.getString("user_facebook")
                        
                        memberEntity.memberFBAccount = try jsonData.getString("fb_account")
                        memberEntity.memberINAccount = try jsonData.getString("in_account")
                        memberEntity.memberLIAccount = try jsonData.getString("li_account")
                        
                        if memberEntity.memberFBID != "xxxxxxxxx" {
                            memberEntity.isSocialMember = true
                        }
                        
                        
                        GlobalData.sharedInstance.memberEntity = memberEntity
                        
                        let tabBarCnt:BaseTabBarViewController = self.storyboard?.instantiateViewController(withIdentifier: "BaseTabBarViewController") as! BaseTabBarViewController
                        
                        self.navigationController?.pushViewController(tabBarCnt, animated: true)
                    }
                    catch
                    {
                        print("Error:",error)
                    }
                    
                })
    }
    
    func pressBtnLink() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.tvCells[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func selectImageFromGalleryForID() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            return
        }
        
        let imageController:UIImagePickerController = UIImagePickerController()
        imageController.delegate = self
        imageController.sourceType = .photoLibrary
        imageController.allowsEditing = false
        self.present(imageController, animated: true, completion: {
            
        })
    }
    
    func uploadPhoto() {
//    __weak typeof(self) weakSelf = self;
//
//    NSData *imageData = UIImageJPEGRepresentation(_avatarImageView.image, 0.10);
//
//    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kUpdateUserProfilePhoto]];
//    [request setRequestMethod:@"POST"];
//    [request setPostValue:GLOBALS.userToken forKey:kToken];
//    [request addData:imageData withFileName:@"image_upload.jpg" andContentType:@"image/jpg" forKey:kUserFile];
//
//
//    [request setCompletionBlock:^{
//    NSLog(@"Completed: %@", request.responseString);
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    NSError *error;
//    NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:&error];
//    s
//    }];
//
//    [request setFailedBlock:^{
//    NSLog(@"Completed: %@", request.responseString);
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    }];
//
//    [request setTimeOutSeconds:5];
//    [request startAsynchronous];
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // get the image
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        // do something with it
        
        self.imageObj = image
        
        let cell:LabeledCheckmarkTableViewCell = self.tvCells[CELL_PROFILE_IMAGE] as! LabeledCheckmarkTableViewCell
        cell.imgCheckmark.image = UIImage(named: "tick")
        
        self.isImageSelected = true
        
        dismiss(animated: true, completion: nil)
    }
    
    func keyDidPress() {
        
    }
    
    func executeTextActionWithTag(tagID: Int) {
        
    }
    
    func activeCellByTag(tagID: Int) {
        self.activeCell = tagID
    }
    
    @objc func keyboardWillShow(notification:Notification) {
        let keyInfo = notification.userInfo
        var keyboardFrame = keyInfo?[UIKeyboardFrameEndUserInfoKey] as! CGRect
        keyboardFrame = self.profileDataTableView.convert(keyboardFrame, from: nil)
        
        let intersect = keyboardFrame.intersection(self.profileDataTableView.bounds)
        
        if !intersect.isNull {
            let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
            
            let curve =  (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! Int) << 16
            
            UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(rawValue: UIViewAnimationOptions.RawValue(curve)), animations: {
                self.profileDataTableView.contentInset = UIEdgeInsetsMake(0, 0, intersect.size.height, 0)
                self.profileDataTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, intersect.size.height, 0)
            }, completion: nil)
        }
    }
    
    @objc func keyboardWillHide(notification:Notification) {
        let rate = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        UIView.animate(withDuration: rate) {
            self.profileDataTableView.contentInset = UIEdgeInsets.zero
            self.profileDataTableView.scrollIndicatorInsets = UIEdgeInsets.zero
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
