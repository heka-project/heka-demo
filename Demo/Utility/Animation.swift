//
//  Animation.swift
//  Demo
//
//  Created by Sean Lim on 25/10/18.
//  Copyright © 2018 Heka. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
	func rotateAnimation(key: String, rep: Float, duration: Float) {
		let anim = CABasicAnimation.init(keyPath: "transform.rotation.z")
		anim.toValue = NSNumber(value: M_PI * 2.0)
		anim.duration = CFTimeInterval(duration)
		anim.isCumulative = true
		anim.repeatCount = rep
		anim.timingFunction = CAMediaTimingFunction(name: .linear)
		self.layer.add(anim, forKey: key)
	}
	
	func addRippleEffect(pos: CGPoint, size: CGRect) {
		let path = UIBezierPath.init(ovalIn: size)
		
		let shape = CAShapeLayer()
		shape.bounds = size
		shape.path = path.cgPath
		shape.fillColor = UIColor.clear.cgColor
		shape.strokeColor = UIColor(red:0.48, green:0.48, blue:0.73, alpha:1.0).cgColor
		shape.lineWidth = 1
		shape.position = pos
		shape.opacity = 0
		
		let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
		scaleAnim.fromValue = NSValue.init(caTransform3D: CATransform3DIdentity)
		scaleAnim.toValue = NSValue(caTransform3D: CATransform3DMakeScale(5, 5, 1))
		
		let opacityAnim = CABasicAnimation(keyPath: "opacity")
		opacityAnim.fromValue = 1
		opacityAnim.toValue = nil
		
		let animation = CAAnimationGroup()
		animation.animations = [scaleAnim, opacityAnim]
		animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
		animation.duration = 2.5
		animation.repeatCount = .infinity
		animation.isRemovedOnCompletion = true
		
		self.layer.addSublayer(shape)
		shape.add(animation, forKey: "rippleEffect")
		
	}
}
