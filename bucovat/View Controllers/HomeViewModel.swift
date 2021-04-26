//
//  HomeViewModel.swift
//  bucovat
//
//  Created by Arnold Mitricã on 03.04.2021.
//

import Foundation

class HomeViewModel {
    
    let viewModels = Observable<[WrapperForUserTypes]>(value: [])
    let title = Observable<String>(value: "Loading")
    let isLoading = Observable<Bool>(value: false)
    let isTableViewHidden = Observable<Bool>(value: false)
}
