//
//  ViewController.swift
//  bucovat
//
//  Created by Arnold Mitricã on 28.12.2020.
//

import UIKit
import SideMenu
import Firebase

class ViewController: UITabBarController {
    
    private let defaults = UserDefaults.standard
    var isUserLoggedIn = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View will appear in VC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [homevc()]

    }
    func homevc() -> UITableViewController{
        let homevc = HomeVC()
        homevc.title = "Home"
        homevc.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 0)
        return homevc
    }
//    func addpost() -> UIViewController{
//        let post = AddPost()
//        post.title = "Add post"
//        post.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
//        return post
//    }

}
