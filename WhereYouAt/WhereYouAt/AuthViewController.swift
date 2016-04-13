//
//  AuthViewController.swift
//  WhereYouAt
//
//  Created by John Rocha on 4/4/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import UIKit
import Firebase
import Google


class AuthViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    var ref: Firebase!
    var userId : String = ""
    var appJustOpened : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Firebase(url: "https://whereareu.firebaseio.com/")
        
        // Setup delegates
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if appJustOpened {
            // Attempt to sign in silently, this will succeed if
            // the user has recently been authenticated
            GIDSignIn.sharedInstance().signInSilently()
            appJustOpened = false
        } else {
            // The user got here from unwinding so they must have chosen to sign out
            print("LOGGED OUT!")
            signOut()
        }
    
    }
    
    func authenticateWithGoogle(sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func signOut() {
        GIDSignIn.sharedInstance().signOut()
        ref.unauth()
    }
    
    // Implement the required GIDSignInDelegate methods
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            // Auth with Firebase
            ref.authWithOAuthProvider("google", token: user.authentication.accessToken, withCompletionBlock: { (error, authData) in
                
                // User is logged in!
                print("LOGGED IN!")
                let userEmail = authData.providerData["email"] as! String
                self.userId = authData.providerData["id"] as! String
                let userName = authData.providerData["displayName"] as! String
                print(userEmail, " ", self.userId, " ", userName)
                
                let manager = FirebaseManager(myUID: self.userId, myName: userName)
                manager.checkForUserId(self.userId, callback: {
                    (flag) in
                    if ( flag ) {
                        self.performSegueWithIdentifier("login", sender: self)
                    } else {
                        self.performSegueWithIdentifier("addUser", sender: self)
                    }
                })
            })
            
        } else {
            // Don't assert this error it is commonly returned as nil
            print("\(error.localizedDescription)")
        }
    }
    
    // Implement the required GIDSignInDelegate methods
    // Unauth when disconnected from Google
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        ref.unauth();
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? NewUserTableViewController {
            dest.myUID = self.userId
        }
        if let dest = segue.destinationViewController as? UINavigationController {
            if let tab = dest.topViewController as? MainMenuTabBarController {
                if let first = tab.viewControllers![0] as? FeedViewController {
                    first.myUID = self.userId
                }
            }
        }
    }
    
    @IBAction func unwindToAuth(segue: UIStoryboardSegue) {
        // Serves as an unwind point for signing out later on
    }
}
