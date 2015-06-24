//
//  Series.swift
//  developpement_approfondissement_1
//
//  Created by TheAbstractDev on 17/06/2015.
//  Copyright (c) 2015 TheAbstractDev. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    var http = HTTPTask()
    var friendLogin: [String] = []
    var friendId: [Int] = []
    
    init(token: String!) {
        http.responseSerializer = JSONResponseSerializer()
        http.requestSerializer = HTTPRequestSerializer()
        http.baseURL = "https://api.betaseries.com"
        http.requestSerializer.headers["X-BetaSeries-Version"] = "2.4"
        http.requestSerializer.headers["X-BetaSeries-Key"] = "aa669b3fed9b"
        http.requestSerializer.headers["X-BetaSeries-Token"] = token
    }
    
    func getInfosAndFriends(id uid:Int, array arr:NSMutableDictionary, tableView tblv:UITableView, userImage: UIImageView, loginLabel:UILabel) {
        
        let params: Dictionary<String,AnyObject> = ["id": uid, "summary": true]
        http.GET("/members/infos", parameters: params) {
            (response: HTTPResponse) -> Void in
            
            if let err = response.error {
                println(err)
            }
            
            if let res: AnyObject = response.responseObject {
                var data = JSON(res)
                
                if data["errors"].isEmpty {
                    dispatch_async(dispatch_get_main_queue(),{
                        loginLabel.text = data["member"]["login"].string!
                        userImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: data["member"]["avatar"].string!)!)!)
                    })
                    
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        tblv.reloadData()
                    }
                }
            }
        }
        
        http.GET("/friends/list", parameters: ["id": uid]) {
            (response: HTTPResponse) -> Void in
            
            if let err = response.error {
                println(err)
            }
            
            if let res: AnyObject = response.responseObject {
                var data = JSON(res)
                
                if data["errors"].isEmpty {
                    arr.removeAllObjects()
                    for var i = 0; i < data["users"].count; i++ {
                        arr.setValuesForKeysWithDictionary([data["users"][i]["id"].int! : data["users"][i]["login"].string!])
                    }
                }
                
                for (key, value) in arr {
                    self.friendLogin.insert(value as! String, atIndex: 0)
                    self.friendId.insert(key as! Int, atIndex: 0)
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        tblv.reloadData()
                    }
                }
            }
        }

    }
    
    func blockUser(id:Int) {
        http.POST("/friends/block", parameters: ["id": id], completionHandler: {
            (response: HTTPResponse) in
            
            if let err = response.error {
                println(err)
            }
            
            if let res: AnyObject = response.responseObject {
                var data = JSON(res)
                
                if data["errors"].isEmpty {
                    println("user blocked")
                }
            }
        })

    }
    
    func deleteUser(id:Int, tableView tblv:UITableView) {
        http.DELETE("/friends/friend", parameters: ["id": id], completionHandler: {
            (response: HTTPResponse) in
            
            if let err = response.error {
                println(err)
            }
            
            if let res: AnyObject = response.responseObject {
                var data = JSON(res)
                
                if data["errors"].isEmpty {
                    println("user deleted")
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        tblv.reloadData()
                    }
                }
            }
        })
        
    }


}