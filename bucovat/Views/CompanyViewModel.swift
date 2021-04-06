//
//  CompanyViewModel.swift
//  bucovat
//
//  Created by Arnold Mitricã on 04.04.2021.
//

import Foundation
import UIKit.UIImage

protocol RowViewModel{
    var name: String { get }
    var email:String { get }
}

class CompanyViewModel:RowViewModel{
    let email:String
    let name:String
    let avatarImage:Observable<UIImage>
    let postImage:Observable<UIImage?>
    let message:Observable<String?>
    let timestamp:Observable<String>
    init(email: String,name:String,avatarImage:Observable<UIImage>,postImage:Observable<UIImage?>,message:Observable<String?>, timestamp:Observable<String>){
        self.name = name
        self.avatarImage = avatarImage
        self.postImage = postImage
        self.message = message
        self.timestamp = timestamp
        self.email = email
    }
    convenience init(email:String, name:String,avatarImage:Observable<UIImage>, message: Observable<String?>, timestamp:Observable<String>){
        self.init(email: email, name: name,avatarImage: avatarImage,postImage: Observable<UIImage?>(value: nil),message: message, timestamp: timestamp)
    }
    convenience init(email:String, name:String,avatarImage:Observable<UIImage>, postImage:Observable<UIImage?>, timestamp:Observable<String>){
        self.init(email: email, name:name,avatarImage: avatarImage,postImage: postImage,message:  Observable<String?>(value: nil), timestamp: timestamp)
    }
}
