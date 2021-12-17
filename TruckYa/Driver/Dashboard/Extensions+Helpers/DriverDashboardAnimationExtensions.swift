//
//  DriverDashboardAnimationExtensions.swift
//  TruckYa
//
//  Created by Digit Bazar on 02/12/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
extension DriverDashboardVC {
    
    
    /// Animates the transition, if the animation is not already running.
    internal func metaAnimateTransitionIfNeeded(to state: State, duration: TimeInterval) {
        
        // ensure that the animators array is empty (which implies new animations need to be created)
        guard metaRunningAnimators.isEmpty else { return }
        
        // an animator for the transition
        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.subView.metaBottomConstraint.constant = 0
                self.subView.metaPopupView.layer.cornerRadius = 20
                self.subView.overlayView.alpha = 0.5
                //                    self.subView.closedTitleLabel.transform = CGAffineTransform(scaleX: 1.6, y: 1.6).concatenating(CGAffineTransform(translationX: 0, y: 15))
            //                    self.subView.openTitleLabel.transform = .identity
            case .closed:
                self.subView.metaBottomConstraint.constant = self.subView.metaPopupOffset
                self.subView.metaPopupView.layer.cornerRadius = 20
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
                self.metaCurrentState = state.opposite
            case .end:
                self.metaCurrentState = state
            case .current:
                ()
            @unknown default:
                fatalError()
            }
            
            // manually reset the constraint positions
            switch self.metaCurrentState {
            case .open:
                self.subView.metaBottomConstraint.constant = 0
            case .closed:
                self.subView.metaBottomConstraint.constant = self.subView.metaPopupOffset
            }
            
            // remove all running animators
            self.metaRunningAnimators.removeAll()
            
        }
        
        // an animator for the title that is transitioning into view
        let inTitleAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeIn, animations: {
            switch state {
            case .open:
                self.subView.customerNameLabel.alpha = 1
            case .closed:
                self.subView.customerNameLabel.alpha = 0.8
            }
        })
        inTitleAnimator.scrubsLinearly = false
        
        // an animator for the title that is transitioning out of view
        let outTitleAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeOut, animations: {
            switch state {
            case .open:
                self.subView.customerNameLabel.alpha = 1
            case .closed:
                self.subView.customerNameLabel.alpha = 0.8
            }
        })
        outTitleAnimator.scrubsLinearly = false
        
        // start all animators
        transitionAnimator.startAnimation()
        inTitleAnimator.startAnimation()
        outTitleAnimator.startAnimation()
        
        // keep track of all running animators
        metaRunningAnimators.append(transitionAnimator)
        metaRunningAnimators.append(inTitleAnimator)
        metaRunningAnimators.append(outTitleAnimator)
        
    }
    
    @objc internal func metaPopupViewPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            // start the animations
            metaAnimateTransitionIfNeeded(to: metaCurrentState.opposite, duration: 0.6)
            
            // pause all animations, since the next event may be a pan changed
            metaRunningAnimators.forEach { $0.pauseAnimation() }
            
            // keep track of each animator's progress
            metaAnimationProgress = metaRunningAnimators.map { $0.fractionComplete }
            
        case .changed:
            
            // variable setup
            let translation = recognizer.translation(in: subView.metaPopupView)
            var fraction = -translation.y / subView.metaPopupOffset
            
            // adjust the fraction for the current state and reversed state
            if metaCurrentState == .open { fraction *= -1 }
            if metaRunningAnimators[0].isReversed { fraction *= -1 }
            
            // apply the new fraction
            for (index, animator) in metaRunningAnimators.enumerated() {
                animator.fractionComplete = fraction + metaAnimationProgress[index]
            }
            
        case .ended:
            
            // variable setup
            let yVelocity = recognizer.velocity(in: subView.metaPopupView).y
            let shouldClose = yVelocity > 0
            
            // if there is no motion, continue all animations and exit early
            if yVelocity == 0 {
                metaRunningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
                break
            }
            
            // reverse the animations based on their current state and pan motion
            switch metaCurrentState {
            case .open:
                if !shouldClose && !metaRunningAnimators[0].isReversed { metaRunningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if shouldClose && metaRunningAnimators[0].isReversed { metaRunningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            case .closed:
                if shouldClose && !metaRunningAnimators[0].isReversed { metaRunningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if !shouldClose && metaRunningAnimators[0].isReversed { metaRunningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            }
            
            // continue all animations
            metaRunningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
            
        default:
            ()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
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
                self.subView.bottomConstraint.constant = 0
                self.subView.popupView.layer.cornerRadius = 20
                self.subView.overlayView.alpha = 0.5
                self.subView.closedTitleLabel.transform = CGAffineTransform(scaleX: 1.6, y: 1.6).concatenating(CGAffineTransform(translationX: 0, y: 15))
                self.subView.openTitleLabel.transform = .identity
            case .closed:
                self.subView.bottomConstraint.constant = self.subView.popupOffset
                self.subView.popupView.layer.cornerRadius = 20
                self.subView.overlayView.alpha = 0
                self.subView.closedTitleLabel.transform = .identity
                self.subView.openTitleLabel.transform = CGAffineTransform(scaleX: 0.65, y: 0.65).concatenating(CGAffineTransform(translationX: 0, y: -15))
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
                self.subView.bottomConstraint.constant = 0
            case .closed:
                self.subView.bottomConstraint.constant = self.subView.popupOffset
            }
            
            // remove all running animators
            self.runningAnimators.removeAll()
            
        }
        
        // an animator for the title that is transitioning into view
        let inTitleAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeIn, animations: {
            switch state {
            case .open:
                self.subView.openTitleLabel.alpha = 1
            case .closed:
                self.subView.closedTitleLabel.alpha = 1
            }
        })
        inTitleAnimator.scrubsLinearly = false
        
        // an animator for the title that is transitioning out of view
        let outTitleAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeOut, animations: {
            switch state {
            case .open:
                self.subView.closedTitleLabel.alpha = 0
            case .closed:
                self.subView.openTitleLabel.alpha = 0
            }
        })
        outTitleAnimator.scrubsLinearly = false
        
        // start all animators
        transitionAnimator.startAnimation()
        inTitleAnimator.startAnimation()
        outTitleAnimator.startAnimation()
        
        // keep track of all running animators
        runningAnimators.append(transitionAnimator)
        runningAnimators.append(inTitleAnimator)
        runningAnimators.append(outTitleAnimator)
        
    }
    
    @objc internal func popupViewPanned(recognizer: UIPanGestureRecognizer) {
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
            var fraction = -translation.y / subView.popupOffset
            
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
