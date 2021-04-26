//
//  CellModel.swift
//  bucovat
//
//  Created by Arnold Mitricã on 17.02.2021.
//

import Foundation
import UIKit

struct FeedData:Feed,Hashable{
    var user: String
    var email: String
    var admin: String?
    var message: String?
    var timestamp: String
}

protocol Feed{
    var user : String { get set }
    var email : String { get set }
    var timestamp:String { get set }
}
