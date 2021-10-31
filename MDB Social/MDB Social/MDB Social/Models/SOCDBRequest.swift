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
        guard let uid = user.uid else { return }
        do {
            try db.collection("users").document(uid).setData(from: user)
            completion?()
        }
        catch { }
    }
    
    func setEvent(_ event: SOCEvent, completion: (()->Void)?) {
        guard let id = event.id else { return }
        
        do {
            try db.collection("events").document(id).setData(from: event)
            completion?()
        } catch { }
    }
    
    func getEvents(completion: (([SOCEvent])->Void)?) {
        var events = [SOCEvent]()
        let query = db.collection("events")
        
        query.getDocuments { snapshot, error in
            if let snapshot = snapshot {
                for doc in snapshot.documents {
                    do {
                        if let event = try doc.data(as: SOCEvent.self) {
                            events.append(event)
                        }
                    } catch {}
                }
            }
            completion?(events)
        }
    }
    
    func listenToEvents(completion: (([SOCEvent])->Void)?) {
        let query = db.collection("events").addSnapshotListener { querySnapshot, error in
            var events = [SOCEvent]()
            if let documents = querySnapshot?.documents {
                for doc in documents {
                    do {
                        if let event = try doc.data(as: SOCEvent.self) {
                            events.append(event)
                        }
                    } catch {}
                }
            }
            completion?(events)
        }
    }
    
    func getUserById(userId: SOCUserID, completion: ((SOCUser)->Void)?) {
        let query = db.collection("users").document(userId)
        
        query.getDocument { snapshot, error in
            do {
                if let user = try snapshot?.data(as: SOCUser.self) {
                    completion?(user)
                }
            } catch {}
        }
    }
}
