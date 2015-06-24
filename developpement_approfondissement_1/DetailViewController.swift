//
//  DetailViewController.swift
//  
//
//  Created by Sofiane Beors on 19/06/2015.
//
//

import UIKit

class DetailViewController: UIViewController {

    var token:String!
    var serieId:Int!
    var s: Serie!
    var serieInfos = NSMutableArray()
    var seasons = NSArray()
    @IBOutlet weak var btn: UIButton!
    
    @IBOutlet weak var serieImage: UIImageView!
    @IBOutlet weak var serieTitle: UILabel!
    @IBOutlet weak var numberOfSeasons: UILabel!
    @IBOutlet weak var numberOfEpisodes: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var duree: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "archive")
        
        self.btn.layer.cornerRadius = 25
        self.btn.layer.borderColor = UIColor(red:0.216, green:0.64, blue:0.88, alpha:1).CGColor
        self.btn.layer.borderWidth = 1
        
        s = Serie(token: self.token)
        s.getDetailOfSerieWithId(self.serieId, imageView: self.serieImage, view: self, serieTitle: self.serieTitle, numberOfSeasons: self.numberOfSeasons, numberOfEpisodes: self.numberOfEpisodes, descriptionOfSerie:self.desc, genre:self.genre, duree:self.duree)
        
    }
    
    func archive() {
        let alertCtlr = UIAlertController(title: "Serie Archivé", message: "la série à bien été archivé", preferredStyle: UIAlertControllerStyle.Alert)
        alertCtlr.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertCtlr, animated: true, completion: nil)
        
        s.deleteSerieWithId(self.serieId)
        self.performSegueWithIdentifier("archived", sender: self)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "seasons" {
                if let identifier = segue.identifier {
                    let seasonsVC = segue.destinationViewController as! SaisonsTableViewController
                    seasonsVC.serieId = self.serieId
                    seasonsVC.token = self.token
                    seasonsVC.seasons = self.seasons
                }

            }
        
        }

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
