//
//  CellModel.swift
//  bucovat
//
//  Created by Arnold Mitricã on 17.02.2021.
//

import Foundation
import UIKit

struct CompanyData:Feed{
    var name: String
    var coimage: UIImage?
    var admin: String?
    var message: String?
    var timestamp: String
    var email:String?
}

protocol Feed{
    var name: String { get set }
    var timestamp:String { get set }
}
