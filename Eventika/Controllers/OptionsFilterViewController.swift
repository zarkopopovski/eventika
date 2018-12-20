//
//  OptionsFilterViewController.swift
//  App
//
//  Created by Zarko Popovski on 12/4/18.
//  Copyright © 2018 App. All rights reserved.
//

import UIKit

protocol OptionsFilterViewControllerDelegate {
    func didSelectCellWithObject(asType:Any)
}

class OptionsFilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    var filterOptions:[Any] = [Any]()
    var delegate:OptionsFilterViewControllerDelegate?
    
    @IBOutlet weak var tvOptions: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        
        let object:Any?
        
        if self.filterOptions[indexPath.row] is DivisionEntity {
            object = self.filterOptions[indexPath.row] as! DivisionEntity
            
            cell.textLabel?.text = (object as! DivisionEntity).divisionName
            cell.tag = Int((object as! DivisionEntity).divisionID)!
        } else if self.filterOptions[indexPath.row] is LocationEntity {
            object = self.filterOptions[indexPath.row] as! LocationEntity
            
            cell.textLabel?.text = (object as! LocationEntity).locationName
            cell.tag = Int((object as! LocationEntity).locationID)!
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let object:Any?
        
        if self.filterOptions[indexPath.row] is DivisionEntity {
            object = self.filterOptions[indexPath.row] as! DivisionEntity
            self.delegate?.didSelectCellWithObject(asType: object)
        } else if self.filterOptions[indexPath.row] is LocationEntity {
            object = self.filterOptions[indexPath.row] as! LocationEntity
            self.delegate?.didSelectCellWithObject(asType: object)
        }
        
        self.dismiss(animated: true, completion: nil)
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
