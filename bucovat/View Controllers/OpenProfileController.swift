//
//  OpenProfileController.swift
//  bucovat
//
//  Created by Arnold Mitricã on 17.03.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseUI

class OpenProfileController{
    let viewModel: ProfileViewModel
    var eAdress:String?

    init(viewModel: ProfileViewModel = ProfileViewModel()) {
        self.viewModel = viewModel
    }

    func start() {
        guard let email = self.viewModel.email.value else { return }
        eAdress = email
        
        if !OpenProfileManager.shared.checkInfoModel(email: email){
            fetchData { _ in
            }
        }
        else{
            if let infoValues = OpenProfileManager.shared.getInfoModel(email: email){
                self.viewModel.profileView.value = infoValues
                print("else statement \(infoValues)")
            }
        }
    }
    
    func fetchData(completionHandler: @escaping (Bool) -> ()){
        guard let email = eAdress else { return }
        Fire.shared.getProfileRT(email: email) { (res) in
            switch res {
            case .success(let val): let profile = ProfileInfoModel(followers: val.followers, following: val.following, posts: val.posts)
                self.viewModel.profileView.value = profile
                print(val)
                OpenProfileManager.shared.saveInfoModel(email: email, profile: profile)
                OpenProfileManager.shared.saveViewModel(email: email, profile: self.viewModel)
                completionHandler(true)
            case .failure(let err):
                completionHandler(false)
                print(err)
            }
        }
    }
}
