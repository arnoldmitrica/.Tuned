//
//  UserTypesandWrapper.swift
//  bucovat
//
//  Created by Arnold Mitricã on 11.04.2021.
//

import Foundation


enum UserTypes {
    case company(CompanyViewModel)
}

struct WrapperForUserTypes : Hashable {
    static func == (lhs: WrapperForUserTypes, rhs: WrapperForUserTypes) -> Bool {
        lhs.uuid == rhs.uuid
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    let uuid: UUID
    let viewModel: UserTypes
}
