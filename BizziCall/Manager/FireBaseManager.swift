//
//  FireBaseManager.swift
//  BizziCall
//
//  Created by Ahmad Qasim on 6/30/24.
//

import Foundation
import CoreData
import FirebaseDatabase

class FirebaseDatabaseManager {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static let shared = FirebaseDatabaseManager()
    var ref: DatabaseReference!
    
    private init() {
        ref = Database.database().reference()
    }
    
    // Fetch data from Firebase
    func fetchDataFromFirebase(completion: @escaping ([String: Any]?) -> Void) {
        ref.child("users/contacts").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                print("Error fetching data")
                completion(nil)
                return
            }
            completion(value)
        }
    }
    
    func updateStatus(status: String) {
//        guard let phoneNumber = UserDefaults.value(forKey: "currentUserNumber") as? String else { return }
        
        let phoneNumber = "+923144272687"
        
        guard let userDetail = fetchUserDetail(phoneNumber: phoneNumber), let pushKey = userDetail.pushKey else { return }
        
        userDetail.available = status == "" ? true : false
        
        userDetail.currentStatusMessage = status
        let dict = toDictionary(userDetail: userDetail)
        updateValue(withPushKey: pushKey, newValue: dict)
        
        
    }
    
    func updateValue(withPushKey pushKey: String, newValue: [String: Any]) {
        
        let path = "users/contacts/\(pushKey)"  // Update the specific attribute under the pushKey
        
        ref.child(path).updateChildValues(newValue ) { error, _ in
            if let error = error {
                print("Error updating value: \(error.localizedDescription)")
            } else {
                print("Value updated successfully!")
            }
        }
    }
    
    func toDictionary(userDetail: UserContacts) -> [String: Any] {
        return [
            "name": userDetail.name!,
            "number": userDetail.number!,
            "id": userDetail.id,
            "appInstall": userDetail.appInstall,
            "available": userDetail.available,
            "countryCode": userDetail.countryCode!,
            "currentStatusMessage": userDetail.currentStatusMessage!,
            "fcmToken": userDetail.fcmToken!,
            "pushKey": userDetail.pushKey!,
            "userId": userDetail.userId!
        ]
    }
    
    func fetchUserDetail(phoneNumber: String) -> UserContacts? {
       
        
        let fetchRequest: NSFetchRequest<UserContacts> = UserContacts.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "number == %@", phoneNumber )
        
        do {
            let contacts = try context.fetch(fetchRequest)
            return contacts.first ?? UserContacts()
        } catch {
            print("Failed to fetch contact: \(error)")
            return nil
        }
        
    }
    
}
