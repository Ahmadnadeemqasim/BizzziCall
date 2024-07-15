//
//  ContactsVC.swift
//  BizzCall
//
//  Created by Ahmad Qasim on 5/29/24.
//

import UIKit
import Contacts

class ContactsVC: UIViewController {

    
    private var sideMenuViewController: DrawerTVC!
    private var isSideMenuOpen = false
    @IBOutlet weak var tblContacts: UITableView!
    var contactsFetched = [CNContact]()
    var coreDataContacts = [Contacts]()
    var fireBaseFetchedContacts = [UserContacts]()
    var countToCallFunction =  0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSideMenu()
        
        tblContacts.register(UINib.init(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        tblContacts.delegate = self
        tblContacts.dataSource = self
        fetchContactsAndPermission()
    }
    
    func fetchContactsAndPermission() {
        fireBaseFetchedContacts = CoreDataManager.shared.fetchFireBaseUserContacts()
        
        if isContactsPermissionGranted() {
            fetchContactsFromCoreData()
        } else {
            fetchContactsFromContactBook()
        }
    }
    
    func fetchContactsFromContactBook() {
        requestAccessToContacts { granted in
            if granted {
                self.fetchContacts { contacts in
                    CoreDataManager.shared.saveContactsToCoreData(contacts: contacts)
                    self.fetchContactsFromCoreData() // Fetch from Core Data after saving
                }
            } else {
                // Handle the case where permission is not granted
                print("Permission not granted")
            }
        }
    }
    
    func fetchContactsFromCoreData() {
        coreDataContacts = CoreDataManager.shared.fetchContactsFromCoreData()
        if coreDataContacts.count == 0 {
            if countToCallFunction < 2 {
                countToCallFunction += 1
                fetchContactsFromContactBook()
            } else {
                print("No Contacts")
            }
            
        } else {
            DispatchQueue.main.async {
                self.tblContacts.reloadData()
            }
        }
    }
    
    func fetchContacts(completion: @escaping ([CNContact]) -> Void) {
        var contacts = [CNContact]()
        
        let store = CNContactStore()
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        
        do {
            try store.enumerateContacts(with: fetchRequest) { contact, stop in
                contacts.append(contact)
            }
            completion(contacts)
        } catch {
            print("Failed to fetch contacts: \(error)")
            completion([])
        }
    }
    
    func requestAccessToContacts(completion: @escaping (Bool) -> Void) {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            completion(granted)
        }
    }
    
    func isContactsPermissionGranted() -> Bool {
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        return authorizationStatus == .authorized
    }
    
    @IBAction func btnMenuTapped(_ sender: Any) {
        toggleSideMenu()
    }
    
    private func setupSideMenu() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        sideMenuViewController = storyboard.instantiateViewController(withIdentifier: "DrawerTVC") as? DrawerTVC
        
        addChild(sideMenuViewController)
        view.addSubview(sideMenuViewController.view)
        sideMenuViewController.didMove(toParent: self)
        sideMenuViewController.view.frame = CGRect(x: -view.frame.width, y: 0, width: view.frame.width * 0.65, height: view.frame.height)
    }

    private func toggleSideMenu() {
        UIView.animate(withDuration: 0.3, animations: {
            if self.isSideMenuOpen {
                // Hide side menu
                self.sideMenuViewController.view.frame = CGRect(x: -self.view.frame.width, y: 0, width: self.view.frame.width * 0.8, height: self.view.frame.height)
            } else {
                // Show side menu
                self.sideMenuViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * 0.8, height: self.view.frame.height)
            }
        }) { _ in
            self.isSideMenuOpen.toggle()
        }
    }


}
extension ContactsVC : UITableViewDataSource, UITableViewDelegate{
    // UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        let contact = coreDataContacts[indexPath.row]
        cell.vwCallstatus.isHidden = true
        
        if let matchedContact = fireBaseFetchedContacts.first(where: { $0.number == contact.phoneNumber }) {
            if matchedContact.appInstall {
                cell.vwCallstatus.isHidden = false
                if matchedContact.currentStatusMessage!.isEmpty {
                    cell.vwCallstatus.backgroundColor = .green
                } else {
                    cell.vwCallstatus.backgroundColor = .red
                }
            }
        }
        
        cell.lblCallerName?.text = contact.firstName
        cell.lblCallerNumber?.text = contact.phoneNumber
        
        return cell
    }
}
