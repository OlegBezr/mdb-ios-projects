//
//  SOCDBRequest.swift
//  MDB Social No Starter
//
//  Created by Michael Lin on 10/9/21.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI

class FIRDatabaseRequest {
    
    static let shared = FIRDatabaseRequest()
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    private var eventsListener: ListenerRegistration?
    private var eventListener: ListenerRegistration?
    
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
    
    func createEvent(_ event: SOCEvent, completion: (()->Void)?) {
        do {
            try db.collection("events").addDocument(from: event)
            completion?()
        } catch { }
    }
    
    func deleteEvent(_ event: SOCEvent, completion: (()->Void)?) {
        guard let id = event.id else { return }
        
        db.collection("events").document(id).delete()
        completion?()
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
        eventsListener = db.collection("events").addSnapshotListener { querySnapshot, error in
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
    
    func getEventById(eventId: SOCEventID, completion: ((SOCEvent)->Void)?) {
        let query = db.collection("events").document(eventId)
        
        query.getDocument { snapshot, error in
            do {
                if let event = try snapshot?.data(as: SOCEvent.self) {
                    completion?(event)
                }
            } catch {}
        }
    }
    
    func listenToEvent(eventId: SOCEventID, completion: ((SOCEvent )->Void)?) {
        eventListener = db.collection("events").document(eventId).addSnapshotListener {
            docSnapshot, error in
            guard let document = docSnapshot else {
                return
            }
            guard let event = try? document.data(as: SOCEvent.self) else {
                return
            }
            
            completion?(event)
        }
    }
    
    func uploadImage(image: Data, completion: ((String) ->Void)?) {
        print("\nUPLOAD STARTED\n")
        let storageRef = storage.reference()
        let timeStamp = NSDate().timeIntervalSince1970
        let fileName = "image" + String(format:"%02X", Int(timeStamp * 1000000)) + ".jpeg"
        let imageRef = storageRef.child(fileName)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let uploadTask = imageRef.putData(image, metadata: metadata) { (metadata, error) in
            guard let metadata = metadata else {
                print("\nERROR\n")
                print(error)
                return
            }

            imageRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
                return
            }
            completion?(downloadURL.absoluteString)
          }
        }
    }
    
    func stopListeningToEvents() {
        eventsListener?.remove()
    }
    
    func stopListeningToEvent() {
        eventListener?.remove()
    }
}
