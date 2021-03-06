//
//  NewsViewController.swift
//  carolina_fever_0
//
//  Created by Caleb Kang on 7/31/19.
//  Copyright © 2019 Caleb Kang. All rights reserved.
//

import UIKit
import WebKit

class NewsViewController: UIViewController, WKNavigationDelegate {

    // MARK: Outlets
    @IBOutlet var twitterView: WKWebView!
    @IBOutlet var loading: UIActivityIndicatorView!
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*simply loads the html file of a twitter feed of unc
         sports news and loads it to the web view           **/
        twitterView.isHidden = true
        twitterView.navigationDelegate = self
        twitterView.allowsBackForwardNavigationGestures = true
        
        loading.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        loading.hidesWhenStopped = true
        
        let htmlFile = Bundle.main.path(forResource: "news_view", ofType: "html")
        var htmlString = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8) as NSString
        
        var width = UIScreen.main.bounds.width
        width -= 16
        
        htmlString = htmlString!.replacingOccurrences(of: "WIDTH", with: width.description) as NSString
        twitterView.loadHTMLString(htmlString! as String, baseURL: nil)
    }
    
    // MARK: WebView
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loading.stopAnimating()
        twitterView.isHidden = false
        UIApplication.shared.endIgnoringInteractionEvents()
        
    }
}
