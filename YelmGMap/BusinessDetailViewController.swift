//
//  BusinessDetailViewController.swift
//  YelmGMap
//
//  Created by Manuel Aurora on 09.06.17.
//  Copyright © 2017 Manuel Aurora. All rights reserved.
//

import UIKit

class BusinessDetailViewController: UICollectionViewController, StoryboardInstantiation
{
    let viewModel = DetailBusinessViewModel()
    private let nc = NotificationCenter.default
    var businessToShow: Business!
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeNotifications()
              
        YelpRequestRouter.reviews(businessToShow.devInfo.id).get()
    }
    deinit {
        nc.removeObserver(self)
         print("Debug: DEINIT")
    }
    
    private func subscribeNotifications() {
        
        nc.addObserver(forName: .didRecieveReviews,
                       object: nil,
                       queue: nil) { [weak self]_ in
                        self?.collectionView?.reloadSections(IndexSet(integer: 1)) //hardcoded
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return viewModel.getNumberOfSections()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.getNumberOfCellsIn(section: section)
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        let section = viewModel.sectionTypeFor(indexPath: indexPath)
        let id = String(describing: DetailInfoHeader.self)
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: id,
                                                                     for: indexPath) as! DetailInfoHeader
        
        var text: String
        
        switch section
        {
        case .basicInfo: text = "Description"
        case .reviews:   text = "Reviews"
        }
        
        header.title.text = text
        
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentSection = viewModel.sectionTypeFor(indexPath: indexPath)
        
        //Yeah, I know that this code repeat itself.
        //In this particular case refactoring is not a must.
        
        var cellId: String
        
        switch currentSection
        {
        case .basicInfo:
            cellId = String(describing: BusinessCollectionViewCell.self)
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
                                                          for: indexPath) as! BusinessCollectionViewCell
            
            cell.titleLabel.text = businessToShow.displayInfo.name
            cell.phoneNumberLabal.text = businessToShow.displayInfo.displayPhone
            cell.ratingLabel.text = businessToShow.getRatingString()
            cell.mainImageView.loadImage(from: businessToShow.devInfo.imageUrl)
            cell.categoryLabel.text = businessToShow.devInfo.businessCategories.first?.title
            return cell
            
        case .reviews:
            cellId = String(describing: ReviewCollectionViewCell.self)
            
            let review = viewModel.getReviewForCellAt(indexPath: indexPath)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
                                                          for: indexPath) as! ReviewCollectionViewCell            
            
            cell.setupWith(review: review)
            cell.starsLabel.text = businessToShow.getRatingString()
            
            return cell
        }
    }
}

extension BusinessDetailViewController: UICollectionViewDelegateFlowLayout
{    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
