//
//  ReviewCollectionViewCell.swift
//  YelmGMap
//
//  Created by Manuel Aurora on 13.06.17.
//  Copyright © 2017 Manuel Aurora. All rights reserved.
//

import UIKit

class ReviewCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var aspectRationConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImageView: CachedImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBAction func SeeMoreButtonTapped(_ sender: UIButton) {
        

    }
    
    override func didMoveToSuperview() {
        
        let contentSize = commentTextView.sizeThatFits(commentTextView.bounds.size)
        var frame = commentTextView.frame
        frame.size.height = contentSize.height
        commentTextView.frame = frame
        
        aspectRationConstraint = NSLayoutConstraint(item: commentTextView,
                                                    attribute: .height,
                                                    relatedBy: .equal,
                                                    toItem:     commentTextView,
                                                    attribute: .width, multiplier: commentTextView.bounds.height/commentTextView.bounds.width, constant: 1)
        commentTextView.addConstraint(aspectRationConstraint!)        
    }
    
    func setupWith(review: Review) {
        usernameLabel.text = review.userName
        dateLabel.text = review.timeCreated
        userImageView.loadImage(from: review.userImageUrl)
        commentTextView.text = review.reviewText
    }
}
