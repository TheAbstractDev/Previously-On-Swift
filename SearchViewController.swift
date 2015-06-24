//
//  SearchViewController.swift
//  
//
//  Created by Sofiane Beors on 21/06/2015.
//
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var resultArray = NSMutableDictionary()
    var token:String!
    var s:Serie!
    var serie:Int?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(self.token)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.title = "Ajouter une serie"
        self.textField.backgroundColor = UIColor(rgba: "#E9EAEC")
        self.textField.layer.cornerRadius = 4
        self.textField.textAlignment = .Center
        self.textField.attributedPlaceholder = NSAttributedString(string: "Rechercher une serie", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        
        s = Serie(token: self.token)
        
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.spinnerColor = UIColor(rgba: "#3498db")
        config.titleTextColor = UIColor(rgba: "#3498db")
        
        config.backgroundColor = UIColor(rgba: "#ecf0f1")
        
        SwiftLoader.setConfig(config)
        
        
    }
    
    @IBAction func searchSerieAction(sender: AnyObject) {
        SwiftLoader.show(title: "Chargement", animated: true)
        self.s.searchSeries(array: self.resultArray, tableView: self.tableView, serieName: self.textField.text)

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("resultCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = s.serieTitle[indexPath.row] as String
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let rotateTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        cell.layer.transform = rotateTransform
        
        UIView.animateWithDuration(0.8, animations: { () -> Void in
            cell.layer.transform = CATransform3DIdentity
        })
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow()
        let cell = tableView.cellForRowAtIndexPath(indexPath!)
        self.serie = s.serieId[indexPath!.row] as Int
        
        if let serieId = self.serie {
            s.addSerieWithId(serieId)
            let alertCtlr = UIAlertController(title: "Serie Ajouté", message: "la serie \(s.serieTitle[indexPath!.row] as String) à bien été ajouté", preferredStyle: UIAlertControllerStyle.Alert)
            alertCtlr.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertCtlr, animated: true, completion: nil)

        }
    }

}
