//
//  UserCredentialsModel.swift
//  bucovat
//
//  Created by Arnold Mitricã on 17.02.2021.
//

import Foundation
import UIKit

struct UserCredentials {
    var name: String?
    let topic = "Add a topic"
    let obsv = "Make an observation"
    var companies:[String]?
    init(name:String, companies:[String]) {
        self.name = name
        self.companies = companies
    }
}
