//
//  ViewController.swift
//  bucovat
//
//  Created by Arnold Mitricã on 28.11.2020.
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
        viewControllers = [homevc(), UINavigationController(rootViewController: addpost()), profile()]
        //defaults.setValue(false, forKey: "isUserLoggedIn")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil{
            print("IS nil")
        }
        else{
            isUserLoggedIn = true
            print("not nil")
        }
       // let initialvc = UINavigationController(rootViewController: InitialViewController())
       // initialvc.modalPresentationStyle = .fullScreen
        if defaults.object(forKey: "isUserLoggedIn") as? Bool == false {
//            let initialvc = UINavigationController(rootViewController: InitialViewController())
//            initialvc.modalPresentationStyle = .fullScreen
//            present(initialvc, animated: true, completion: nil)
        }
        //present(initialvc, animated: true, completion: nil)
        
    }
    func homevc() -> UINavigationController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homevc = storyboard.instantiateViewController(withIdentifier: "Home")
        //homevc.title = "Home"
        let iconImage = UIImage.init(named: "home.png")
        homevc.tabBarItem = UITabBarItem(title: "Home", image: iconImage, tag: 0)
        //homevc.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem., tag: 0)
        return UINavigationController(rootViewController: homevc)
    }
    func addpost() -> UIViewController{
        let post = AddPost()
        post.title = "Add post"
        post.navigationItem.title = "Add post"
        let iconImage = UIImage.init(named: "addpost.png")
        post.tabBarItem = UITabBarItem(title: "Add post", image: iconImage, tag: 0)
        return post
    }
    
    func profile() -> UIViewController{
        let profilevc = ProfileViewController()
        profilevc.title = "Your profile"
        let iconImage = UIImage.init(named: "profile36.png")
        profilevc.tabBarItem = UITabBarItem(title: "Profile", image: iconImage, tag: 0)
        return profilevc
    }

}
