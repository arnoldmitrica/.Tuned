//
//  Utilities.swift
//  customauth
//
//  Created by Christopher Ching on 2019-05-09.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        //bottomLine.bounds = CGRect(x: 0, y: 0, width:  textfield.frame.size.width, height: textfield.frame.size.height)
        
       // bottomLine.frame = CGRect(x: -20, y: textfield.frame.size.height - 10, width: textfield.frame.size.width + 20, height: 2)
        bottomLine.frame = CGRect(x: -20, y: textfield.frame.size.height + 8, width: textfield.frame.size.width + 20, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        //textfield.addSubview(bottomLine)
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleLabel(_ label: UILabel){
        let topLine = CALayer()
        
        //let bottomLine = CALayer()

        //bottomLine.frame = CGRect(x: -10, y: 0, width: label.frame.size.width + 414, height: 5)
        
        //bottomLine.backgroundColor = UIColor.init(red: 155/255, green: 161/255, blue: 171/255, alpha: 1).cgColor

        topLine.frame = CGRect(x: 0, y: label.frame.size.height - 3, width: label.frame.size.width + 384, height: 2)
        
        topLine.backgroundColor = UIColor.init(red: 155/255, green: 161/255, blue: 171/255, alpha: 1).cgColor
        //textfield.addSubview(bottomLine)
        // Remove border on text field
        
        // Add the line to the text field
        label.layer.addSublayer(topLine)
        //label.layer.addSublayer(bottomLine)
    }
    
    static func styleView(_ view: UIView){
        let topLine = CALayer()
        //let bottomLine = CALayer()
        topLine.frame = CGRect(x: -10, y: -10, width: view.frame.size.width + 414, height: 7)
        //bottomLine.frame = CGRect(x: -10, y: -5, width: view.frame.size.width + 414, height: 5)
        topLine.backgroundColor = UIColor.init(red: 155/255, green: 161/255, blue: 171/255, alpha: 1).cgColor
        //bottomLine.backgroundColor = UIColor.init(red: 155/255, green: 161/255, blue: 171/255, alpha: 1).cgColor
        //textfield.addSubview(bottomLine)
        // Remove border on text field
        //view.layer.addSublayer(bottomLine)
        view.layer.addSublayer(topLine)
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 218/255, green: 143/255, blue: 255/255, alpha: 1)
        button.layer.cornerRadius = 15
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func styleShadow(_ textView: UITextView) {
        textView.autocorrectionType = .no
        textView.backgroundColor = .systemBackground
        textView.textColor = .secondaryLabel
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.layer.cornerRadius = 20
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.layer.shadowColor = UIColor.gray.cgColor;
        textView.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        textView.layer.shadowOpacity = 0.4
        textView.layer.shadowRadius = 20
        //textView.layer.masksToBounds = false
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
}
