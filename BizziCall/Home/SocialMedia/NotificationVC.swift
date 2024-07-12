//
//  NotificationVC.swift
//  BizzCall
//
//  Created by Ahmad Qasim on 5/29/24.
//

    import UIKit

    class NotificationVC: UIViewController {
        
        private var sideMenuViewController: DrawerTVC!
        private var isSideMenuOpen = false
        @IBOutlet weak var cvNotification: UICollectionView!
        var installedApps = [SocialApp]()
        let appIcon = ["whatsapp","twitter","facebook","gmail","instagram","skype"]
    //    let socialApps = [
    //        SocialApp(name: "Facebook", urlScheme: "fb://", icon: UIImage(named: "facebookIcon")!),
    //        SocialApp(name: "Twitter", urlScheme: "twitter://", icon: UIImage(named: "twitterIcon")!),
    //        SocialApp(name: "Instagram", urlScheme: "instagram://", icon: UIImage(named: "instagramIcon")!),
    //        SocialApp(name: "Snapchat", urlScheme: "snapchat://", icon: UIImage(named: "snapchatIcon")!)
    //    ]
    //
        override func viewDidLoad() {
            super.viewDidLoad()
            setupSideMenu()
            cvNotification.register(UINib.init(nibName: "NotificationCell", bundle: nil), forCellWithReuseIdentifier: "NotificationCell")
    //        installedApps = getInstalledSocialApps()
            // Do any additional setup after loading the view.
        }
    //    func getInstalledSocialApps() -> [SocialApp] {
    //        var installedApps = [SocialApp]()
    //        for app in socialApps {
    //            if let url = URL(string: app.urlScheme), UIApplication.shared.canOpenURL(url) {
    //                installedApps.append(app)
    //            }
    //        }
    //        return installedApps
    //    }
        private func setupSideMenu() {
            // Instantiate SideMenuViewController from storyboard
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            sideMenuViewController = storyboard.instantiateViewController(withIdentifier: "DrawerTVC") as? DrawerTVC
            
            
            // Add SideMenuViewController as child
            addChild(sideMenuViewController)
            view.addSubview(sideMenuViewController.view)
            sideMenuViewController.didMove(toParent: self)
            
            // Set initial frame (off-screen)
            sideMenuViewController.view.frame = CGRect(x: -view.frame.width, y: 0, width: view.frame.width * 0.65, height: view.frame.height)
        }

        @IBAction func btnMenuTapped(_ sender: UIButton){
            print("---------Menu Button Tapped-------------")
            toggleSideMenu()
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
    extension NotificationVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let itemsPerRow: CGFloat = 3
            let paddingSpace = 10 * (itemsPerRow + 1) // Interitem spacing + section insets
            let availableWidth = collectionView.frame.width - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow
            
            return CGSize(width: widthPerItem, height: widthPerItem)
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return appIcon.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = cvNotification.dequeueReusableCell(withReuseIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
            cell.imgSocialAppIcon.image = UIImage(named: appIcon[indexPath.row])
            return cell
        }
        
        
    }
