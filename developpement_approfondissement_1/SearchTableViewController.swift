//
//  SearchTableViewController.swift
//  
//
//  Created by Sofiane Beors on 19/06/2015.
//
//

import UIKit


class SearchTableViewController: UITableViewController {

    var resultArray = NSMutableArray()
    var token:String!
    var s:Serie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Ajouter une serie"

        s = Serie(token: self.token)
        
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.spinnerColor = UIColor(rgba: "#3498db")
        config.titleTextColor = UIColor(rgba: "#3498db")
        
        config.backgroundColor = UIColor(rgba: "#ecf0f1")
        
        SwiftLoader.setConfig(config)
        
        SwiftLoader.show(title: "Chargement", animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.s.searchSeries(array: self.resultArray, tableView: self.tableView, serieName: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("resultCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = self.resultArray.objectAtIndex(indexPath.row) as? String

        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let rotateTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        cell.layer.transform = rotateTransform
        
        UIView.animateWithDuration(0.8, animations: { () -> Void in
            cell.layer.transform = CATransform3DIdentity
        })
    }

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
