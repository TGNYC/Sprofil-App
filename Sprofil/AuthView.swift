//
//  AuthView.swift
//  Memorize
//
//  Created by Tejas Gupta on 4/3/22.
//

import SwiftUI
import WebKit

struct AuthView: UIViewRepresentable {
    @Binding var isLoggedIn : Bool
    
    func makeUIView(context: Context) -> WKWebView {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let myURL = AuthManager.shared.signInURL else {
            return
        }
        let request = URLRequest(url: myURL)
        uiView.load(request)
    }
    
    func makeCoordinator() -> AuthViewController {
        AuthViewController(self)
    }
}

class AuthViewController: NSObject, WKNavigationDelegate {
    let parent: AuthView

    init(_ parent: AuthView) { self.parent = parent }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Provisional Navigation failure: \(error)")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Testing Provisional Navigation")
        guard let url = webView.url else {
            return
        }
        
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code"  })?.value
        else {
            return
        }
        
        webView.isHidden = true
        
        print("Code: \(code)")
        
        AuthManager.shared.exchangeCodeForToken(code: code) { [weak self] success in
//            DispatchQueue.main.async {
                self?.parent.isLoggedIn = true
                
                // TODO: Add Call to Getting userID
                // TODO: Add Call to Top Tracks
                // TODO: Add Call to Top Aritsts
                // TODO: Store data in database
                print("ACCESS TOKEN from AuthView")
                print(AuthManager.shared.accessToken!)
                
                print("Before API Call")
                print("After API Call")
                
//                self?.navigationController?.popToRootViewController(animated: true)
//                self?.completionHandler?(success)
//            }
        }
        
    }
}


class WebViewHelper: NSObject, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webview didFinishNavigation")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("didStartProvisionalNavigation")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("webviewDidCommit")
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("didReceiveAuthenticationChallenge")
        completionHandler(.performDefaultHandling, nil)
    }
}
