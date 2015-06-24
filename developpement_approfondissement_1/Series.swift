//
//  Series.swift
//  developpement_approfondissement_1
//
//  Created by TheAbstractDev on 17/06/2015.
//  Copyright (c) 2015 TheAbstractDev. All rights reserved.
//

import Foundation
import UIKit

class Serie {
    
    var http = HTTPTask()
    var serieTitle: [String] = []
    var serieId: [Int] = []
    
    init(token: String!) {
        http.responseSerializer = JSONResponseSerializer()
        http.requestSerializer = HTTPRequestSerializer()
        http.baseURL = "https://api.betaseries.com"
        http.requestSerializer.headers["X-BetaSeries-Version"] = "2.4"
        http.requestSerializer.headers["X-BetaSeries-Key"] = "aa669b3fed9b"
        http.requestSerializer.headers["X-BetaSeries-Token"] = token
    }
    
    func getSeries(id uid:Int, array arr:NSMutableDictionary, tableView tblv:UITableView) {
        
        let params: Dictionary<String,AnyObject> = ["id": uid]
        http.GET("/members/infos", parameters: params) {
            (response: HTTPResponse) -> Void in
            
            if let err = response.error {
                println(err)
            }
            
            if let res: AnyObject = response.responseObject {
                var data = JSON(res)
            
                if data["errors"].isEmpty {
                    arr.removeAllObjects()
                    for var i = 0; i < data["member"]["shows"].count; i++ {
                        arr.setValuesForKeysWithDictionary([data["member"]["shows"][i]["id"].int! : data["member"]["shows"][i]["title"].string!])
                    }
                    
                    println(arr)
                }
                
                for (key, value) in arr {
                    self.serieTitle.insert(value as! String, atIndex: 0)
                    self.serieId.insert(key as! Int, atIndex: 0)
                }
                    
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        SwiftLoader.hide()
                        tblv.reloadData()
                    }
                }
            }
        }
    }
    
    func searchSeries(array arr:NSMutableDictionary, tableView tblv:UITableView, serieName:String) {
        let params: Dictionary<String,AnyObject> = ["title" : serieName, "order": "alphabetical"]
        http.GET("/shows/search", parameters: params) {
            (response: HTTPResponse) -> Void in
            
            if let err = response.error {
                println(err)
            }
            
            if let res: AnyObject = response.responseObject {
                var data = JSON(res)
                
                if data["errors"].isEmpty {
                    arr.removeAllObjects()
                    for var i = 0; i < data["shows"].count; i++ {
                        arr.setValuesForKeysWithDictionary([data["shows"][i]["id"].int! : data["shows"][i]["title"].string!])
                    }
                    println(arr)
                }
                
                for (key, value) in arr {
                    self.serieTitle.insert(value as! String, atIndex: 0)
                    self.serieId.insert(key as! Int, atIndex: 0)
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        SwiftLoader.hide()
                        tblv.reloadData()
                    }
                }
            }
        }

    }
    
    func addSerieWithId(serieId:Int) {
        let params: Dictionary<String,AnyObject> = ["id": serieId]
        
        http.POST("/shows/show", parameters: params, completionHandler: {
            (response: HTTPResponse) in
            
            if let err = response.error {
                println(err)
            }
            
            if let res: AnyObject = response.responseObject {
                var data = JSON(res)
                
                if data["errors"].isEmpty {
                    println("Serie Added")
                }
            }
        })
    }
    
    func deleteSerieWithId(serieId:Int) {
        let params: Dictionary<String,AnyObject> = ["id": serieId]
        
        http.DELETE("/shows/show", parameters: params, completionHandler: {
            (response: HTTPResponse) in
            
            if let err = response.error {
                println(err)
            }
            
            if let res: AnyObject = response.responseObject {
                var data = JSON(res)
                
                if data["errors"].isEmpty {
                    println("Serie archive")
                }
            }
        })
    }

    
    func getDetailOfSerieWithId(id:Int, imageView:UIImageView!, view: UIViewController, serieTitle:UILabel, numberOfSeasons:UILabel, numberOfEpisodes:UILabel, descriptionOfSerie:UITextView, genre:UILabel, duree:UILabel) {
        let params: Dictionary<String,AnyObject> = ["id": id]
        http.GET("/shows/display", parameters: params) {
            (response: HTTPResponse) -> Void in
            
            if let err = response.error {
                println(err)
            }
            
            if let res: AnyObject = response.responseObject {
                var data = JSON(res)
                
                if data["errors"].isEmpty {
                    dispatch_async(dispatch_get_main_queue(),{
                        serieTitle.text = data["show"]["title"].string!
                        view.title = data["show"]["title"].string!
                        numberOfSeasons.text = data["show"]["seasons"].string!
                        numberOfEpisodes.text = data["show"]["episodes"].string!
                        descriptionOfSerie.text = data["show"]["description"].string!
                        genre.text = data["show"]["genres"][0].string!
                        duree.text = data["show"]["length"].string!
                    })
                
                    println(data["show"])
                }
            }
        }
        
        http.GET("/shows/pictures", parameters: params) {
            (response: HTTPResponse) -> Void in
            if let err = response.error {
                println(err)
            }
            
            if let res: AnyObject = response.responseObject {
                var data = JSON(res)
                
                if data["errors"].isEmpty {
                    dispatch_async(dispatch_get_main_queue(),{
                        imageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: data["pictures"][0]["url"].string!)!)!)
                    })
                }
            }

        }
    }

}