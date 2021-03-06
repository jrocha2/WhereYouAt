//
//  MenuViewController.swift
//  WhereYouAt
//
//  Created by John Rocha on 4/19/16.
//  Copyright © 2016 Where You At. All rights reserved.
//
//  Referenced from http://dativestudios.com/blog/2014/06/29/presentation-controllers/

import UIKit


class MenuViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    var db: Database!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.dismiss))
        swipe.direction = .Left
        self.view.addGestureRecognizer(swipe)
        
        db.loadImage(db.profilePictures[db.userId]!, callback: {
            (image) in
            if image != nil {
                var pic = image?.rounded
                pic = image?.circle
                self.imageView.image = pic
            }
        })
        
        nameLabel.text = "\(db.profile!.firstName) \(db.profile!.lastName)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!)  {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        self.commonInit()
    }

    func commonInit() {
        self.modalPresentationStyle = .Custom
        self.transitioningDelegate = self
    }

    @IBAction func dismiss() {
        self.performSegueWithIdentifier("unwindToMenu", sender: self)
    }
    

    // ---- UIViewControllerTransitioningDelegate methods

    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {

        if presented == self {
            return CustomPresentationController(presentedViewController: presented, presentingViewController: presenting)
        }

        return nil
    }

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        if presented == self {
            return CustomPresentationAnimationController(isPresenting: true)
        }
        else {
            return nil
        }
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        if dismissed == self {
            return CustomPresentationAnimationController(isPresenting: false)
        }
        else {
            return nil
        }
    }

}
