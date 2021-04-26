//
//  HomeController.swift
//  bucovat
//
//  Created by Arnold Mitricã on 03.04.2021.
//

import Foundation
import UIKit.UIImage

class HomeController{
    let viewModel:HomeViewModel
    typealias ResultProfileInfoModel = Result<ProfileInfoModel, Error>
    
    init(viewModel:HomeViewModel){
        self.viewModel = viewModel
    }
    init(){
        self.viewModel = HomeViewModel()
    }
    
    func start() {
        self.viewModel.isLoading.value = true
        self.viewModel.isTableViewHidden.value = true
        self.viewModel.title.value = "Loading..."
        let collectionref = Fire.shared.getFeedCollectionRef()
        print("Setting newsfeed called", "path is \(collectionref.path)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("Loading")
        }
//        OpenProfileManager.shared.temporarilyProfiles.addObserver { (tempProfiles) in
//            for i in tempProfiles{
//                Fire.shared.fetchFirstBatchOfProfileInfoModel(from: <#T##String#>, and: <#T##String#>, completionHandler: <#T##(Result<ProfileInfoModel, Error>) -> Void#>)
//            }
//        }
        
        
//        OpenProfileManager.shared.temporarilyProfiles.addObserver(fireNow: false) { (tempProfiles) in
//            for i in tempProfiles.keys{
//
//                if let tempProfilesValues = tempProfiles[i]{
//                    for j in tempProfilesValues{
//                        OpenProfileManager.shared.getInfoModel(email: i, user: j) { (resultProfile) in
//                            switch resultProfile{
//                            case .success(let profile):
//                                self.viewModel.viewModels.v
//                            }
//                        }
//                    }
//                }
//            }
//        }
        OpenProfileManager.shared.resetInfoModel()
        viewModel.viewModels.value = []
        Fire.shared.fetchdata(collectionref) { [weak self] (res) in
            self?.viewModel.title.value = ""
            self?.viewModel.isLoading.value = false
            self?.viewModel.isTableViewHidden.value = false
            OpenProfileManager.shared.printProfilesInfoModel()
                switch res{
                case .success(let val): self?.buildViewModels(feeds: val)
                //print(val)
                case .failure(let err):
                    print(err)
                }
//            switch res{
//            case .success(let val): self?.buildViewModels(feeds: val)
//            //print(val)
//            case .failure(let err):
//                print(err)
//            }
        }


    }
    
    
    func buildViewModels(feeds: [Feed]){
        var vm = [WrapperForUserTypes]()
       // var result:ResultProfileInfoModel!
        for feed in feeds{
            //group.enter()
            if let companypost = feed as? FeedData{
                let infoModel = ProfileInfoModel(name: companypost.user, avatarImage: NSData(data: UIImage(named: "unknown")!.pngData()!))
                let companyVM = CompanyViewModel(email:companypost.email,name:companypost.user, avatarImage: Observable<UIImage>(value: infoModel.nsDataToIMG()), message: Observable<String?>(value: companypost.message), timestamp: Observable<String>(value: companypost.timestamp))
                vm.append(WrapperForUserTypes(uuid: UUID(), viewModel: UserTypes.company(companyVM)))
                //OpenProfileManager.shared.temporarilyProfiles.value.insert("\(companypost.email)/\(companypost.user)")
               //self.viewModel.viewModels.value.append(WrapperForUserTypes(uuid: UUID(), viewModel: UserTypes.company(companyVM)))
            }
        }
        self.viewModel.viewModels.value = vm
        //OpenProfileManager.shared.
    }
    
    func cellIdentifier(for viewModel: RowViewModel) -> String {
        switch viewModel {
        case is CompanyViewModel:
            return CompanyViewCell.reuseIdentifier
        default:
            fatalError("Unexpected view model type: \(viewModel)")
        }
    }
    deinit {
        print("HomeController deinitalized")
    }
}
