//
//  UIViewController + StoryboardInstantiation
//  YelmGMap
//
//  Created by Manuel Aurora on 13.06.17.
//  Copyright © 2017 Manuel Aurora. All rights reserved.
//

import UIKit

protocol StoryboardInstantiation {}

extension StoryboardInstantiation
{
    typealias optionalVcClosure = ((Self) -> ())?
    
    static func storyboardInstance(_ completion: optionalVcClosure = nil) -> Self {
        
        let identifier = String(describing: Self.self)
        
        var sbName = String(describing: Self.self)
        
        if Bundle.main.path(forResource: sbName, ofType: "storyboardc") == nil
        {
            sbName = "Main"
        }
        
        let storyboard = UIStoryboard(name: sbName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier) as! Self
        
        if let completion = completion
        {
            completion(vc)
        }
        
        return vc
    }
}
