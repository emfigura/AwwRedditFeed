//
//  HomeViewController.swift
//  AwwRedditFeed
//
//  Created by Eric on 10/20/15.
//  Copyright © 2015 Eric Figura. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController, AwwServiceDelegate, UITableViewDelegate, UITableViewDataSource {
    private let service = AwwService()
    private var models: [AwwServiceModel] = []
    private var imageCache = NSCache()
    private var isLoading = false
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service.delegate = self
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.estimatedRowHeight = 104
        getMoreData()
        activityIndicator.startAnimating()
        tableview.hidden = true
    }
    
    func awwServiceSuccess(models: [AwwServiceModel]) {
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
        tableview.hidden = false
        self.models += models
        self.tableview.reloadData()
        isLoading = false
    }
    
    func awwServiceFailure() {
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
        let alertController = UIAlertController(title: "Error!", message:
            "Something went wrong in the service!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        isLoading = false
    }
    
    func getMoreData() {
        isLoading = true
        service.getData("30", lastName: models.last?.name)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if indexPath.row > models.count - 10 && !isLoading {
            getMoreData()
        }
        
        let cell = tableview.dequeueReusableCellWithIdentifier("AwwTableViewCell", forIndexPath: indexPath) as! AwwUITableViewCell
        let model = models[indexPath.row]
        
        cell.configureCell(model.title, author: model.author, time: model.created, score: model.score, imageUrl: model.imageURL)
        cell.selectionStyle = .None
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return models.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // Create a new variable to store the instance of PlayerTableViewController
        if let destinationVC = segue.destinationViewController as? DetailsViewController, cell = sender as? AwwUITableViewCell {
            destinationVC.url = cell.imageUrl
        }
    }


}

