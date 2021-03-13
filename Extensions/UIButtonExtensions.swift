//
//  UIButtonExtensions.swift
//  bucovat
//
//  Created by Arnold Mitricã on 02.03.2021.
//

import Foundation
import UIKit

extension UIButton{
    static func pulsate(button: UIButton) {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.4
        pulse.fromValue = 0.9
        pulse.toValue = 1.0
        pulse.autoreverses = false
        pulse.repeatCount = 0
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        button.layer.add(pulse, forKey: nil)
    }
    static func flash(button: UIButton) {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.3
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = false
        flash.repeatCount = 0
        button.layer.add(flash, forKey: nil)
    }
}
