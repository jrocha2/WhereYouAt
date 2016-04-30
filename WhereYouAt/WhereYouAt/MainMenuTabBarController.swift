//
//  MainMenuTabBarController.swift
//  WhereYouAt
//
//  Created by John Rocha on 4/12/16.
//  Copyright © 2016 Where You At. All rights reserved.
//
//  Subclass of UITabBarController to maintain a common database accessible by all the tabs

import UIKit
import ChameleonFramework

class MainMenuTabBarController: UITabBarController {

    var db : Database!
    var myUID : String = ""
    var swipe = UIScreenEdgePanGestureRecognizer()
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRevealMenuGesture()
        
        // Set the theme
        Chameleon.setGlobalThemeUsingPrimaryColor(UIColor.flatBlueColor(), withSecondaryColor: UIColor.flatBlueColorDark(), usingFontName: "SF UI Display", andContentStyle: .Light)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Normal)
        
        // Setup tab bar color scheme
        self.tabBar.tintColor = UIColor.whiteColor()
        self.tabBar.barTintColor = UIColor.flatBlueColor()
        
        self.tabBar.selectionIndicatorImage = UIImage().makeImageWithColorAndSize(UIColor.flatMintColor(), size: CGSizeMake(tabBar.frame.width/CGFloat(tabBar.items!.count), tabBar.frame.height))
        
        for item in tabBar.items! as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithColor(UIColor.whiteColor()).imageWithRenderingMode(.AlwaysOriginal)
            }
        }

    }
    
    // Segue to the menu and remove the gesture
    func showMenu() {
        self.view.removeGestureRecognizer(swipe)
        performSegueWithIdentifier("showMenu", sender: self)
    }

    // Set the gesture for showing the menu and add it to the view
    func addRevealMenuGesture() {
        swipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.showMenu))
        swipe.edges = .Left
        self.view.addGestureRecognizer(swipe)
    }
    
    @IBAction func unwindToMainMenu(segue: UIStoryboardSegue) {
        addRevealMenuGesture()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "createStatus" {
            if let navController = segue.destinationViewController as? UINavigationController {
                if let dest = navController.topViewController as? LocationsTableViewController {
                    dest.db = self.db
                }
            }
        } else if segue.identifier == "showMenu" {
            if let dest = segue.destinationViewController as? MenuViewController {
               dest.db = self.db
            }
        }
    }
 

}

// http://stackoverflow.com/questions/33583693/how-to-change-tint-color-of-tab-bar-in-swift

extension UIImage {
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRectMake(0, 0, size.width, size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage {
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()! as CGContextRef
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        tintColor.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

