//
//  PurchaseViewController.swift
//  AskAI
//
//  Created by Sabbir Hossain on 13/6/23.
//

import UIKit
import Foundation
import StoreKit

enum PurchaseType {
    case yearly
    case weekly
}

struct Banner {
    var imageName: String
    var title: String
}



struct IAPConstant {
    static let sharedSecretKey = "8be0d32316fd4b28a1a3f9608b367493"
    static let isPremium = "isPremium"
    static let hoverSelected = "hoverSelect"
    static let hoverDeselect = "hoverDeselect"
    static let borderColorDeselect = "#EEEEEE"
    static let borderColorSelect = "#EEEEEE"
    static let purchaseButtonColor = "00ADB5"
    static let continueText = "Continue"
    static let restore = "Restore"
    static let privacyPolicy = "PrivacyPolicy"
    static let termsOfUse = "TermsOfUse"
    static let weeklyAccess = "Weekly Access"
    static let yearlyAcess = "Yearly Access"
    static let freeTrialEnabled = "Free Trial Enabled"
    static let enableFreeTrial = "Enable Free Trial"
    static let freeTrialPrefix = "%@-DAY FREE TRIAL"
    static let then = "then"
    static let appTitle = "Chat Ninja"
    static let PRO = "PRO"
    static let iapSubtitle = "No ads, more special features!"
    static let proFeature1 = "Unlimited Prompt, quetions & quick response"
    static let proFeature2 = "Ad free uses"
    static let proFeature3 = "%@+ prompt"
    static let proFeature4 = "Store or share to all social media"
    static let proFeature5 = "Higher word, In time response, Pro uses"
    static let savePercent = "Save %@"
    static let yearPrice = "$%@/Year"
    static let weekPrice = "$%@/Week"
    static let purchaseInfo = "purchaseInfo"
    static let bannerImage1 = "bannerImg1"
    static let bannerImage2 = "bannerImg2"
    static let bannerImage3 = "bannerImg3"
}


class PurchaseViewController: BaseViewController {

    @IBOutlet weak var purchaseViewBottom: NSLayoutConstraint!
    @IBOutlet weak var purchaseViewTop: NSLayoutConstraint!
    @IBOutlet weak var purchaseViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var purchaseViewLeading: NSLayoutConstraint!
//    @IBOutlet weak var trialView: CustomView!
    @IBOutlet weak var yearlyView: CustomView!
//    @IBOutlet weak var weeklyView: CustomView!
    @IBOutlet weak var purchaseView: CustomView!
    @IBOutlet weak var pageControl: PageControl!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var purchaseButton: UIButton!

    @IBOutlet weak var restoreButton: UIButton!

    @IBOutlet weak var appTitle: UILabel!


    @IBOutlet weak var continueLabel: UILabel!
//    @IBOutlet weak var yearlySelectionImageVIew: UIImageView!

//    @IBOutlet weak var weeklySelectionImageView: UIImageView!

//    @IBOutlet weak var freeTrialLabel: UILabel!

    @IBOutlet weak var purchaseInfoTextView: UITextView!

    @IBOutlet weak var yearlyTitleLabel: UILabel!
    @IBOutlet weak var yearlyPriceLabel: UILabel!

//    @IBOutlet weak var weeklyTitleLabel: UILabel!

//    @IBOutlet weak var weeklyPriceLabel: UILabel!

    @IBOutlet weak var proLabel: UILabel!

    @IBOutlet weak var appSubtitle: UILabel!

    //Features
    @IBOutlet weak var proFeature1: UILabel!
    @IBOutlet weak var proFeature2: UILabel!

    @IBOutlet weak var proFeature3: UILabel!

    @IBOutlet weak var proFeature4: UILabel!

//    @IBOutlet weak var proFeature5: UILabel!


    //
    @IBOutlet weak var privacyButton: UIButton!{
        didSet {
            privacyButton.addTarget(self, action: #selector(privacyButtonAction), for: .touchUpInside)
        }
    }

    @IBOutlet weak var termsButton: UIButton!{
        didSet {
            termsButton.addTarget(self, action: #selector(termsButtonAction), for: .touchUpInside)
        }
    }


//    @IBOutlet weak var savePercentLabel: UILabel!



//    @IBOutlet weak var freeTrialSwitch: UISwitch! {
//        didSet {
//            freeTrialSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
//        }
//    }



    var iapProductLoaded = false

    var purchaseType: PurchaseType = .weekly

    var timer: Timer?

    var bannerIndex = 0

    var banners: [Banner] = [Banner(imageName: IAPConstant.bannerImage1, title: "100% ad free experience"), Banner(imageName: IAPConstant.bannerImage2, title: "100% ad free experience"), Banner(imageName: IAPConstant.bannerImage3, title: "100% ad free experience")]


    override func viewDidLoad() {
        super.viewDidLoad()


    }
    @IBAction func crossButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @objc func privacyButtonAction() {
//        if !ReachabilityManager.isNetworkReachable() {
//            self.showInternetError()
//        } else {
        guard let vc = UIStoryboard(name: "IAP", bundle: nil).instantiateViewController(withIdentifier: "PrivacyViewController") as? PrivacyViewController else {
            return
        }
        vc.modalPresentationStyle = .fullScreen
        vc.urlType = .privacy
        self.present(vc, animated: true)
//        }
    }

    @objc func termsButtonAction() {
//        if !ReachabilityManager.isNetworkReachable() {
//            self.showInternetError()
//        } else {
        guard let vc = UIStoryboard(name: "IAP", bundle: nil).instantiateViewController(withIdentifier: "PrivacyViewController") as? PrivacyViewController else {
            return
        }
        vc.modalPresentationStyle = .fullScreen
        vc.urlType = .terms
        self.present(vc, animated: true)
    }
//    }


}
