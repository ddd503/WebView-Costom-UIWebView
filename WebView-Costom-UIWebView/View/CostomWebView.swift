//
//  CostomWebView.swift
//  WebView-Costom-UIWebView
//
//  Created by kawaharadai on 2018/04/30.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import UIKit

enum LoadingStatus {
    case start
    case finish
    case error(error: Error)
}

protocol CostomViewDelegate: class {
    func webViewAction(status: LoadingStatus)
}

class CostomView: UIView {

    var webView: UIWebView?
    var headerView: UIView?
    weak var delegate: CostomViewDelegate?
    private let headerViewHight: CGFloat = 50

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupWebView()
    }
   
    // MARK: - Setup Methods
    
    private func setupWebView() {
        self.webView = UIWebView(frame: .zero)
        self.webView?.delegate = self
        self.addSubview(self.webView ?? UIWebView())
        self.setupConstain(webView: self.webView)
        webView?.sizeToFit()
        self.setHeaderView()
    }
    
    /// autolayoutを設定（4辺共に0）
    private func setupConstain(webView: UIWebView?) {
        webView?.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]|",
                                                           options: NSLayoutFormatOptions(),
                                                           metrics: nil,
                                                           views: ["v0": webView ?? UIWebView()]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]|",
                                                           options: NSLayoutFormatOptions(),
                                                           metrics: nil,
                                                           views: ["v0": webView ?? UIWebView()]))
    }
    
    func setHeaderView() {
        self.headerView?.removeFromSuperview()
        // 画面外に作成
        self.headerView = UIView(frame: CGRect(x: 0, y: -headerViewHight, width: self.frame.width, height: headerViewHight))
        self.headerView?.backgroundColor = UIColor.red
        // スクロール領域の拡張
        self.webView?.scrollView.contentInset = UIEdgeInsetsMake(headerViewHight, 0, 0, 0)
        self.webView?.scrollView.addSubview(self.headerView ?? UIView())
        // スクロール開始位置を変更
        self.webView?.scrollView.setContentOffset(CGPoint(x: 0, y: -headerViewHight), animated: false)
    }
    
    // MARK: - Private Methods
    
    func isBack() -> Bool {
        return self.webView?.canGoBack ?? false
    }
    
    func isForword() -> Bool {
        return self.webView?.canGoForward ?? false
    }
}

// MARK: - UIWebViewDelegate Methods

extension CostomView: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("読み込み開始")
        self.delegate?.webViewAction(status: .start)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("読み込み完了")
        self.delegate?.webViewAction(status: .finish)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("読み込み失敗")
        self.delegate?.webViewAction(status: .error(error: error))
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // アクセス許可
        return true
    }
}
