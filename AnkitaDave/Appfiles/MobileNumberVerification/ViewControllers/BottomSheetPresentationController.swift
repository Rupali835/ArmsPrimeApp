//
//  BottomSheetPresentationController.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 12/05/20.
//  Copyright © 2020 Armsprime. All rights reserved.
//

import Foundation
import UIKit

/// BottomSheetPresentationController is a UIPresentationController that allows
/// modals to be presented like a bottom sheet. The kind of presentation style
/// you can see on the Maps app on iOS.
///
/// Return a BottomSheetPresentationController in a UIViewControllerTransitioningDelegate.

public class BottomSheetPresentationController: UIPresentationController {
    
    /// Optional attributes
        
    /// Public setable attributes
    
    /// Blur effect for the view displayed behind the drawer.
    ///   -------
    ///  |...A...|
    ///  |.......|
    ///  |.......|    . = Bulrred view
    ///  |/¯¯¯¯¯\|    A = Presenting
    ///  |   B   |    B = Presented (Modal)
    ///  |_______|
    public var blurEffectStyle: UIBlurEffect.Style = .light
    
    /// Modal height, you probably want to change it on an iPad to prevent it
    /// taking the whole width available.
    /// 0 = same with of the presenting view controller.
    ///   -------
    ///  |   A   |
    ///  |       |     A = Presenting
    ///  |       |     B = Presented (Modal)
    ///  |/¯¯¯¯¯\|  |
    ///  |   B   | <| -> This is the modal height
    ///  |_______|  |
    public var modalHeight: CGFloat = 425
    
    /// Toggle the bounce value to allow the modal to bounce when it's being
    /// dragged top, over the max width (add the top gap).
    public var bounce: Bool = false
    
    /// The modal corners radius.
    /// The default value is 20 for a minimal yet elegant radius.
    public var cornerRadius: CGFloat = 20
    
    /// Set the modal's corners that should be rounded.
    /// Defaults are the two top corners.
    public var roundedCorners: UIRectCorner = [.topLeft, .topRight]
    
    /// Frame for the modally presented view.
    override public var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height-self.modalHeight), size: CGSize(width: self.containerView!.frame.width, height: self.modalHeight))
    }
    
    /// Private Attributes    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: self.blurEffectStyle))
        blur.isUserInteractionEnabled = true
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blur
    }()
    
    /// Initializers
    /// Init with non required values - defaults are provided.
    public convenience init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, blurEffectStyle: UIBlurEffect.Style = .light, cornerRadius: CGFloat = 20, modalHeight: CGFloat = 425) {
        self.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.blurEffectStyle = blurEffectStyle
        self.cornerRadius = cornerRadius
        self.modalHeight = modalHeight
    }
    /// Regular init.
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override public func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.removeFromSuperview()
        })
    }
    
    override public func presentationTransitionWillBegin() {
        self.blurEffectView.alpha = 0
        // Add the blur effect view
        guard let presenterView = self.containerView else { return }
        presenterView.addSubview(self.blurEffectView)
        
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 1
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
    }
    
    override public func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        guard let presentedView = self.presentedView else { return }
        
        presentedView.layer.masksToBounds = true
        presentedView.roundCorners(corners: self.roundedCorners, radius: self.cornerRadius)
    }
    
    override public func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        guard let presenterView = self.containerView else { return }

        // Set the blur effect frame, behind the modal
        self.blurEffectView.frame = presenterView.bounds
    }
    
    @objc func dismiss() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
}
