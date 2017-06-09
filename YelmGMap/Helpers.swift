//
//  Helpers.swift
//  YelmGMap
//
//  Created by Manuel Aurora on 08.06.17.
//  Copyright © 2017 Manuel Aurora. All rights reserved.
//
import Foundation
import Alamofire

extension Notification.Name
{
    static let didRecieveCoordinate = Notification.Name("ManagerRecievedCoordinate")
    static let didRecieveBusinesess = Notification.Name("RequestRouterRecievedBusinesess")
}

func removeAllAlamofireNetworking() {
    Alamofire.SessionManager.default.session.getAllTasks { tasks in
        tasks.forEach { $0.cancel(); print("cancelled task") }
    }
}
