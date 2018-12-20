//
//  GlobalData.swift
//  App
//
//  Created by Zarko Popovski on 11/5/18.
//  Copyright © 2018 App. All rights reserved.
//

import UIKit

class GlobalData: NSObject {
    static let sharedInstance = GlobalData()
    
    var memberEntity:MemberEntity?
    
    let API_TOKEN = ""
    
    let BASE_URL = ""
    
    let API_REGISTER = ""
    let API_LOGIN = ""
    
    let API_ARTICLES = ""
    let API_ARTICLE_IMAGES = ""
    
    let API_SET_PASSWORD = ""
    
    let API_EVENTS = ""
    let API_EVENTS_IMAGES = ""
    
    let API_EXTRAS = ""
    
    var isLogged:Bool = false
}
