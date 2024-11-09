//
//  BaseViewController.swift
//  AskAI
//
//  Created by Ekramul Hoque on 19/5/23.
//

import UIKit

class BaseViewController: UIViewController {

    var loaderBg: UIView!
    
    var loaderMask = UIVisualEffectView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    
    /// Show error Alert
    /// - Parameters:
    ///   - title: Error title
    ///   - message: Error description

    
    func showIAP() {
        guard let vc = UIStoryboard.init(name: "IAP", bundle: nil).instantiateViewController(withIdentifier: "PurchaseViewController") as? PurchaseViewController else { return }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    // Method to show the loader
//    func showLoader(isPresentLargeNavbar: Bool = false,loaderType: NVActivityIndicatorType = .circleStrokeSpin,loaderSize: CGFloat = 40, loaderColor: UIColor = UIColor.orange) {
//        if loaderView == nil {
//            let loaderFrame = CGRect(x: (view.bounds.width - loaderSize) / 2,
//                                                 y: (view.bounds.height - loaderSize) / 2,
//                                                 width: loaderSize,
//                                                 height: loaderSize)
//            
//            loaderView = NVActivityIndicatorView(frame: loaderFrame,
//                                                 type: loaderType,
//                                                 color: loaderColor,
//                                                 padding: nil)
//        }
//        
//        if let loaderView = loaderView, !view.subviews.contains(loaderView) {
//            loaderBg = UIView(frame: view.bounds)
//            loaderBg.backgroundColor = .black
//            loaderBg.layer.opacity = 0.4
//            view.addSubview(loaderBg)
//            loaderMask = UIVisualEffectView(frame: CGRect(x: 0, y: 0, width: loaderSize + 100, height: loaderSize + 100))
//            loaderMask.effect = UIBlurEffect(style: .light)
//            loaderMask.layer.cornerRadius = 15.0
//            loaderMask.layer.masksToBounds = true
//            view.addSubview(loaderMask)
//            view.addSubview(loaderView)
//            // Start animating
//            loaderView.startAnimating()
//            
//            // Account for the navigation bar height and safe area insets (if they exist)
//            let largeNavbarInset = isPresentLargeNavbar ? 100.0 : 0.0
//            let navigationBarHeight = (self.navigationController?.navigationBar.frame.height ?? 0) + largeNavbarInset
//            let tabBarHeight = super.tabBarController?.tabBar.frame.height
//            loaderView.center = CGPointMake(self.view.frame.size.width / 2.0, (self.view.frame.size.height - navigationBarHeight - (tabBarHeight ?? 0)) / 2.0)
//            loaderMask.center = loaderView.center
//        }
//    }
    
    // Method to hide the loader
//    func hideLoader() {
//        if let loaderView = loaderView, view.subviews.contains(loaderBg) {
//            loaderView.stopAnimating()
//            loaderBg.removeFromSuperview()
//            loaderMask.removeFromSuperview()
//            self.loaderView = nil
//        }
//    }
    
    func calculateCellWidth(for indexPath: IndexPath , text : String) -> CGFloat {
        let label = UILabel()
        label.text = text
//        label.font = AppFonts.SemiBold.withSize(14.0)
        let labelSize = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 50))
        // Add any additional spacing or padding to the calculated width
        let cellWidth = labelSize.width + 20.0
        return cellWidth
    }
    
    func calculateHeightForCell(with text: String, font: UIFont, collectionViewWidth: CGFloat) -> CGFloat {
        // Assuming you have access to the data and the width of the collection view
        
        // Calculate the height based on your cell's content
        // You can use the data properties or other measurements to determine the height
        
        // Example: Calculate height based on text content
        let textWidth = collectionViewWidth // Subtract any left and right insets/padding
        
        let boundingRect = CGSize(width: textWidth, height: .greatestFiniteMagnitude)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        let estimatedHeight = NSString(string: text).boundingRect(
            with: boundingRect,
            options: options,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        ).height
        
        // Add any additional spacing or padding to the calculated height
        let finalHeight = estimatedHeight + 16 // Example: Add 16 points of padding
        
        // Return the calculated height
        return finalHeight
    }
}

