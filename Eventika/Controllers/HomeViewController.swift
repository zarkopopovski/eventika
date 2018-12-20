//
//  HomeViewController.swift
//  App
//
//  Created by Zarko Popovski on 11/2/18.
//  Copyright © 2018 App. All rights reserved.
//

import UIKit
import Alamofire
import PMJSON
import ImageLoader
import SVProgressHUD

import MessageUI

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDataSourcePrefetching, UITableViewDelegate, BigImageInfoTableViewCellDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var btrRefer: UIButton!
    
    @IBOutlet weak var tvArticles: UITableView!
    
    var articles:[ArticleEntity] = [ArticleEntity]()
    
    var cells:[UITableViewCell] = [UITableViewCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.navigationItem.title = "Inspiring the future of feminine"
        
        let customFont = UIFont(name: "FreightBigMedium", size: 20.0)
        let customLabel = UILabel()
        customLabel.font = customFont
        customLabel.text = "Inspiring the future of feminine"
        
        self.navigationItem.titleView = customLabel
        
        
        
        self.tvArticles.register(UINib.init(nibName: "BigImageInfoTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "BigImageInfoTableViewCell")
        
        self.loadArticlesData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 272.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 272.0
        
        let cell:BigImageInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BigImageInfoTableViewCell") as! BigImageInfoTableViewCell
        
        let article:ArticleEntity = self.articles[indexPath.row]
        
        cell.txtDescription.text = article.articleTitle
     
        let imageURL = GlobalData.sharedInstance.API_ARTICLE_IMAGES+article.articleImage
        
        cell.imgBackground.load.request(with: URL(string: imageURL)!)
        
        cell.delegate = self
        cell.tag = indexPath.row
        
        self.cells.append(cell)
        
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var bigCell:BigImageInfoTableViewCell = self.cells[indexPath.row] as! BigImageInfoTableViewCell
//        if bigCell.txtDescription.frame.size.height > 44 && !bigCell.isTextLabelModified {
//            var txtFrame:CGRect = bigCell.txtDescription.frame
//            txtFrame.size.height += 20
//
//            bigCell.txtDescription.frame = txtFrame
//            bigCell.txtDescription.layoutIfNeeded()
//            bigCell.isTextLabelModified = true
//        }
        
        return bigCell
    }
    
    func executeCellWithID(cellID: Int) {
        let article:ArticleEntity = self.articles[cellID]
        
        let articleDetails:ArticleDescriptionViewController = self.storyboard?.instantiateViewController(withIdentifier: "ArticleDescriptionViewController") as! ArticleDescriptionViewController
        articleDetails.articleEntity = article
        
        self.navigationController?.pushViewController(articleDetails, animated: true)
    }

    func loadArticlesData() {
        SVProgressHUD.show(withStatus: "Loading")
        Alamofire.request(GlobalData.sharedInstance.API_ARTICLES).responseString(completionHandler: { (response) in
            SVProgressHUD.dismiss()
            
            let stringResponse = response.result.value!
            
            var jsonData:JSON
            
            do
            {
                let articlesArray = try JSON.decode(stringResponse).getArray()
                
                if (articlesArray.count) > 0 {
                    for i in 0 ..< (articlesArray.count) {
                        let jsonObj = articlesArray[i]
                        
                        let articleEntity:ArticleEntity = ArticleEntity()
                        articleEntity.articleID = try jsonObj.getString("article_id")
                        articleEntity.articleTitle = try jsonObj.getString("title")
                        articleEntity.articleContent = try jsonObj.getString("content")
                        articleEntity.articleImage = try jsonObj.getString("image")
                        
                        self.articles.append(articleEntity)
                    }
                    
                    self.tvArticles.reloadData()
                }
                
            }
            catch
            {
                print("Error:",error)
            }
            
        })
        
    }
    
    @IBAction func btnReferAction(_ sender: UIButton) {
        self.sendEmail()
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["refermember@eventika.co"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
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
