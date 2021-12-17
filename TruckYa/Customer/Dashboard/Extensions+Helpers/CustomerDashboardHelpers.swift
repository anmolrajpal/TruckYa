//
//  CustomerDashboardHelpers.swift
//  TruckYa
//
//  Created by Digit Bazar on 11/12/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
extension CustomerDashboardVC: UIGestureRecognizerDelegate {
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if gestureRecognizer is UIRotationGestureRecognizer {
//            panRecognizer.isEnabled = false
//            return false
//        }
//        panRecognizer.isEnabled = true
//        return true
//    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if gestureRecognizer is UIRotationGestureRecognizer {
//            panRecognizer.shouldBeRequiredToFail(by: gestureRecognizer as! UIRotationGestureRecognizer)
//        }

        if (gestureRecognizer is UIPanGestureRecognizer || gestureRecognizer is UIRotationGestureRecognizer) {
            return true
        } else {
            return false
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let viewBounds = subView.popupView.bounds.contains(touch.location(in: subView.collectionView))
        if viewBounds { return false }
        return true
    }
}
extension CustomerDashboardVC {
    
    //    lazy var panRecognizer: UIPanGestureRecognizer = {
    //        let recognizer = UIPanGestureRecognizer()
    //        recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
    //        recognizer.delegate = self
    //
    //        return recognizer
    //
    //    }()
    /// Animates the transition, if the animation is not already running.
    internal func animateTransitionIfNeeded(to state: State, duration: TimeInterval) {
        
        // ensure that the animators array is empty (which implies new animations need to be created)
        guard runningAnimators.isEmpty else { return }
        
        // an animator for the transition
        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.subView.topConstraint.constant = -(self.subView.frame.height - self.subView.safeAreaInsets.top - 15)
                self.subView.overlayView.alpha = 0.5
                //                    self.subView.closedTitleLabel.transform = CGAffineTransform(scaleX: 1.6, y: 1.6).concatenating(CGAffineTransform(translationX: 0, y: 15))
            //                    self.subView.openTitleLabel.transform = .identity
            case .closed:
                self.subView.topConstraint.constant = self.subView.popupOffset
                self.subView.overlayView.alpha = 0
                //                    self.subView.closedTitleLabel.transform = .identity
                //                    self.subView.openTitleLabel.transform = CGAffineTransform(scaleX: 0.65, y: 0.65).concatenating(CGAffineTransform(translationX: 0, y: -15))
            }
            self.subView.layoutIfNeeded()
        })
        
        // the transition completion block
        transitionAnimator.addCompletion { position in
            
            // update the state
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            @unknown default:
                fatalError()
            }
            
            // manually reset the constraint positions
            switch self.currentState {
            case .open:
                self.subView.topConstraint.constant = -(self.subView.frame.height - self.subView.safeAreaInsets.top - 15)
            case .closed:
                self.subView.topConstraint.constant = self.subView.popupOffset
            }
            
            // remove all running animators
            self.runningAnimators.removeAll()
            
        }
        
        // an animator for the title that is transitioning into view
        let popupViewTitleAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeIn, animations: {
            switch state {
            case .open:
                self.subView.popupViewTitleLabel.alpha = 0.8
            case .closed:
                self.subView.popupViewTitleLabel.alpha = 1
            }
        })
        popupViewTitleAnimator.scrubsLinearly = false
        
        let collectionViewAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeIn, animations: {
            switch state {
            case .open:
                self.subView.collectionView.alpha = 1
            case .closed:
                self.subView.collectionView.alpha = 0.9
            }
        })
        collectionViewAnimator.scrubsLinearly = false
        
        // an animator for the title that is transitioning out of view
        let mapViewAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeOut, animations: {
            switch state {
            case .open:
                self.subView.mapView.alpha = 0.2
            case .closed:
                self.subView.mapView.alpha = 1
            }
        })
        mapViewAnimator.scrubsLinearly = false
        
        // start all animators
        transitionAnimator.startAnimation()
        popupViewTitleAnimator.startAnimation()
        collectionViewAnimator.startAnimation()
        mapViewAnimator.startAnimation()
        
        // keep track of all running animators
        runningAnimators.append(transitionAnimator)
        runningAnimators.append(popupViewTitleAnimator)
        runningAnimators.append(collectionViewAnimator)
        runningAnimators.append(mapViewAnimator)
    }
    
    @objc func popupViewPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            // start the animations
            animateTransitionIfNeeded(to: currentState.opposite, duration: 0.6)
            
            // pause all animations, since the next event may be a pan changed
            runningAnimators.forEach { $0.pauseAnimation() }
            
            // keep track of each animator's progress
            animationProgress = runningAnimators.map { $0.fractionComplete }
            
        case .changed:
            
            // variable setup
            let translation = recognizer.translation(in: subView.popupView)
            var fraction = -translation.y / 600
            
            // adjust the fraction for the current state and reversed state
            if currentState == .open { fraction *= -1 }
            if runningAnimators[0].isReversed { fraction *= -1 }
            
            // apply the new fraction
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }
            
        case .ended:
            
            // variable setup
            let yVelocity = recognizer.velocity(in: subView.popupView).y
            let shouldClose = yVelocity > 0
            
            // if there is no motion, continue all animations and exit early
            if yVelocity == 0 {
                runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
                break
            }
            
            // reverse the animations based on their current state and pan motion
            switch currentState {
            case .open:
                if !shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            case .closed:
                if shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if !shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            }
            
            // continue all animations
            runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
            
        default:
            ()
        }
    }
}
