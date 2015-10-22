//
//  AwwUITableViewCell.swift
//  AwwRedditFeed
//
//  Created by Eric on 10/20/15.
//  Copyright © 2015 Eric Figura. All rights reserved.
//

import UIKit

class AwwUITableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    var cellIndex: Int!
    
    func configureCell(title: String, author: String, time: Double, score: Int, index: Int) {
        titleLabel.text = title
        authorLabel.text = author
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = NSDate(timeIntervalSince1970: time)
        let timeAsString = dateFormatter.stringFromDate(date)
        
        timeLabel.text = timeAsString
        scoreLabel.text = String(score)
        cellIndex = index
    }
    
    

}
