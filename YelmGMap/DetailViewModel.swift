//
//  DetailViewModel.swift
//  YelmGMap
//
//  Created by Manuel Aurora on 09.06.17.
//  Copyright © 2017 Manuel Aurora. All rights reserved.
//

import Foundation

class DetailBusinessViewModel
{
    private let datasource = DetailBusinessDataSource()
    
    func sectionTypeFor(indexPath: IndexPath) -> DetailBusinessDataSource.SectionType {
        
        return datasource.sections[indexPath.row]
    }
    
    func getNumberOfCellsIn(section: Int) -> Int {
        
        let sectionType = datasource.sections[section]
        
        switch sectionType
        {
        case .basicInfo, .categories, .image, .reviews: return 1
        }
    }
    
    func getNumberOfSections() -> Int {
        
        return datasource.sections.count
    }    
   
}

