//
//  CustomMessageCell.swift
//  bucovat
//
//  Created by Arnold Mitricã on 29.12.2020.
//

import Foundation
import UIKit
import MaterialComponents.MaterialButtons

class CustomMessageCell: UITableViewCell{
    
    var company: String?
    var coimage: UIImage?
    var admin: String?
    var message: String?
    var timestamp: String?
    
    lazy var messageView: UILabel = {
        var labelView = UILabel()
        labelView.backgroundColor = .clear
        //labelView.numberOfLines = 3
        //labelView.contentMode = .scaleAspectFit
       labelView.translatesAutoresizingMaskIntoConstraints = false
        return labelView
    }()
    lazy var adminView: UILabel = {
        var adminView = UILabel()
        adminView.backgroundColor = .clear
        adminView.translatesAutoresizingMaskIntoConstraints = false
        return adminView
    }()
    lazy var companyView: UILabel = {
        var companyView = UILabel()
        companyView.backgroundColor = .clear
        companyView.translatesAutoresizingMaskIntoConstraints = false
        return companyView
    }()
    lazy var coimageView: UIImageView = {
        var imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    lazy var reactions: UIView = {
        let reactionsview = UIView()
        //reactionsview.translatesAutoresizingMaskIntoConstraints = false
        let savebutton = MDCButton(type: .system)
        savebutton.accessibilityLabel = "Confirm"
        savebutton.setTitle("Confirm", for: .normal)
        savebutton.setBackgroundColor(UIColor.init(red: 231/255, green: 231/255, blue: 231/255, alpha: 1))
        savebutton.setImage(UIImage(named: "confirm36.png"), for: .normal)
        savebutton.tintColor = UIColor.rgb(red: 67, green: 69, blue: 73)
        savebutton.imageEdgeInsets.right = CGFloat(10)
        savebutton.imageEdgeInsets.bottom = CGFloat(4)
        savebutton.layer.cornerRadius = 5
        savebutton.setTitleColor(UIColor.init(red: 32/255, green: 34/255, blue: 40/255, alpha: 1), for: .normal)
        //savebutton.addTarget(self, action: #selector(savebuttonpressed(button: savebutton)), for: .touchUpInside)
        savebutton.addTarget(self, action: #selector(savebuttonpressed(button:)), for: .touchUpInside)
        reactionsview.addSubview(savebutton)
        
        let sharebutton = MDCButton(type: .system)
        sharebutton.accessibilityLabel = "Share"
        sharebutton.setTitle("Share", for: .normal)
        sharebutton.setImage(UIImage(named: "share36.png"), for: .normal)
        sharebutton.tintColor = UIColor.rgb(red: 67, green: 69, blue: 73)
        sharebutton.imageEdgeInsets.right = CGFloat(10)
        sharebutton.imageEdgeInsets.bottom = CGFloat(4)
        sharebutton.layer.cornerRadius = 5
        sharebutton.setTitleColor(UIColor.init(red: 32/255, green: 34/255, blue: 40/255, alpha: 1), for: .normal)
        sharebutton.addTarget(self, action: #selector(sharebuttonpressed(button:)), for: .touchUpInside)
       // sharebutton.setBackgroundColor(.systemRed, for: .)
        sharebutton.backgroundColor = UIColor.init(red: 231/255, green: 231/255, blue: 231/255, alpha: 1)
        reactionsview.addSubview(sharebutton)
        
        
        savebutton.anchor(top: reactionsview.topAnchor, left: reactionsview.leftAnchor, bottom: reactionsview.bottomAnchor, right: sharebutton.leftAnchor)
        
        savebutton.widthAnchor.constraint(equalTo: sharebutton.widthAnchor).isActive = true
        sharebutton.widthAnchor.constraint(equalTo: savebutton.widthAnchor).isActive = true
  
        sharebutton.anchor(top: reactionsview.topAnchor, left: savebutton.rightAnchor, bottom: reactionsview.bottomAnchor, right: reactionsview.rightAnchor)
        return reactionsview
    }()
    
    @objc func savebuttonpressed(button:UIButton){
//        UIView.animate(withDuration: 2) {
//            UIButton.pulsate(button: button)
//        }
        UIButton.pulsate(button: button)
        //UIButton.flash(button: button)
    }
    
    @objc func sharebuttonpressed(button:UIButton){
//        UIView.animate(withDuration: 2) {
//            UIButton.pulsate(button: button)
//        }
        UIButton.flash(button: button)
        //UIButton.flash(button: button)
    }
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        let stackinfo = UIStackView(arrangedSubviews: [companyView, adminView])
        
        stackinfo.translatesAutoresizingMaskIntoConstraints = false
        stackinfo.axis = .vertical
        stackinfo.distribution = .fillEqually
        let stack = UIStackView(arrangedSubviews: [coimageView, stackinfo])
        coimageView.widthAnchor.constraint(equalTo: stackinfo.widthAnchor, multiplier: 1/3).isActive = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        //stack.distribution = .fill

        contentView.addSubview(stack)
        contentView.addSubview(messageView)
        contentView.addSubview(reactions)
                
        stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        stack.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        stack.bottomAnchor.constraint(equalTo: messageView.topAnchor, constant: -10).isActive = true
        stack.backgroundColor = .white
        stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        
        messageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        messageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        messageView.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 10).isActive = true
        messageView.bottomAnchor.constraint(equalTo: reactions.topAnchor, constant: -10).isActive = true
        messageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        reactions.anchor(top: messageView.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, height: 48)
        
        
        
        Utilities.styleView(stack)
        Utilities.styleLabel(messageView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        if let message = message{
            messageView.text = message
            messageView.textColor = .black
        }
        if let companyimage = coimage{
            coimageView.image = companyimage
        }
        if let adminname = admin{
            
            let adminattributes : [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 8), .foregroundColor:UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)]
            let attributedString = NSMutableAttributedString(string: " ● " , attributes: adminattributes)
            
            attributedString.append(NSAttributedString(string: "posted by: " + adminname.capitalized, attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor:UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)]))
            
            attributedString.append(NSAttributedString(string: " ●", attributes: [.font: UIFont.systemFont(ofSize: 8), .foregroundColor:UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)]))
            
            if let time = timestamp{
                attributedString.append(NSAttributedString(string: " " + time, attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor:UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)]))
                
                attributedString.append(NSAttributedString(string: " ●", attributes: [.font: UIFont.systemFont(ofSize: 8), .foregroundColor:UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)]))
            }
            adminView.attributedText = attributedString
            adminView.textColor = .black
        }
        if let companyname = company{
            let companyattributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 14)]
            //companyView.attributedText = NSAttributedString(string: companyname.capitalized, attributes: companyattributes)
            companyView.textColor = .black
            
            let globe = NSTextAttachment()
            globe.image = UIImage(named: "globe_small.png")
            globe.bounds = CGRect(x: 0, y: -8 , width: 28, height: 28)
            let attributedString = NSMutableAttributedString(string: companyname.capitalized, attributes: companyattributes)
            attributedString.append(NSAttributedString(attachment: globe))
            companyView.attributedText = attributedString

        }

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
