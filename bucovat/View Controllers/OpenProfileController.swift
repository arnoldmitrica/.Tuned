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
//        viewModel.profileView.value = OpenProfileManager.shared.getInfoModel(email: email, user: viewModel.name.value)
        let result = OpenProfileManager.shared.getInfoModelFromCache(email: email, user: viewModel.name.value)
        switch result {
        case .success(let profile):
            viewModel.profileView.value = profile
        case .failure(let error):
            print(error.localizedDescription)
        }
//        OpenProfileManager.shared.getInfooModel(email: email, user: viewModel.name.value) { [weak self] (state) in
//            if state{
//                let result = OpenProfileManager.shared.getInfoModelFromCache(email: email, user: (self?.viewModel.name.value)!)
//                switch result{
//                case .success(let profile):
//                    self?.viewModel.profileView.value = profile
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//        }
        fetchSecondBatchOfProfileInfoModel { (state) in
            if state{
                print("Fetching complete")
            }
        }
    }
    
    
    func fetchSecondBatchOfProfileInfoModel(completionHandler: @escaping (Bool) -> ()){
        guard let email = eAdress else { return }
        Fire.shared.getSecondBatchForProfileInfoModel(email: email, user: "tudo8") { [weak self] (res) in
            guard let strongSelf = self else { return }
            switch res {
            case .success(let val):
                let profile = OpenProfileManager.shared.getInfoModelFromCache(email: email, user: "Enel")
                switch profile{
                case .success(let profile):
                    profile.followers = val.followers
                    profile.following = val.following
                    profile.posts = val.posts
                    strongSelf.viewModel.profileView.value = profile
                    OpenProfileManager.shared.saveInfoModel(email: email, user: strongSelf.viewModel.name.value, profile: strongSelf.viewModel.profileView.value)

                case .failure(let error):
                    print(error.localizedDescription)
                }
//                strongSelf.viewModel.profileView.value = ProfileInfoModel(followers: val.followers, following: val.following, posts: val.posts, name: , avatarImage: <#T##NSData#>)
//                strongSelf.viewModel.profileView.value.followers = val.followers
//                strongSelf.viewModel.profileView.value.following = val.following
//                strongSelf.viewModel.profileView.value.posts = val.posts
//                OpenProfileManager.shared.saveInfoModel(email: email, user: strongSelf.viewModel.name.value, profile: strongSelf.viewModel.profileView.value)
                //OpenProfileManager.shared.saveViewModel(email: email, profile: self.viewModel)
                completionHandler(true)
            case .failure(let err):
                completionHandler(false)
                print(err)
            }
        }
    }
}
