//
//  ViewController.swift
//  YelmGMap
//
//  Created by Manuel Aurora on 08.06.17.
//  Copyright © 2017 Manuel Aurora. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        YelpRequestRouter.accessToken.get() {
            self.getRestaurants()
        }
    }
    
    func getRestaurants() {
        YelpRequestRouter.businesess("restaurants").get()
    }

}

