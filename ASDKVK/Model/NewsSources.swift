//
//  Friend.swift
//  ASDKVK
//
//  Created by user on 24/04/2019.
//  Copyright © 2019 Morizo Digital. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol NewsSource {
    var title: String { get }
    var imageUrl: URL? { get }
}

class Friend: NewsSource {
    let id: Int
    let firstName: String
    let lastName: String
    let avatarUrl: URL?
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.lastName = json["last_name"].stringValue
        self.firstName = json["first_name"].stringValue
        let urlString = json["photo_100"].stringValue
        self.avatarUrl = URL(string: urlString)
    }
    
    // Protocol conformance
    var title: String { return "\(firstName) \(lastName)" }
    var imageUrl: URL? { return avatarUrl }
}

class Group: NewsSource {
    let id: Int
    let name: String
    let avatarUrl: URL?
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        let urlString = json["photo_200"].stringValue
        self.avatarUrl = URL(string: urlString)
    }
    
    // Protocol conformance
    var title: String { return name }
    var imageUrl: URL? { return avatarUrl }
}
