//
//  PrivacyViewController.swift
//  AskAI
//
//  Created by Sabbir Hossain on 22/6/23.
//

import UIKit
import WebKit

enum UrlType {
    case privacy, terms, none
}

class PrivacyViewController: BaseViewController {

    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    var urlType: UrlType = .none
    
    let PRIVACY_POLICY_URL = "https://sites.google.com/view/bjitphotoly/home"
    let TERMS_URL = "https://sites.google.com/view/bjitphotolyterms/home"

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        self.webView.navigationDelegate = self
        
        if self.urlType == .privacy{
            if let url = URL(string: PRIVACY_POLICY_URL){
                self.loadUIWebView(currentURL: url, titleText: "Privacy Policy")
                termLabel.text = "Privacy Policy"
            }
            
        }
        else if self.urlType == .terms{
            if let url = URL(string: TERMS_URL){
                self.loadUIWebView(currentURL: url, titleText: "Terms of Service")
                termLabel.text = "Terms of Service"
            }
        }
        
    }
    
    
    @IBAction func dismissButtonAction(_ sender: Any) {
//        self.hideLoader()
        self.dismiss(animated: true)
    }
    
}


extension  PrivacyViewController : WKNavigationDelegate,WKUIDelegate {
    
    private func loadUIWebView(currentURL : URL,titleText:String){
        
        self.termLabel.text = titleText
        
        let request = URLRequest(url: currentURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
        
        self.webView.load(request)
        
        //self.view.bringSubviewToFront(self.containerWebView)
        
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        self.showLoader()
    }
    
    func webView(_ webView: WKWebView, didFinish  navigation: WKNavigation!){
        //let url = webView.url?.absoluteString
        // print("---Hitted URL--->\(url!)") // here you are getting URL
//        self.hideLoader()
        
    }
}
