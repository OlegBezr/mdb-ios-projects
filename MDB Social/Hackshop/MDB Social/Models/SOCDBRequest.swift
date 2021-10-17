//
//  SOCDBRequest.swift
//  MDB Social No Starter
//
//  Created by Michael Lin on 10/9/21.
//

import Foundation
import FirebaseFirestore

class FIRDatabaseRequest {
    
    static let shared = FIRDatabaseRequest()
    
    let db = Firestore.firestore()
    
    func setUser(_ user: SOCUser, completion: (()->Void)?) {
        /* TODO: Hackshop */
    }
    
    func setEvent(_ event: SOCEvent, completion: (()->Void)?) {
        /* TODO: Hackshop */
    }
    
    /* TODO: Events getter */
}
