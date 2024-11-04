//
//  SubscriptionVC.swift
//  soundboard
//
//  Created by Safwan on 01/05/2024.
//

import UIKit
import RevenueCat

class SubscriptionVC: UIViewController {

    //MARK: @IBOutlets
    @IBOutlet weak var btnWeekly: UIButton!
    @IBOutlet weak var btnLifetime: UIButton!
    
    //MARK: Variables
    var weeklyPackage: Package?
    var lifetimePackage: Package?
    
    var subscriptionSuccess: (()->Void)?
    
    //MARK: LifeCycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        onAppear()
    }
    
    //MARK: @IBActions
    @IBAction func onTapWeekly(_ sender: Any) {
        if let pack = weeklyPackage {
            Purchases.shared.purchase(package: pack) { (transaction, customerInfo, error, userCancelled) in
                if customerInfo?.entitlements["premium"]?.isActive == true {
                    UserManager.shared.premium = true
                    UserManager.shared.updatePremiumStatus(status: true, date: customerInfo?.entitlements.all["premium"]?.expirationDate)
                    self.subscriptionSuccess?()
                    self.dismiss(animated: true)
                }
            }
        } else {
            self.showAlert(withTitle: "Error", message: "Packages not available please restart the application and Try Again")
        }
    }
    
    @IBAction func onTapLifetime(_ sender: Any) {
        if let pack = lifetimePackage {
            Purchases.shared.purchase(package: pack) { (transaction, customerInfo, error, userCancelled) in
                if customerInfo?.entitlements["premium"]?.isActive == true {
                    UserManager.shared.premium = true
                    UserManager.shared.updatePremiumStatus(status: true, date: nil)
                    self.subscriptionSuccess?()
                    self.dismiss(animated: true)
                }
            }
        } else {
            self.showAlert(withTitle: "Error", message: "Packages not available please restart the application and Try Again")
        }
    }
    
    @IBAction func onTapCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    
@IBAction func openTerms(_ sender: Any) {
      let urlString = "https://teleprompterpro2.com/terms.html"
      if let url = URL(string: urlString) {
          UIApplication.shared.open(url)
      } else {
          print("Invalid URL")
      }
  }

    @IBAction func openPrivacy(_ sender: Any) {
          let urlString = "https://teleprompterpro2.com/privacy.html"
          if let url = URL(string: urlString) {
              UIApplication.shared.open(url)
          } else {
              print("Invalid URL")
          }
      }

    
    
    
    @IBAction func restoreAgain(_ sender: Any) {
              print("restore")
        
        if let pack = lifetimePackage {
            Purchases.shared.purchase(package: pack) { (transaction, customerInfo, error, userCancelled) in
                if customerInfo?.entitlements["premium"]?.isActive == true {
                    UserManager.shared.premium = true
                    UserManager.shared.updatePremiumStatus(status: true, date: nil)
                    self.subscriptionSuccess?()
                    self.dismiss(animated: true)
                }
            }
        } else {
            self.showAlert(withTitle: "Error", message: "Packages not available please restart the application and Try Again")
        }
        
      }

    
    
    
    
}


    





//MARK: Custom Functionality
extension SubscriptionVC {
    func onLoad() {
        Purchases.shared.getOfferings { (offerings, error) in
            if let packages = offerings?.current?.availablePackages {
                for package in packages {
                    if package.packageType == .weekly {
                        self.btnWeekly.setTitle("Subscribe Weekly \(package.localizedPriceString)", for: .normal)
                        self.weeklyPackage = package
                    } else if package.packageType == .lifetime {
                        self.btnLifetime.setTitle("Purchase Lifetime Plan \(package.localizedPriceString)", for: .normal)
                        self.lifetimePackage = package
                    }
                }
            }
        }
    }
    
    func onAppear() {
        
    }
    


}
