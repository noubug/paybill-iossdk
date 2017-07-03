//
//  PaymentViewController.swift
//  PayBillNGIOSSdk
//
//  Created by Agwasim Emmanuel on 7/3/17.
//  Copyright © 2017 noubug. All rights reserved.
//

import UIKit
import WebKit
import ObjectMapper

public class PBPaymentViewController: UIViewController, WKNavigationDelegate,WKScriptMessageHandler{

    var webView: WKWebView?

    var delegate:PBPDelegate?

    var paymentConfig:PBPaymentConfig!

    var evaluated = false;

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.title = "Make Payment"

        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(PBPaymentViewController.onCancel))
        
        self.navigationItem.leftBarButtonItem = cancelButton

        let contentController = WKUserContentController();

        let userScript = WKUserScript(
            source: "redHeader()",
            injectionTime: WKUserScriptInjectionTime.atDocumentEnd,
            forMainFrameOnly: true
        )

        contentController.addUserScript(userScript)

        let config = WKWebViewConfiguration()
        config.userContentController = contentController

        self.webView = WKWebView(
            frame: self.view.bounds,
            configuration: config
        )

        contentController.add(
            self,
            name: "callbackHandler"
        )

        self.view.addSubview(self.webView!)

        webView?.navigationDelegate = self

        let path = Bundle.main.path(forResource: "payment-window", ofType: "html")
        let url = NSURL(fileURLWithPath: path!)
        let request = NSURLRequest(url: url as URL)

        let _ = webView?.load(request as URLRequest)

    }


    func onCancel() {

        self.delegate?.onPaymentWindoClosed(ref: self.paymentConfig.organizationUniqueReference)

        if let nav = self.navigationController{
            nav.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }

    }

    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == "callbackHandler") {
            if let body = message.body as? String{
                if body == "close"{
                    self.delegate?.onPaymentWindoClosed(ref: self.paymentConfig.organizationUniqueReference)
                    if let nav = self.navigationController{
                        nav.popViewController(animated: true)
                    }else{
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {

    }

    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        displayNavBarActivity()
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.dismissNavBarActivity()
    }


    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.dismissNavBarActivity()
        if !evaluated{

            var pconfig = Mapper().toJSONString(self.paymentConfig!, prettyPrint: false)!

            pconfig =  pconfig.replacingOccurrences(of: "\"", with: "\\\"")
            pconfig =  pconfig.replacingOccurrences(of: "\'", with: "\\\'")
            pconfig =  pconfig.replacingOccurrences(of: "\n", with: "\\n")
            pconfig =  pconfig.replacingOccurrences(of: "\r", with: "")

            self.webView!.evaluateJavaScript("makePayment('\(pconfig)')", completionHandler: { (any:Any?, error:Error?) in
            })

            evaluated = true
        }
    }

    func displayNavBarActivity() {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicator.startAnimating()
        let item = UIBarButtonItem(customView: indicator)
        self.navigationItem.rightBarButtonItem = item
    }

    func dismissNavBarActivity() {
        self.navigationItem.rightBarButtonItem = nil
    }

    func alert(title:String, message:String){
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            refreshAlert.dismiss(animated: true, completion: nil)
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
}
