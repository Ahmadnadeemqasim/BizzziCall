//
//  CoreDataManager.swift
//  BizziCall
//
//  Created by Ahmad Qasim on 6/30/24.
//

import Foundation
import CoreData
import Contacts
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    var persistentContainer: NSPersistentContainer {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to access AppDelegate")
        }
        return appDelegate.persistentContainer
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Save contacts to Core Data
    func saveContactsToCoreData(contacts: [CNContact]) {
        for cnContact in contacts {
            let contact = Contacts(context: context) // `Contacts` is your Core Data entity
            contact.firstName = cnContact.givenName
            contact.lastName = cnContact.familyName
            if let phoneNumber = cnContact.phoneNumbers.first?.value.stringValue {
                contact.phoneNumber = phoneNumber
            }
        }
        
        do {
            try context.save()
            print("Contacts saved successfully.")
        } catch {
            print("Failed to save contacts:", error)
        }
    }
    
    // Fetch contacts from Core Data
    func fetchContactsFromCoreData() -> [Contacts] {
        let fetchRequest: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch contacts from Core Data:", error)
            return []
        }
    }
    
    func fetchFireBaseUserContacts() -> [UserContacts] {
        let fetchRequest: NSFetchRequest<UserContacts> = UserContacts.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch UserContacts from Core Data:", error)
            return []
        }
    }
    
    // Save data from Firebase to Core Data
    func saveDataToCoreData(data: [String: Any]) {
        let context = CoreDataManager.shared.context
        
        for (_, value) in data {
            if let contactData = value as? [String: Any], let userId = contactData["userId"] as? String {
                // Fetch existing UserContact with the same userId
                let fetchRequest: NSFetchRequest<UserContacts> = UserContacts.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "userId == %@", userId)
                
                do {
                    let existingContacts = try context.fetch(fetchRequest)
                    
                    // If exists, update it. If not, create a new one.
                    let entity: UserContacts
                    if let existingContact = existingContacts.first {
                        entity = existingContact
                    } else {
                        entity = UserContacts(context: context)
                    }
                    
                    entity.appInstall = contactData["appInstall"] as? Bool ?? false
                    entity.available = contactData["available"] as? Bool ?? false
                    entity.countryCode = contactData["countryCode"] as? String ?? ""
                    entity.currentStatusMessage = contactData["currentStatusMessage"] as? String ?? ""
                    entity.name = contactData["name"] as? String ?? ""
                    entity.number = contactData["number"] as? String ?? ""
                    entity.pushKey = contactData["pushKey"] as? String ?? ""
                    entity.userId = userId
                    entity.fcmToken = contactData["fcmToken"] as? String ?? ""
                    entity.id = contactData["id"] as? Int64 ?? 0
                } catch {
                    print("Failed to fetch contacts from Core Data: \(error)")
                }
            }
        }
        
        do {
            try context.save()
            print("Data saved successfully to Core Data.")
        } catch {
            print("Failed to save data to Core Data: \(error)")
        }
    }
}
