//
//  SOCEvent.swift
//  MDB Social No Starter
//
//  Created by Michael Lin on 10/9/21.
//

import Foundation

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

typealias SOCEventID = String

struct SOCEvent: Codable {
    
    @DocumentID var id: SOCEventID? = UUID().uuidString
    
    var name: String
    
    var description: String
    
    var photoURL: String
    
    var startTimeStamp: Timestamp
    
    var creator: SOCUserID
    
    var rsvpUsers: [SOCUserID]
    
    var startDate: Date {
        get {
            let tsDate = startTimeStamp.dateValue()
            return tsDate
        }
    }
}
