//
//  WebsiteViewController.swift
//  ACCSports
//
//  Created by CS3714 on 9/29/16.
//  Copyright © 2016 Jesus Fabian. All rights reserved.
//

import UIKit



class WebsiteViewController: UIViewController, UIWebViewDelegate {
    
    
    
    /*
     
     Instance variable holding the object reference of the Web View (UIWebView)
     
     object created in the Storyboard, i.e., Interface Builder (IB).
     
     */
    
    @IBOutlet var webView: UIWebView!
    
    
    
    // The value of this instance variable is set by the upstream view controller
    
    var websiteURL: String = ""
    
    
    
    
    
    /*
     
     -----------------------
     
     MARK: - View Life Cycle
     
     -----------------------
     
     */
    
    override func viewDidLoad() {
        
        
        
        // Ask the super class to continue with the viewDidLoad method execution after executing this method
        
        super.viewDidLoad()
        
        
        
        /*
         
         URL is a Swift Structure!
         
         
         
         "A URL is a Swift [Structure] type that can potentially contain the location of
         
         a resource on a remote server, the path of a local file on disk, ..." [Apple]
         
         
         
         Create an Instance of the URL Structure, initialize it with websiteURL
         
         and store its unique ID into the local constant "url".
         
         */
        
        let url = URL(string: websiteURL)
        
        
        
        /*
         
         URLRequest is a Swift Structure!
         
         
         
         Create an Instance of the URLRequest Structure, initialize it with the "url"
         
         local constant value, and store its unique ID into the local constant "request".
         
         */
        
        let request = URLRequest(url: url!)
        
        
        
        // Ask the webView object to load the web page for the given URL request
        
        webView.loadRequest(request)
        
    }
    
    
    
    /******************************************************************************************
     
     * UIWebView Delegate Methods: These methods must be implemented whenever UIWebView is used.
     
     ******************************************************************************************/
    
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        // Starting to load the web page. Show the animated activity indicator in the status bar
        
        // to indicate to the user that the UIWebVIew object is busy loading the web page.
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }
    
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        // Finished loading the web page. Hide the activity indicator in the status bar.
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }
    
    
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        /*
         
         Ignore this error if the page is instantly redirected via JavaScript or in another way.
         
         NSURLErrorCancelled is returned when an asynchronous load is cancelled, which happens
         
         when the page is instantly redirected via JavaScript or in another way.
         
         */
        
        if (error as NSError).code == NSURLErrorCancelled  {
            
            return
            
        }
        
        
        
        // An error occurred during the web page load. Hide the activity indicator in the status bar.
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        
        
        // Create the error message in HTML as a character string and store it into the local constant errorString
        
        let errorString = "<html><font size=+2 color='red'><p>An error occurred: <br />Possible causes for this error:<br />- No network connection<br />- Wrong URL entered<br />- Server computer is down</p></font></html>" + error.localizedDescription
        
        
        
        // Display the error message within the UIWebView object
        
        // self. is required here since this method has a parameter with the same name.
        
        self.webView.loadHTMLString(errorString, baseURL: nil)
        
    }
    
    
    
}
