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
    let sections: [SectionType] = [.basicInfo, .reviews]
    var reviews: [Review] {
        return UserStateMachine.shared.reviews
    }
}

extension DetailBusinessDataSource
{
    enum SectionType
    {
        case basicInfo        
        case reviews
    }       
}
