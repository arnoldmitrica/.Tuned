//
//  ProfileViewController.swift
//  bucovat
//
//  Created by Arnold Mitricã on 23.02.2021 from yt stephan - appstuff
//

import UIKit
import Firebase
import FirebaseFirestore
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import MaterialComponents.MaterialButtons

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    var data = [FeedData]()
    var flagDataIsDownloaded = false
    lazy var segmentedfeedview: UITableView = {
        let segmentedfeedview = UITableView()
        segmentedfeedview.backgroundColor = .systemGray
        
        return segmentedfeedview
    }()
    
    lazy var undersegmentedview: UIView = {
        let undersegmentedview = UIView()
        undersegmentedview.isOpaque = false

        return undersegmentedview
        
    }()
    
    lazy var backgroundimageview: UIImageView = {
        let imageview = UIImageView(image: UIImage(named: "profileimage.jpeg"))
        imageview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageview)
        imageview.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        return imageview
    }()
    
    lazy var profileview: UIView = {
        let profile = UIView()
        //let imageView = UIImageView(image: UIImage(named: "profileimage.jpeg"))
        //imageView.sizeToFit()
        profile.isOpaque = false
        //profile.addSubview(imageView)
        //imageView.anchor(top: profile.topAnchor, left: profile.leftAnchor, bottom: profile.bottomAnchor, right: profile.rightAnchor)
        let phonenumber = MDCOutlinedTextField()
        phonenumber.label.text = "Phone number"
        phonenumber.placeholder = "Your phone number"
        phonenumber.sizeToFit()
        phonenumber.leadingAssistiveLabel.text = "Your phone number associated with your e-mail"
        phonenumber.setOutlineColor(.purple, for: .normal)
        
        let username = MDCOutlinedTextField()
        username.label.text = "Username"
        username.placeholder = "Your Username"
        username.sizeToFit()
        username.leadingAssistiveLabel.text = "Your username associated with your e-mail"
        username.setOutlineColor(.purple, for: .normal)
        
        let savebutton = MDCButton()
        savebutton.accessibilityLabel = "Save"
        
        profile.addSubview(phonenumber)
        phonenumber.translatesAutoresizingMaskIntoConstraints = false
        
        profile.addSubview(username)
        username.translatesAutoresizingMaskIntoConstraints = false
        
        profile.addSubview(savebutton)
        savebutton.translatesAutoresizingMaskIntoConstraints = false
        
        savebutton.accessibilityLabel = "Create"
        savebutton.setTitle("Save", for: .normal)
        savebutton.backgroundColor = .purple
        savebutton.setImage(UIImage(named: "postadd48.png"), for: .highlighted)
        //savebutton.
      //  savebutton.im
        
        NSLayoutConstraint.activate([phonenumber.topAnchor.constraint(equalTo: profile.topAnchor, constant: 20),
                                     phonenumber.centerXAnchor.constraint(equalTo: profile.centerXAnchor),
                                     phonenumber.widthAnchor.constraint(equalToConstant: 200),
                                     phonenumber.heightAnchor.constraint(equalToConstant: 60),
                                     
                                     username.topAnchor.constraint(equalTo: profile.topAnchor, constant: 130),
                                     username.centerXAnchor.constraint(equalTo: profile.centerXAnchor),
                                     username.widthAnchor.constraint(equalToConstant: 200),
                                     username.heightAnchor.constraint(equalToConstant: 60),
        
        savebutton.topAnchor.constraint(equalTo: profile.topAnchor, constant: 230),
        savebutton.centerXAnchor.constraint(equalTo: profile.centerXAnchor),
        savebutton.widthAnchor.constraint(equalToConstant: 200),
        savebutton.heightAnchor.constraint(equalToConstant: 60)])
        return profile
    }()
    
    lazy var segmentedview: UISegmentedControl = {
        let segmentedview = UISegmentedControl(items: ["Posts", "Personal data"])
        segmentedview.backgroundColor = .clear
        segmentedview.isOpaque = false
        segmentedview.tintColor = .clear
        
        
        segmentedview.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "AvenirNextCondensed-Medium", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.purple], for: .normal)
        segmentedview.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "AvenirNextCondensed-Medium", size: 24)!, NSAttributedString.Key.foregroundColor: UIColor.purple], for: .selected)
        //segmentedview.addTarget(self, action: #selector(handlesegmentchange(_:)), for: .touchUpInside)
        return segmentedview
    }()
    
    var segmentwidthanchor: NSLayoutConstraint!
    var segmentcenterxanchor: NSLayoutConstraint!
    let segmentindicator: UIView = {
        
        let v = UIView()
        
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.purple
        
        return v
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.isOpaque = false
        //view.backgroundColor = .mainBlue
        
        view.addSubview(profileImageView)
        //profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 20,
                                paddingLeft: 20, width: 120, height: 120)
        profileImageView.layer.cornerRadius = 120 / 2
        
        view.addSubview(messageButton)
        messageButton.anchor(top: view.topAnchor, right: view.rightAnchor,
                             paddingTop: 40, paddingRight: 10, width: 32, height: 32)
        messageButton.tintColor = .white
        view.addSubview(followButton)
        followButton.anchor(top: messageButton.bottomAnchor, right: view.rightAnchor,
                             paddingTop: 15, paddingRight: 10, width: 32, height: 32)
        
        view.addSubview(nameLabel)
        //nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.anchor(top: view.topAnchor,left: view.leftAnchor, paddingTop: 60, paddingLeft: 150)
        
        view.addSubview(emailLabel)
        //emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailLabel.anchor(top: nameLabel.bottomAnchor, left: nameLabel.leftAnchor, paddingTop: 4)
        
        return view
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "stock.jpeg")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    let messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "quickmessage36white.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleMessageUser), for: .touchUpInside)
        return button
    }()
    
    let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "personaddwhite36.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleFollowUser), for: .touchUpInside)
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = Auth.auth().currentUser?.email ?? "Anonymously"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .white
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = Auth.auth().currentUser?.email ?? "No email"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let widthwindow = view.bounds.width
        view.backgroundColor = .white
        view.addSubview(backgroundimageview)
        backgroundimageview.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor,
                             right: view.rightAnchor, height: 150)
        view.addSubview(segmentedview)
        segmentedview.anchor(top: containerView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 5, height: 40)
        segmentedview.addTarget(self, action: #selector(handlesegmentchange(_:)), for: .valueChanged)
        view.addSubview(undersegmentedview)
        undersegmentedview.anchor(top: segmentedview.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        segmentedfeedview.delegate = self
        segmentedfeedview.dataSource = self
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        view.addSubview(segmentindicator)
        segmentindicator.translatesAutoresizingMaskIntoConstraints = false
        
        segmentindicator.topAnchor.constraint(equalTo: segmentedview.bottomAnchor, constant: 3).isActive = true
        segmentindicator.heightAnchor.constraint(equalToConstant: 2).isActive = true
        segmentwidthanchor = segmentindicator.widthAnchor.constraint(equalToConstant: CGFloat(15 + segmentedview.titleForSegment(at: 0)!.count * 8))
        segmentwidthanchor.isActive = true
        
        segmentcenterxanchor = segmentindicator.leftAnchor.constraint(equalTo: segmentedview.leftAnchor, constant: CGFloat(3.0 + Double((segmentedview.selectedSegmentIndex - 1) * (Int(widthwindow) / segmentedview.numberOfSegments))))
        
        segmentcenterxanchor.isActive = true

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Selectors
    
    @objc func handleMessageUser() {
        print("Message user here..")
    }
    
    @objc func handleFollowUser() {
        print("Follow user here..")
    }
    
    @objc func handlesegmentchange(_ segmentedControl: UISegmentedControl){
        print("segmentedControl.selectedSegmentIndex \(segmentedControl.selectedSegmentIndex)")
        let widthwindow = view.bounds.width
        
        
        let numberOfSegments = CGFloat(segmentedControl.numberOfSegments)
        let selectedIndex = CGFloat(segmentedControl.selectedSegmentIndex)
        
        segmentindicator.topAnchor.constraint(equalTo: segmentedview.bottomAnchor, constant: 3).isActive = true
        segmentindicator.heightAnchor.constraint(equalToConstant: 2).isActive = true
        segmentwidthanchor.constant = widthwindow/numberOfSegments
        
        
        segmentcenterxanchor.isActive = false
        
        segmentcenterxanchor = segmentindicator.leftAnchor.constraint(equalTo: segmentedview.leftAnchor, constant: CGFloat(3.0 + Double((selectedIndex) * (CGFloat(widthwindow) / numberOfSegments))))
        
        segmentcenterxanchor.isActive = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            self.segmentindicator.transform = CGAffineTransform(scaleX: 0.4, y: 1)
        }) { (finish) in
            UIView.animate(withDuration: 0.4, animations: {
                self.segmentindicator.transform = CGAffineTransform.identity
            })
        }
        
        switch segmentedControl.selectedSegmentIndex {
        case 0: print("case 0")
            
            undersegmentedview.addSubview(segmentedfeedview)
            segmentedfeedview.backgroundColor = .gray
            segmentedfeedview.anchor(top: undersegmentedview.topAnchor, left: undersegmentedview.leftAnchor, bottom: undersegmentedview.bottomAnchor, right: undersegmentedview.rightAnchor)
            self.segmentedfeedview.register(CustomMessageCell.self, forCellReuseIdentifier: "custom2")
            fetchdata()
        case 1: print("case 1")
            segmentedfeedview.removeFromSuperview()
            undersegmentedview.addSubview(profileview)
            profileview.anchor(top: undersegmentedview.topAnchor, left: undersegmentedview.leftAnchor, bottom: undersegmentedview.bottomAnchor, right: undersegmentedview.rightAnchor)
            
            
            //undersegmentedview.backgroundColor = .purple
        default:
            print("default")
        }
    }
    func fetchdata(){
        if self.flagDataIsDownloaded == false{
            Fire.shared.fetchdata(Firestore.firestore().collection("users/tudo8@gmail.com/posts")) { (result) in
                switch result {
                
                case .success(let datatofetch):
                    print("Datatofetched from profileview controller not nil")
                    DispatchQueue.main.async {
                        self.data = datatofetch
                        self.flagDataIsDownloaded = true
                        self.segmentedfeedview.reloadData()
                    }
                case .failure(let err):
                    print("Error occured: \(err.localizedDescription)")
                }

            }
        }
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom2", for: indexPath) as! CustomMessageCell
        
//        let profile = OpenProfileManager.shared.getInfoModel(email: data[indexPath.row].email, user: data[indexPath.row].user)
//        cell.coimage = profile.nsDataToIMG()
//        cell.message = data[indexPath.row].message
//        cell.admin = data[indexPath.row].admin
//        cell.company = data[indexPath.row].user
//        cell.timestamp = data[indexPath.row].timestamp
//        OpenProfileManager.shared.getInfoModel(email: data[indexPath.row].email, user: data[indexPath.row].user) { [weak self] (resultProfile) in
//            switch resultProfile{
//            case .success(let profile):
//                cell.coimage = profile.nsDataToIMG()
//                cell.message = self?.data[indexPath.row].message
//                cell.admin = self?.data[indexPath.row].admin
//                cell.company = self?.data[indexPath.row].user
//                cell.timestamp = self?.data[indexPath.row].timestamp
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
        cell.layoutSubviews()
        return cell
    }
}


extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let mainBlue = UIColor.rgb(red: 0, green: 150, blue: 255)
    
    @nonobjc class var TSPrimary: UIColor {
        
        return UIColor(red:0.85, green:0.11, blue:0.38, alpha:1.0)
        
    }
}



