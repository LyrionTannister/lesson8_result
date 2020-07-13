//
//  Session.swift
//  VK_Messages
//
//  Created by user on 23/03/2019.
//  Copyright © 2019 Morizo Digital. All rights reserved.
//

import Foundation

class Session {
    public static let shared = Session()
    
    var id = 0
    var token = ""
    var longPoll = LongPoll()
    
    var stringId: String {
        return String(id)
    }
    
    private init() { }
    
    struct LongPoll {
        var server = ""
        var ts: TimeInterval = 0
        var pts: Int = 0
        var key = ""
    }
}
