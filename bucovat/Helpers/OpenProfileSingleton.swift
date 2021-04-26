//
//  OpenProfileSingleton.swift
//  bucovat
//
//  Created by Arnold Mitricã on 19.03.2021.
//

import Foundation
import UIKit.UIImage

class OpenProfileManager{
    static let shared = OpenProfileManager()
    private var profilesViewModels:Cache<NSString,ProfileViewModel> = Cache<NSString,ProfileViewModel>()
    private var profilesCached:Cache<NSString,ProfileInfoModel> = Cache<NSString,ProfileInfoModel>()
    typealias ResultProfileInfoModel = Result<ProfileInfoModel, Error>
    
    var multiObsv: MultiObservable = MultiObservable()
    private init() { }
    
    func saveInfoModel(email:String,user:String, profile:ProfileInfoModel){
        profilesCached.insert(profile, forKey: NSString(string: "\(email)/\(user)"))
        //profilesCached.addObserver(forKey: <#T##NSString#>)
    }
    
    func saveViewModel(email:String, profile: ProfileViewModel){
        profilesViewModels.insert(profile, forKey: NSString(string: email))
    }
    
    func checkViewModel(email:String) -> Bool {
        guard let _ = profilesViewModels.value(forKey: NSString(string: email)) else { return false }
        return true
    }
    func resetInfoModel(){
        profilesCached = Cache<NSString,ProfileInfoModel>()
    }
    
    func checkInfoModel(email:String, user:String) -> Bool{
        guard let _ = profilesCached.value(forKey: NSString(string: "\(email)/\(user)")) else {
            print("checkInfoModel false")
            return false
            
        }
        return true
    }
    
    func getViewModel(email: String) -> ProfileViewModel?{
        guard let profile = profilesViewModels.value(forKey: NSString(string: email)) else { return nil }
        return profile
    }
    
    func printProfilesInfoModel(){
        //OpenProfileManager.shared.saveInfoModel(email: "tudo8", user: "tudo8", profile: ProfileInfoModel(followers: 0, following: 0, posts: 0, name: "tudo8", avatarImage: NSData(data: UIImage(named: "unknown")!.pngData()!)))
        profilesCached.printValues()
//        if let all = profilesCached.value(forKey: "allObjects") as? NSArray {
//            for object in all {
//                print("object is \(object)")
//            }
//        }
    }
    
    func getInfoModelFromCache(email:String, user: String) -> ResultProfileInfoModel{
        if let profile = profilesCached.value(forKey: NSString(string: "\(email)/\(user)")){
            return ResultProfileInfoModel.success(profile)
        }
        return ResultProfileInfoModel.failure(TunedError.cacheMissingForProfileInfo)
    }
    
    func removeObserversForQueue(){
        //resultingProfilesInQueue.removeObserver()
    }
    
    func getInfooModel(email:String, user: String, completionHandler: ((Bool) -> Void)?){
        
        if !checkInfoModel(email: email, user: user){
            profilesCached.insert(ProfileInfoModel(name: user, avatarImage: NSData(data: UIImage(named: "unknown")!.pngData()!)), forKey: NSString(string: "\(email)/\(user)"))
            //res5.addNewObservable(uuid: uuid, newObsv: NewObservable(key: UUID(), value: false))
            multiObsv.addNewObservable(uniqueProfile: UniqueProfile(email: email, user: user), newObsv: NewObservable(key: UUID(), value: true))
            Fire.shared.fetchFirstBatchOfProfileInfoModel(from: email, and: user) { [weak self] (res) in
                //self?.resultingProfilesInQueue.value[[email,user]] = res
                switch res{
                case .success(let profile):
                    self?.saveInfoModel(email: email, user: user, profile: profile)

                    self?.multiObsv.observables[UniqueProfile(email: email, user: user)]?.value = true
                    if let completion = completionHandler {
                        completion(false)
                    }

                    
                case .failure(let err):
                    print(err.localizedDescription)
                    
                }
            }
            if let completion = completionHandler{
                print("checkInfoModel false")
                completion(true)
            }
            
        
        }
        else{
            guard let completion = completionHandler else { return }

            multiObsv.observables[UniqueProfile(email: email, user: user)]?.addAnotherObserver(fireNow: false, {
                completion(false)
            }, for: UUID())
            
            print("checkInfoModel true")
        }
    }
    
}

