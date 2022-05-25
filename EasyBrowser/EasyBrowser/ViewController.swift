//
//  ViewController.swift
//  EasyBrowser
//
//  Created by simge on 24.05.2022.
//

import UIKit
import WebKit

class ViewController: UIViewController , WKNavigationDelegate{ //WKNavigationDelegate protocolü eklenmeli
    
    //Views
    var webView : WKWebView!
    var progressView: UIProgressView!
    var websites = ["apple.com", "github.com/simgeatlhn"]
    
    //loadView , viewDidLoad dan önce çağırılır. Bu yüzden kodu viewDidLoad üzerine yazarız.
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self //self -> hergangi bir web sayfasında gezinme
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlView() ///***1
        
        //top button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        //bottom button
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        //go-back button
        let goBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBackTapped))
        let goForwardButton = UIBarButtonItem(title: "Forward", style: .plain, target: self, action: #selector(goForwardTapped))
        navigationItem.leftBarButtonItems = [goBackButton, goForwardButton]
        
        //progressView
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        ///***KVO
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

        toolbarItems = [progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
    }
    
    //for KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
 
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page", message: nil, preferredStyle: .actionSheet)
        
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem //for iPad
        present(ac, animated: true) ///***we show view controllers by present()
    }
    
    @objc func goBackTapped(){
           webView.goBack()
    }
    
    @objc func goForwardTapped() {
           webView.goForward()
    }
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)! ///*** seçilen sitenin yüklenmesi için
        webView.load(URLRequest(url: url))
    }
    
    //ilk websiteyi yükleme
    func urlView(){
        let url = URL(string: "https://github.com/simgeatlhn")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}
    
   
   

