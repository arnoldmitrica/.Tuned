//
//  ProfileDetails.swift
//  bucovat
//
//  Created by Arnold Mitricã on 17.03.2021.
//

import UIKit

@IBDesignable
final class ProfileDetailsView: UIView{
    @IBOutlet var butt: UIButton!
    @IBOutlet var containerv: UIView!
    @IBOutlet var isFollowedOutlet: UIButton!
    @IBOutlet var messageOutlet: UIButton!
    @IBOutlet var shopOutlet: UIButton!
    var viewmodel:ProfileViewModel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.configureView()
    }

    init(viewModel: ProfileViewModel) {
        self.viewmodel = viewModel
        super.init(frame: .zero)
        self.configureView()
        //super.init(frame: .zero)
        
    }
            
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    private func configureView() {
        //guard let view = self.loadViewFromNib(nibName: "ProfileDetailsView") else { return }
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
        nib.instantiate(withOwner: self, options: nil)
        addSubview(containerv)

        containerv.translatesAutoresizingMaskIntoConstraints = false
        containerv.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 1, paddingLeft: 1, paddingBottom: 1, paddingRight: 1)
        messageOutlet.addTarget(self, action: #selector(websitepressed), for: .touchUpInside)
        messageOutlet.setBordersSettings()
        isFollowedOutlet.setBordersSettings()
        shopOutlet.setBordersSettings()
        //shopOutlet.setTitle("Shop", for: .normal)
        //shopOutlet.setTitleColor(.white, for: .normal)
        
        //Checking if it is already in cache
        if !OpenProfileManager.shared.checkViewModel(email: self.viewmodel.email.value ?? ""){
            self.viewmodel.isFollowed.addObserver(fireNow: true) { (val) in
                if val == false {
                    self.isFollowedOutlet.setTitle("Follow", for: .normal)
                    //Loading or not following
                }
                else if val == true{
                    self.isFollowedOutlet.setTitle("Following", for: .normal)
                }
                else{
                    self.isFollowedOutlet.setTitle("Loading...", for: .normal)
                }
                OpenProfileManager.shared.saveViewModel(email: self.viewmodel.email.value ?? "", profile: self.viewmodel)
            }
        }
        else{
            self.viewmodel = OpenProfileManager.shared.getViewModel(email: self.viewmodel.email.value ?? "")
        }
        Fire.shared.checkIfFollows(username: "tudo8") { (res) in
            print(res)
            switch res{
            case .success(let val):
                if val == true {
                    self.isFollowedOutlet.setTitle("Following", for: .normal)
                    self.viewmodel.isFollowed.value = true
                }
                else if val == false{
                    self.isFollowedOutlet.setTitle("Follow", for: .normal)
                    self.viewmodel.isFollowed.value = false
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    @objc func websitepressed(){
        print("website pressed")
    }
    
    deinit {
        print("ProfileDetailsView deinitialized")
    }
    
}

extension UIButton {
func setBordersSettings() {
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 8.0
    self.layer.borderColor = UIColor.systemPurple.cgColor
        self.layer.masksToBounds = true
    }
}
