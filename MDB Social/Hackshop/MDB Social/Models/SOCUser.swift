//
//  SOCUser.swift
//  MDB Social No Starter
//
//  Created by Michael Lin on 10/9/21.
//

import Foundation
import FirebaseFirestoreSwift

typealias SOCUserID = String

struct SOCUser: Codable {
    @DocumentID var uid: SOCUserID?
    
    var username: String
    
    var email: String
    
    var fullname: String
    
    var savedEvents: [SOCEventID]
}
