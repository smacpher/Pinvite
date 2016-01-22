//
//  LoginViewController.swift
//  pinvite
//
//  Created by Sean MacPherson on 1/20/16.
//  Copyright © 2016 loofy. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var txtUser: UITextField!

    @IBOutlet weak var txtPass: UITextField!
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,150,150)) as UIActivityIndicatorView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        view.addSubview(self.actInd)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Actions
    
    @IBAction func signInAction(sender: AnyObject) {
        let username = self.txtUser.text
        let password = self.txtPass.text
        
        // signIn user
        
        self.actInd.startAnimating()
        
        PFUser.logInWithUsernameInBackground(username!, password: password!, block: {(user, error) -> Void in
            
            self.actInd.stopAnimating()
            
            if ((user) != nil) {
                self.dismissViewControllerAnimated(true, completion: nil)
                
            }else {
                let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .Alert)
                let action = UIAlertAction(title: "Ok", style: .Default, handler:nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            
            
        })
        
        
        
        
        
        
        
        
        
        
    }

}