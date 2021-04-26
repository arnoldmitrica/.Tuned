//
//  FeedProfileInfoController.swift
//  bucovat
//
//  Created by Arnold Mitricã on 19.04.2021.
//

import Foundation
import UIKit.UIImage
import FirebaseUI

class FeedProfileInfoController{
    var avatarImage = Observable<NSData>(value: NSData(data: UIImage(named: "unknown")!.pngData()!))
        //)= NSData(data: UIImage(named: "unknown")!.pngData()!)
    var profileInfoModel = Observable<ProfileInfoModel>(value: ProfileInfoModel(name: "", avatarImage: NSData(data: UIImage(named: "unknown")!.pngData()!)))
    let email:String
    var user:String
    init(email:String, user:String){
        self.email = email
        self.user = user
        
    }
    func start(){
//      OpenProfileManager.shared.temporarilyProfiles.value[email]?.append(user)
//        OpenProfileManager.shared.getInfoModel(email: email, user: user) { (result) in
//            switch result{
//            case .success(let profile):
//                self.user = profile.name
//                self.avatarImage.value = profile.avatarImage
//            case .failure(let error):
//                print("Failed getting profile infomodel \(error.localizedDescription)")
//            }
//        }
    }
}
