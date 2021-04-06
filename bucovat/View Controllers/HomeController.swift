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
            Fire.shared.fetchdata(collectionref) { [weak self] (res) in
                self?.viewModel.title.value = ""
                self?.viewModel.isLoading.value = false
                self?.viewModel.isTableViewHidden.value = false
                switch res{
                case .success(let val): self?.buildViewModels(feeds: val)
                    //print(val)
                case .failure(let err):
                    print(err)
                }
            }

        }

    }
    
    
    func buildViewModels(feeds: [Feed]){
        var vm = [RowViewModel]()
        //print(feeds)
        for feed in feeds{
            if let companypost = feed as? CompanyData{
                let companyVM = CompanyViewModel(email:companypost.email!,name:companypost.name, avatarImage: Observable<UIImage>(value: companypost.coimage ?? UIImage(named: "Enel")!), postImage: Observable<UIImage?>(value: UIImage(named:"profileimage2")), message: Observable<String?>(value: companypost.message), timestamp: Observable<String>(value: companypost.timestamp))
                    vm.append(companyVM)
            }
        }
        print(vm)
        self.viewModel.viewModels.value = vm
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
