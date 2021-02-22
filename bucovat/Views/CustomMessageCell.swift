//
//  CustomMessageCell.swift
//  bucovat
//
//  Created by Arnold Mitricã on 29.12.2020.
//

import Foundation
import UIKit

class CustomMessageCell: UITableViewCell{
    
    var company: String?
    var coimage: UIImage?
    var admin: String?
    var message: String?
    
    var messageView: UILabel = {
        var labelView = UILabel()
        labelView.backgroundColor = .white
        //labelView.numberOfLines = 3
        //labelView.contentMode = .scaleAspectFit
       labelView.translatesAutoresizingMaskIntoConstraints = false
        return labelView
    }()
    var adminView: UILabel = {
        var adminView = UILabel()
        adminView.backgroundColor = .clear
        adminView.translatesAutoresizingMaskIntoConstraints = false
        return adminView
    }()
    var companyView: UILabel = {
        var companyView = UILabel()
        companyView.backgroundColor = .clear
        companyView.translatesAutoresizingMaskIntoConstraints = false
        return companyView
    }()
    var coimageView: UIImageView = {
        var imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemGray2
        let stack = UIStackView(arrangedSubviews: [coimageView, companyView, adminView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        contentView.addSubview(stack)
        contentView.addSubview(messageView)
        
        
        stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        stack.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        stack.bottomAnchor.constraint(equalTo: messageView.topAnchor).isActive = true
        stack.backgroundColor = .systemGray
        stack.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        
        messageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        messageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        messageView.topAnchor.constraint(equalTo: stack.bottomAnchor).isActive = true
        messageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        messageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
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
            adminView.text = adminname
            adminView.textColor = .black
        }
        if let companyname = company{
            companyView.text = companyname
            companyView.textColor = .black

        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
