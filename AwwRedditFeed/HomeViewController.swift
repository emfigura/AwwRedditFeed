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
    private var refreshControl:UIRefreshControl!
    private var isRefreshing = false
    
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service.delegate = self
        
        //Initial service call
        getMoreData()
        activityIndicator.startAnimating()
        
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.estimatedRowHeight = 104
        tableview.hidden = true
        
        //Creates the pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(red: 51/255, green: 102/255, blue: 153/255, alpha: 1)
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh the AWW!")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        tableview.addSubview(refreshControl)
        
    }
    
    func awwServiceSuccess(models: [AwwServiceModel]) {
        
        //If the tableview is hidden (first successful call) then we want to show it and hide
        //the indicatior
        if tableview.hidden {
            activityIndicator.stopAnimating()
            activityIndicator.hidden = true
            tableview.hidden = false
        }
        
        //If we are refreshing
        if isRefreshing {
            //We want to clear out the models and hide the refresh control
            self.models = models
            isRefreshing = false
            refreshControl.endRefreshing()
        } else {
            //Else just append the models
            self.models += models
        }
        
        self.tableview.reloadData()
        isLoading = false
    }
    
    func awwServiceFailure() {
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
        self.displayError("Error", message: "Something went wrong in the service!")
        
        if isRefreshing {
            isRefreshing = false
            refreshControl.endRefreshing()
        }
        
        
        isLoading = false
    }
    
    private func getMoreData() {
        isLoading = true
        if isRefreshing {
            service.getData("30", lastName: nil)
        } else {
            service.getData("30", lastName: models.last?.name)
        }
    }
    
    func refresh(sender:AnyObject) {
        isRefreshing = true
        getMoreData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //If we are close to the bottom of the table we want to make another service call for infinite scroll
        if indexPath.row > models.count - 10 && !isLoading && !isLoading {
            getMoreData()
        }
        
        let cell = tableview.dequeueReusableCellWithIdentifier("AwwTableViewCell", forIndexPath: indexPath) as! AwwUITableViewCell
        let model = models[indexPath.row]
        
        cell.configureCell(model.title, author: model.author, time: model.created, score: model.score, index: indexPath.row)
        cell.selectionStyle = .None
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return models.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if let destinationVC = segue.destinationViewController as? DetailsViewController, cell = sender as? AwwUITableViewCell {
            destinationVC.imageUrl = models[cell.cellIndex].imageURL
            destinationVC.shareUrl = models[cell.cellIndex].shareURL
            destinationVC.pageTitle = models[cell.cellIndex].title
        }
    }


}

