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
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Firebase(url: "https://whereareu.firebaseio.com/")
        
        // Setup delegates
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Attempt to sign in silently, this will succeed if
        // the user has recently been authenticated
        GIDSignIn.sharedInstance().signInSilently()
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
                let userId = authData.providerData["id"] as! String
                let userName = authData.providerData["displayName"] as! String
                print(userEmail, " ", userId, " ", userName)
                
                let manager = FirebaseManager(myUID: userId, myName: userName)
                manager.addNewUser(userId)
                let myProfile = Profile(userId: userId, firstName: "John", lastName: "Rocha", gender: .Male, year: .Junior, phoneNumber: "713-501-1554")
                manager.updateProfile(myProfile)
                manager.addFriend("5246535135", userId: "meeeeeeeeee")
                let db = Database()

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
}
