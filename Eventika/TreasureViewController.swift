//
//  FirstViewController.swift
//  Fiena
//
//  Created by Zarko Popovski on 11/2/18.
//  Copyright © 2018 FienaCo. All rights reserved.
//

import UIKit
import Alamofire
import PMJSON
import ImageLoader
import SVProgressHUD

class TreasureViewController: UIViewController, UITableViewDataSource, UITableViewDataSourcePrefetching, UITableViewDelegate, TreasureTableViewCellDelegate {
    
    @IBOutlet weak var tvTreasures: UITableView!
    var treasuresEntities:[TreasureEntity] = [TreasureEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.title = "Treasures"
        let customFont = UIFont(name: "FreightBigMedium", size: 20.0)
        let customLabel = UILabel()
        customLabel.font = customFont
        customLabel.text = "Treasures"
        
        self.navigationItem.titleView = customLabel
        
        self.tvTreasures.register(UINib.init(nibName: "TreasureTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TreasureTableViewCell")
        
        self.loadTreasureData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 152.0
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.treasuresEntities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TreasureTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TreasureTableViewCell") as! TreasureTableViewCell
        
        let treasureObj:TreasureEntity = self.treasuresEntities[indexPath.row]
        cell.treasurePosition.text = " " + treasureObj.treasureCategoryName + " "
        cell.treasureLocation.text = "    " + treasureObj.treasureTitle + "    "
        let imageURL = GlobalData.sharedInstance.API_TREASURES_IMAGES+treasureObj.treasureImage
        
        cell.imgTreasure.load.request(with: URL(string: imageURL)!)
        
        cell.delegate = self
        cell.tag = indexPath.row
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func cellSelectedWithID(cellID: Int) {
        NSLog("Cell with ID: %d", cellID)
        
        let treasure:TreasureEntity = self.treasuresEntities[cellID]
        
        let treasureOfferVC:TreasureDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "TreasureDetailsViewController") as! TreasureDetailsViewController
        
        //treasureOfferVC.title = treasure.treasureTitle
        treasureOfferVC.treasureID = treasure.treasureID
        
        self.navigationController?.pushViewController(treasureOfferVC, animated: true)
    }
    
    func loadTreasureData() {
        SVProgressHUD.show(withStatus: "Loading")
        Alamofire.request(GlobalData.sharedInstance.API_TREASURES).responseString(completionHandler: { (response) in
            SVProgressHUD.dismiss()
            
            let stringResponse = response.result.value!
            
            var jsonData:JSON
            
            do
            {
                let treasuresArray = try JSON.decode(stringResponse).getArray()
                
                if (treasuresArray.count) > 0 {
                    for i in 0 ..< (treasuresArray.count) {
                        let jsonObj = treasuresArray[i]
                        
                        let treasureEntity:TreasureEntity = TreasureEntity()
                        treasureEntity.treasureID = try jsonObj.getString("tr_id")
                        treasureEntity.treasureCategoryID = try jsonObj.getString("cat_id")
                        treasureEntity.treasureCategoryName = try jsonObj.getString("cat_name")
                        treasureEntity.treasureTitle = try jsonObj.getString("tr_title")
                        treasureEntity.treasureImage = try jsonObj.getString("tr_image")
                        
                        self.treasuresEntities.append(treasureEntity)
                    }
                    
                    self.tvTreasures.reloadData()
                }
                
            }
            catch
            {
                print("Error:",error)
            }
            
        })
        
    }
}

