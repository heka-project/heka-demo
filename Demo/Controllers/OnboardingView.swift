//
//  OnboardView.swift
//  Demo
//
//  Created by Sean Lim on 6/11/18.
//  Copyright © 2018 Heka. All rights reserved.
//

import Foundation
import UIKit
import Hero

class OnboardingView: BaseView, UIGestureRecognizerDelegate {
	
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var subtitleLabel: UILabel!
	@IBOutlet var doneButton: UIButton!
	
	var animationType: HeroDefaultAnimationType {
		switch self.restorationIdentifier {
		case "onboard7": return .slide(direction: .left)
		default: return .slide(direction: .up)
		}
	}
	
	var onboardCompletion: Float {
		return (["onboard1" : 1, "onboard2" : 2, "onboard3" : 3, "onboard4" : 4, "onboard5" : 5, "onboard6" : 6, "onboard7" : 7][self.restorationIdentifier] ?? 1 ) / 7
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController?.hero.navigationAnimationType = animationType
		self.setupGestures()
		
		doneButton?.roundify(5.0)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		let progressIndicator = UIProgressView.init(frame: CGRect.init(x: 0, y: self.view.frame.height - 2, width: self.view.frame.width, height: 20))
		progressIndicator.tintColor = UIColor.appPink(a: 1)
		progressIndicator.trackTintColor = .clear
		progressIndicator.setProgress(onboardCompletion, animated: false)
		progressIndicator.hero.id = "progress"
		self.view.addSubview(progressIndicator)
	}
	
	@objc func swipedLeft() {
		if self.restorationIdentifier != "onboard7" {
			self.performSegue(withIdentifier: "next", sender: self)
		}
	}
	
	@objc func swipedRight() {
		self.navigationController?.popViewController(animated: true)
	}
	
	func setupGestures() {
		let leftGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(OnboardingView.swipedLeft))
		leftGesture.direction = .left
		leftGesture.delegate = self
		self.view.addGestureRecognizer(leftGesture)
		
		let rightGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(OnboardingView.swipedRight))
		rightGesture.direction = .right
		rightGesture.delegate = self
		self.view.addGestureRecognizer(rightGesture)
	}
	
}