//
//  OpenProfileSingleton.swift
//  bucovat
//
//  Created by Arnold Mitricã on 19.03.2021.
//

import Foundation

class OpenProfileManager{
    static let shared = OpenProfileManager()
    private var profilesViewModels:Cache<NSString,ProfileViewModel> = Cache<NSString,ProfileViewModel>()
    private var profilesCached:Cache<NSString,ProfileInfoModel> = Cache<NSString,ProfileInfoModel>()
    
    private init() { }
    
    func saveInfoModel(email:String, profile:ProfileInfoModel){
        profilesCached.insert(profile, forKey: NSString(string: email))
    }
    
    func saveViewModel(email:String, profile: ProfileViewModel){
        profilesViewModels.insert(profile, forKey: NSString(string: email))
    }
    
    func checkViewModel(email:String) -> Bool {
        guard let _ = profilesViewModels.value(forKey: NSString(string: email)) else { return false }
        return true
    }
    
    func checkInfoModel(email:String) -> Bool{
        guard let _ = profilesCached.value(forKey: NSString(string: email)) else { return false }
        return true
    }
    
    func getViewModel(email: String) -> ProfileViewModel?{
        guard let profile = profilesViewModels.value(forKey: NSString(string: email)) else { return nil }
        return profile
    }
    func getInfoModel(email:String) ->ProfileInfoModel?{
        guard let profile = profilesCached.value(forKey: NSString(string: email)) else { return nil }
        return profile
    }
}

