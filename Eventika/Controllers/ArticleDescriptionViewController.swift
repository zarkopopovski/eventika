//
//  ArticleDescriptionViewController.swift
//  App
//
//  Created by Zarko Popovski on 11/17/18.
//  Copyright © 2018 App. All rights reserved.
//

import UIKit
import ImageLoader

class ArticleDescriptionViewController: UIViewController {

    @IBOutlet weak var imgArticle: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtContent: UITextView!
    
    var articleEntity:ArticleEntity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let customFont = UIFont(name: "FreightBigMedium", size: 20.0)
        let customLabel = UILabel()
        customLabel.font = customFont
        customLabel.text = "EVENTIKA"
        
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
        
        self.lblTitle.text = self.articleEntity.articleTitle
        
        var lblTitleFrame = self.lblTitle.frame
        
        if lblTitleFrame.size.height > 58 {
            lblTitleFrame.size.height += 30
            self.lblTitle.frame = lblTitleFrame
            
            self.lblTitle.layoutIfNeeded()
            self.lblTitle.layoutSubviews()
        }
        
        self.txtContent.text = self.articleEntity.articleContent
        
        let imageURL = GlobalData.sharedInstance.API_ARTICLE_IMAGES+self.articleEntity.articleImage
        
        self.imgArticle.load.request(with: URL(string: imageURL)!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
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
