//
//  ViewController.swift
//  developpement_approfondissement_1
//
//  Created by TheAbstractDev on 08/06/2015.
//  Copyright (c) 2015 TheAbstractDev. All rights reserved.
//

import UIKit
import CryptoSwift

class ConnexionViewController: UIViewController {
    
    @IBOutlet weak var loginInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var layer: UIView!
    
    var http = HTTPTask()
    var token:String?
    var id:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectButton.layer.backgroundColor = UIColor(red:0.234, green:0.635, blue:0.88, alpha:1).CGColor
    
        
        http.responseSerializer = JSONResponseSerializer()
        http.requestSerializer = HTTPRequestSerializer()
        http.baseURL = "https://api.betaseries.com"
        http.requestSerializer.headers["X-BetaSeries-Version"] = "2.4"
        http.requestSerializer.headers["X-BetaSeries-Key"] = "aa669b3fed9b"

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func connect(login:String, password:String) {
        if loginInput.text != "" && passwordInput != "" {
            
            let params: Dictionary<String,AnyObject> = ["login": login, "password": password]
            
            http.POST("/members/auth", parameters: params) { (response: HTTPResponse) -> Void in
                if let err = response.error {
                    println(err.localizedDescription)
                }
            
                if let json = response.responseObject as? Dictionary<String, AnyObject> {
                    var data = JSON(json)
                    
                    if data["errors"].isEmpty {
                        
                        if let token = data["token"].string {
                            self.token = token
                        }
 
                        if let id = data["user"]["id"].int {
                            self.id = id
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.performSegueWithIdentifier("connect", sender: nil)
                        })
                        
                    } else {
                        let alert = UIAlertController(title: "Erreur", message: "Votre login ou mot de passe est incorrect. Veuillez réesayer.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.presentViewController(alert, animated: true, completion: nil)
                            self.passwordInput.text = ""
                        })
                    }
                }
            }
            
        } else {
            let alertCtlr = UIAlertController(title: "Erreur", message: "Veuillez remplir les champs !", preferredStyle: UIAlertControllerStyle.Alert)
            alertCtlr.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertCtlr, animated: true, completion: nil)
        }
    }
    
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "connect" {
                let nav = segue.destinationViewController as! UINavigationController
                let destinationVC = nav.topViewController as! SeriesViewController
                destinationVC.token = self.token
                destinationVC.id = self.id
            }
        }
    }
    
    @IBAction func connectDidPressed(sender: AnyObject) {
        connect(loginInput.text, password: passwordInput.text.md5()!)
    }
    
}

