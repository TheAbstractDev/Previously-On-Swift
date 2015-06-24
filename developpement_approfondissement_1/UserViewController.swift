//
//  UserViewController.swift
//  
//
//  Created by Sofiane Beors on 21/06/2015.
//
//

import UIKit

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var token:String!
    var uid:Int!
    var friends = NSMutableDictionary()
    var user:User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userPicture.layer.cornerRadius = self.userPicture.frame.height / 2
        
        self.title = "Mon Compte"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        user = User(token: self.token)
        
        user.getInfosAndFriends(id: self.uid, array: self.friends, tableView: self.tableView, userImage: self.userPicture, loginLabel: self.username)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friends", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = user.friendLogin[indexPath.row] as String
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var block = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Bloquer") { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            self.user.blockUser(self.user.friendId[indexPath.row] as Int)
        }
        
        var delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Supprimer") { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            self.user.deleteUser(self.user.friendId[indexPath.row] as Int, tableView: self.tableView)
        }
        
        return [block, delete]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
