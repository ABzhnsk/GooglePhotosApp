//
//  WebViewController.swift
//  GooglePhotosApp
//
//  Created by Anna Buzhinskaya on 12.02.2023.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var sourceURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlRequest = URLRequest(url: URL(string: sourceURL)!)
        webView.load(urlRequest)
    }
}
