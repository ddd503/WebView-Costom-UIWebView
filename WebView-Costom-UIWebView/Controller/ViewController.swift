//
//  ViewController.swift
//  WebView-Costom-UIWebView
//
//  Created by kawaharadai on 2018/04/30.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var costomWebView: CostomView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwordButton: UIBarButtonItem!
    @IBOutlet weak var indicetor: UIActivityIndicatorView!
    
    // MARK: - LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.costomWebView.delegate = self
        self.costomWebView.webView?.loadRequest(URLRequest(url: URL(string: "https://qiita.com/d-kawahara")!))
    }

    // MARK: - Private Methods

    private func toolbarStatus() {
        self.backButton.isEnabled = self.costomWebView.isBack()
        self.forwordButton.isEnabled = self.costomWebView.isForword()
    }
    
    // MARK: - Action Methods
    
    @IBAction func back(_ sender: Any) {
        self.costomWebView.webView?.goBack()
    }
    
    @IBAction func forword(_ sender: Any) {
        self.costomWebView.webView?.goForward()
    }
    
    @IBAction func refresh(_ sender: Any) {
        self.costomWebView.webView?.reload()
    }
}

// MARK: - CostomViewDelegate Methods

extension ViewController: CostomViewDelegate {
    
    /// webView側のデリゲートを受ける
    func webViewAction(status: LoadingStatus) {
        switch status {
        case .finish:
            self.toolbarStatus()
            self.indicetor.stopAnimating()
        case .start:
            self.indicetor.startAnimating()
        case .error(let error):
            self.indicetor.stopAnimating()
            print("エラー：\(error.localizedDescription)")
        }
    }
}
