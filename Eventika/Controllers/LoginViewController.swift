//
//  LoginViewController.swift
//  App
//
//  Created by Zarko Popovski on 11/2/18.
//  Copyright © 2018 App. All rights reserved.
//

import UIKit
import Alamofire
import PMJSON

import IHKeyboardAvoiding

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var loginHolderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.isHidden = true
    
        KeyboardAvoiding.avoidingView = self.loginHolderView
        
        let userDefaults:UserDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: "is_logged") {
            let userID = userDefaults.value(forKey: "user_id") as! String
            Alamofire.request(GlobalData.sharedInstance.API_LOGIN, method: .post, parameters:["user_id":userID]).responseString { (response) in
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
            };
        } else if !userDefaults.bool(forKey: "is_registeerd") {
            let registerVC:RegisterViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
            
            self.navigationController?.pushViewController(registerVC, animated: true)
        }
    }
    
    @IBAction func btnLoginAction(_ sender: UIButton) {
        if self.txtUsername.text != "" && self.txtPassword.text != "" {
            Alamofire.request(GlobalData.sharedInstance.API_LOGIN, method: .post, parameters:
                ["user_email":self.txtUsername.text!, "user_password":self.txtPassword.text!]).responseString { (response) in
                let stringResponse = response.result.value
                
                var jsonData:JSON
                
                do
                {
                    jsonData = try JSON.decode(stringResponse!)
                    
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
                
            };
            
        } else {
            self.txtUsername.borderStyle = .line
            self.txtUsername.layer.borderWidth = 1.0;
            self.txtUsername.layer.borderColor = (UIColor.red).cgColor
            
            self.txtPassword.borderStyle = .line
            self.txtPassword.layer.borderWidth = 1.0;
            self.txtPassword.layer.borderColor = (UIColor.red).cgColor
            
            let alertCnt = UIAlertController.init(title: "Error", message: "Please fill the required fields or wrong credentials", preferredStyle: UIAlertControllerStyle.alert)
            
            let actionOK = UIAlertAction.init(title: "Close", style: UIAlertActionStyle.default) { (action) in
                
            }
            
            alertCnt.addAction(actionOK)
            
            self.present(alertCnt, animated: true) {
                
            };
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
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
