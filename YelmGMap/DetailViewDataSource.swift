//
//  DetailBuisnessInfoViewModel
//  YelmGMap
//
//  Created by Manuel Aurora on 09.06.17.
//  Copyright © 2017 Manuel Aurora. All rights reserved.
//

import Foundation

class DetailBusinessDataSource
{
    let sections: [SectionType] = [.image, .basicInfo, .categories, .reviews]
}

extension DetailBusinessDataSource
{
    enum SectionType
    {
        case basicInfo
        case image
        case categories
        case reviews
    }
    
    
    
}
