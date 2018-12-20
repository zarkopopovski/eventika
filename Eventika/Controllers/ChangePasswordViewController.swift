//
//  ChangePasswordViewController.swift
//  App
//
//  Created by Zarko Popovski on 11/26/18.
//  Copyright © 2018 App. All rights reserved.
//

import UIKit
import Alamofire
import PMJSON
import SVProgressHUD

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var tvPassword: UITextField!
    @IBOutlet weak var tvConfirmPassword: UITextField!
    
    @IBOutlet weak var btnSaveChanges: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //self.navigationItem.title = "Change Password"
        let customFont = UIFont(name: "FreightBigMedium", size: 20.0)
        let customLabel = UILabel()
        customLabel.font = customFont
        customLabel.text = "Change password"
        
        self.navigationItem.titleView = customLabel
        
        self.navigationItem.backBarButtonItem = nil
        
        var backButtonBackgroundImage = #imageLiteral(resourceName: "left-arrow-black")
        
        backButtonBackgroundImage =
            backButtonBackgroundImage.resizableImage(withCapInsets:
                UIEdgeInsets(top: 0, left: backButtonBackgroundImage.size.width - 1, bottom: 0, right: 0))
        
        let buttonSmall = UIButton(type: .custom)
        buttonSmall.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        buttonSmall.setImage(backButtonBackgroundImage, for: .normal)
        buttonSmall.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: buttonSmall)
        
        self.navigationItem.leftBarButtonItem = barButton
    }

    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveChangesAction(_ sender: UIButton) {
        if self.tvPassword.text != self.tvConfirmPassword.text  {
            
            let alertCnt = UIAlertController.init(title: "Error", message: "Please enter the same password twice", preferredStyle: UIAlertControllerStyle.alert)
            
            let actionOK = UIAlertAction.init(title: "Close", style: UIAlertActionStyle.default) { (action) in
                
            }
            
            alertCnt.addAction(actionOK)
            
            self.present(alertCnt, animated: true) {
                
            };
            
            return
        }
        
        SVProgressHUD.show(withStatus: "Loading")
        Alamofire.request(GlobalData.sharedInstance.API_SET_PASSWORD, method:.post, parameters:["user_id":GlobalData.sharedInstance.memberEntity?.memberID, "user_password":self.tvPassword.text]).responseString(completionHandler: { (response) in
            SVProgressHUD.dismiss()
            
            let stringResponse = response.result.value!
            
            var jsonData:JSON
            
            do
            {
                let responseArray = try JSON.decode(stringResponse).getObject()
                
                if responseArray["status"] == "ok" {
                    
                    let alertCnt = UIAlertController.init(title: "Info", message: "Password is changed successfully", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let actionOK = UIAlertAction.init(title: "Close", style: UIAlertActionStyle.default) { (action) in
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    alertCnt.addAction(actionOK)
                    
                    self.present(alertCnt, animated: true) {
                        
                    };
                    
                } else {
                    let alertCnt = UIAlertController.init(title: "Error", message: "Problem by changing the password", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let actionOK = UIAlertAction.init(title: "Close", style: UIAlertActionStyle.default) { (action) in
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    alertCnt.addAction(actionOK)
                    
                    self.present(alertCnt, animated: true) {
                        
                    };
                }
                
            }
            catch
            {
                print("Error:",error)
            }
            
        })
        
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
