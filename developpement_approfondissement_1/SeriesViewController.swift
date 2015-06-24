//
//  SeriesViewController.swift
//  
//
//  Created by Sofiane Beors on 19/06/2015.
//
//

import UIKit

class SeriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var series = NSMutableDictionary()
    var token:String!
    var s:Serie!
    var id:Int!
    var serieId:Int!
    var serieTitle:String!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        s = Serie(token: self.token)
        
        println(self.id)
        
//        var gesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressed:")
//        gesture.minimumPressDuration = 1.0
//        self.view.addGestureRecognizer(gesture)
        
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.spinnerColor = UIColor(rgba: "#3498db")
        config.titleTextColor = UIColor(rgba: "#3498db")
        
        config.backgroundColor = UIColor(rgba: "#ecf0f1")
        
        SwiftLoader.setConfig(config)
        
        SwiftLoader.show(title: "Chargement", animated: true)
        
    }
    
//    func longPressed(longPress: UIGestureRecognizer)
//    {
//        if longPress.state == UIGestureRecognizerState.Ended {
//            println("ended")
//        } else if longPress.state == UIGestureRecognizerState.Began {
//            self.performSegueWithIdentifier("detail", sender: self)
//        }
//    }
    
    override func viewWillAppear(animated: Bool) {
        s.getSeries(id: self.id, array: self.series, tableView: self.tableView)
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
        return self.series.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = s.serieTitle[indexPath.row] as String
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
                case "search":
                    let searchVC = segue.destinationViewController as! SearchViewController
                    searchVC.token = self.token
                
                case "detail":
                    let detailVC = segue.destinationViewController as! DetailViewController
                    detailVC.serieId = self.serieId
                    detailVC.token = self.token

                case "user":
                    let userVC = segue.destinationViewController as! UserViewController
                    userVC.token = self.token
                    userVC.uid = self.id
                
                default:
                    println("default")
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow()
        let cell = tableView.cellForRowAtIndexPath(indexPath!)
        self.serieId = s.serieId[indexPath!.row] as Int
        println(self.serieId)
        self.performSegueWithIdentifier("detail", sender: self)
    }

}
