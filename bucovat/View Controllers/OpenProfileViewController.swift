//
//  OpenProfileViewController.swift
//  bucovat
//
//  Created by Arnold Mitricã on 17.03.2021.
//

import UIKit
import FirebaseUI

class OpenProfileViewController: UIViewController {
        
    var viewModel: ProfileViewModel {
        return controller.viewModel
    }
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var followers: UILabel!
    @IBOutlet var following: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var posts: UILabel!
    @IBOutlet var stackLabels: UIStackView!
    
    lazy var controller: OpenProfileController = {
        return OpenProfileController()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initBinding()
        controller.start()
        // Do any additional setup after loading the view.
    }
    

    func initView(){
        title = viewModel.name.value
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    func initBinding(){
        viewModel.profileView.addObserver(fireNow: false) { [weak self] (profile) in
            guard let strongSelf = self else { return }
            strongSelf.followers.text = String(profile?.followers ?? 0)
            strongSelf.following.text = String(profile?.following ?? 0)
            strongSelf.posts.text = String(profile?.posts ?? 0)
        }
        let storageRef = StorageReference().child("enel.png")
        imageView.sd_setImage(with: storageRef, placeholderImage: nil)
        
        let profileButtons = ProfileDetailsView(viewModel: viewModel)
        self.scrollView.addSubview(profileButtons)
        profileButtons.translatesAutoresizingMaskIntoConstraints = false

        profileButtons.topAnchor.constraint(equalTo: stackLabels.bottomAnchor).isActive = true
        profileButtons.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        profileButtons.rightAnchor.constraint(equalTo: self.stackLabels.rightAnchor).isActive = true
        profileButtons.heightAnchor.constraint(greaterThanOrEqualTo: profileButtons.containerv.heightAnchor).isActive = true
        
    }
    
    @objc func didPullToRefresh(){
        controller.fetchData { (finished) in
            if finished {
                DispatchQueue.main.async {
                    self.scrollView.refreshControl?.endRefreshing()
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    deinit {
        print("Openprofileviewcontroller deinitialized")
    }
}
