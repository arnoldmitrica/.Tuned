//
//  ProfileInfoModel.swift
//  bucovat
//
//  Created by Arnold Mitricã on 19.03.2021.
//

import Foundation
import UIKit.UIImage

class ProfileInfoModel:Hashable{
    static func == (lhs: ProfileInfoModel, rhs: ProfileInfoModel) -> Bool {
        return lhs.name == rhs.name
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    var followers:Int?
    var following:Int?
    var posts:Int?
    var name:String
    var avatarImage:NSData
    
    init(followers: Int?, following: Int?, posts:Int?, name:String, avatarImage:NSData){
        self.followers = followers
        self.following = following
        self.posts = posts
        self.name = name
        self.avatarImage = avatarImage
    }
    
    convenience init(name: String, avatarImage:NSData) {
        self.init(followers:nil,following:nil, posts: nil, name: name, avatarImage:avatarImage)
    }
    
    func nsDataToIMG()->UIImage{
        return UIImage(data: avatarImage as Data, scale: 1)!
    }
    //let email:String?
}

struct SecondBatch{
    let followers:Int?
    let following:Int?
    let posts:Int?
}

struct FirstBatch{
    let name:String
    let avatargImage:NSData
}
