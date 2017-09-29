//
//  Message.swift
//  Chatty
//
//  Created by onur hüseyin çantay on 25/09/2017.
//  Copyright © 2017 onur hüseyin çantay. All rights reserved.
//

import UIKit
import Firebase
class Message {
    var fromId : String?
    var text : String?
    var timestamp : NSNumber?
    var toId : String?
    
    func getChatPartnerId () -> String? {
        return self.fromId == Firebase.Auth.auth().currentUser?.uid ? toId : fromId

    }
}
