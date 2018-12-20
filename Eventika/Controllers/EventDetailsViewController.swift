//
//  EventDetailsViewController.swift
//  App
//
//  Created by Zarko Popovski on 11/26/18.
//  Copyright © 2018 App. All rights reserved.
//

import UIKit

import Alamofire
import PMJSON
import ImageLoader
import SVProgressHUD

class EventDetailsViewController: UIViewController {

    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var lblEvent: UILabel!
    @IBOutlet weak var lblEventTime: UILabel!
    @IBOutlet weak var lblEventLocation: UILabel!
    
    @IBOutlet weak var btnBookEvent: UIButton!
    
    @IBOutlet weak var txtvEvent: UITextView!
    
    var eventEntity:EventEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //self.navigationItem.title = "Event"
        let customFont = UIFont(name: "FreightBigMedium", size: 20.0)
        let customLabel = UILabel()
        customLabel.font = customFont
        customLabel.text = "Event"
        
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
        
        self.showEventEntity(eventEntity: self.eventEntity!)
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnBookEvent(_ sender: UIButton) {
        
    }
    
    func showEventEntity(eventEntity: EventEntity) {
        self.eventEntity = eventEntity
        
        self.lblEvent.text = eventEntity.eventTitle
        self.txtvEvent.text = eventEntity.eventDescription
        
        self.lblEventTime.text = eventEntity.eventTime
        self.lblEventLocation.text = eventEntity.eventLocationName
        
        let imageURL:String = GlobalData.sharedInstance.API_EVENTS_IMAGES+eventEntity.eventImage
        
        self.imgEvent.load.request(with: URL(string: imageURL)!)
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
