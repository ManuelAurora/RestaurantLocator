//
//  BusinessDetailViewController.swift
//  YelmGMap
//
//  Created by Manuel Aurora on 09.06.17.
//  Copyright © 2017 Manuel Aurora. All rights reserved.
//

import UIKit

class BusinessDetailViewController: UICollectionViewController
{
    let viewModel = DetailBusinessViewModel()
    var businessToShow: Business!
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return viewModel.getNumberOfSections()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.getNumberOfCellsIn(section: section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = BusinessCollectionViewCell()
        
        cell.titleLabel.text = businessToShow.displayInfo.name
        cell.phoneNumberLabal.text = businessToShow.displayInfo.displayPhone
        cell.ratingLabel.text = businessToShow.getRatingString()
        return cell 
    }
}
