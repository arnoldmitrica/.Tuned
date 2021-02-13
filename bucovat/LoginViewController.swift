//
//  LoginViewController.swift
//  bucovat
//
//  Created by Arnold Mitricã on 01.01.2021.
//

import UIKit
import Firebase
import SideMenu


protocol SendCredentials: AnyObject{
    func sendcredentials(menuItems: [String]?)
}

extension String {
    func toAttributed(alignment: NSTextAlignment) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return toAttributes(attributes: [.paragraphStyle: paragraphStyle])
    }

    func toAttributes(attributes: [NSAttributedString.Key : Any]? = nil) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: attributes)
    }
}


class LoginViewController: UIViewController{
    
    init(delegatee: SendCredentials){
        self.delegate = delegatee
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var userName: UITextField!
    var passWord: UITextField!
    var passWord2: UITextField!
    var email: UITextField!
    var phone: UITextField!
    var signUpButton: UIButton!
    var loginButton:UIButton!
    var credentials:[String]?
    weak var delegate: SendCredentials!
        
    var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        //v.backgroundColor = .cyan
        return v
    }()
    
    var loginStackedView : UIStackView = {
        
        let v = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .vertical
        v.alignment = .center
        v.distribution = .equalCentering
        //v.spacing = 10.0
        return v
    }()
    lazy var blockView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var itemViews : [UIView] = []
    
    var activeTextField : UITextField? = nil
    //var scrollView = UIScrollView()
    
    override func viewDidLoad() {
        //let blockwidth = view.bounds.width/2.3
        super.viewDidLoad()
        
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
          
              // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //view.translatesAutoresizingMaskIntoConstraints = false
        configureViewController()
        //insertitemviews()
        layoutUI()

        // Do any additional setup after loading the view.
    }
    func createUser(name: String, password: String, email: String, phonee: String){
        Auth.auth().createUser(withEmail: email, password: password){ [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let err = error {
                print("There was an error", err)
            }
            else{
                let userData = ["name": name, "email ": email, "phone": phonee]
                strongSelf.credentials = ["Hi, \(name)", "Search for companies", "Make an observation"]
                let ref = Database.database().reference()
                ref.child("users").child(authResult!.user.uid).setValue(userData)
                print("Aici avem credentials:\(String(describing: strongSelf.credentials))")
                if let _ = strongSelf.credentials{
                    strongSelf.delegate.sendcredentials(menuItems: strongSelf.credentials!)
                }
            }
            strongSelf.dismissVC()
        }
    }
    
    func logUser(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password){ [weak self] user, error in
            guard let strongSelf = self else { return }
            if let err = error{
                print("error at sign in, \(String(describing: err))")
            }
            else{
                var name = "you"
                let ref = Database.database().reference()
                if let letuser = user {
                    ref.child("users").child(letuser.user.uid).child("name").observeSingleEvent(of: .value) { (snapshot) in
                        if let letname = snapshot.value as? String{
                            name = letname
                        }
                    }
                    ref.child("users").child(letuser.user.uid).child("type").observeSingleEvent(of: .value) { (snapshot) in
                        switch snapshot.value as! String {
                        case "company":
                            let menuItems = ["Hi, company!", "Add a topic", "See followers", "See your posts"]
                            strongSelf.delegate.sendcredentials(menuItems: menuItems)
                        case "admin":
                            let menuItems = ["Hi, admin \(name)!", "Add companies", "Add posts"]
                            strongSelf.delegate.sendcredentials(menuItems: menuItems)
                        default:
                            let menuItems = ["Hi, \(name)!", "Search for companies", "Make an observation"]
                            strongSelf.delegate.sendcredentials(menuItems: menuItems)
                        }
                    }
                    strongSelf.dismissVC()
                }
                print("2acesta este serve timestamp \(ServerValue.timestamp())")
                //ref.child("posts").child("1").setValue(ServerValue.timestamp(), forKey: "timestamp")
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else {
              // if keyboard size is not available for some reason, dont do anything
              return
            }

            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            
        
        // reset back the content inset to zero after keyboard is gone
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func insertitemviews() {
        let blockwidth = view.bounds.width / 2
        print("blocwidth \(blockwidth)")
        
        userName = {
            let userName = UITextField(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: blockwidth, height: 55)))
            userName.translatesAutoresizingMaskIntoConstraints = false
            userName.textAlignment = .center
            userName.attributedPlaceholder = "Username, only letters and/or digits".toAttributed(alignment: .center)
            
            Utilities.styleTextField(userName)
            //loginStackedView.addArrangedSubview(userName)
            
            return userName
        }()
        passWord = {
            let passWord = UITextField(frame: CGRect(x: 0, y: 0, width: blockwidth, height: 55))
            passWord.translatesAutoresizingMaskIntoConstraints = false
            passWord.attributedPlaceholder = "Password: minimum 6 characters".toAttributed(alignment: .center)
            Utilities.styleTextField(passWord)
            //loginStackedView.addArrangedSubview(passWord)
            
            return passWord
        }()
        passWord2 = {
            let passWord2 = UITextField(frame: CGRect(x: 0, y: 0, width: blockwidth, height: 55))
            passWord2.translatesAutoresizingMaskIntoConstraints = false
            passWord2.attributedPlaceholder = "Password must match the other one".toAttributed(alignment: .center)
            Utilities.styleTextField(passWord2)
            //loginStackedView.addArrangedSubview(passWord2)
            
            return passWord2
        }()
        
        email = {
            let email = UITextField(frame: CGRect(x: 0, y: 0, width: blockwidth, height: 55))
            email.translatesAutoresizingMaskIntoConstraints = false
            email.attributedPlaceholder = "Your email".toAttributed(alignment: .center)
            Utilities.styleTextField(email)
            //loginStackedView.addArrangedSubview(email)
            
            return email
        }()
        
        phone = {
            let phone = UITextField(frame: CGRect(x: 0, y: 0, width: blockwidth, height: 55))
            phone.translatesAutoresizingMaskIntoConstraints = false
            phone.attributedPlaceholder = "Optional but useful to login next time".toAttributed(alignment: .center)
            Utilities.styleTextField(phone)
            //loginStackedView.addArrangedSubview(phone)
            
            return phone
        }()
        
        signUpButton = {
            let signUpButton = UIButton()
            signUpButton.translatesAutoresizingMaskIntoConstraints = false
            signUpButton.setTitle("Sign UP", for: .normal)
            signUpButton.setTitleColor(.systemRed, for: .normal)
            Utilities.styleHollowButton(signUpButton)
            signUpButton.addTarget(self, action: #selector(signup), for: .touchUpInside)
            //loginStackedView.addSubview(signUpButton)
            return signUpButton
        }()
        let loginButton: UIButton = {
            let loginButton = UIButton()
            loginButton.translatesAutoresizingMaskIntoConstraints = false
            loginButton.setTitle("Login", for: .normal)
            loginButton.setTitleColor(.systemRed, for: .normal)
            loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)

            Utilities.styleFilledButton(loginButton)
            return loginButton
        }()

        loginStackedView.translatesAutoresizingMaskIntoConstraints = false
        loginStackedView.addArrangedSubview(userName)
        loginStackedView.addArrangedSubview(passWord)
        loginStackedView.addArrangedSubview(passWord2)
        loginStackedView.addArrangedSubview(email)
        loginStackedView.addArrangedSubview(phone)
        loginStackedView.addArrangedSubview(signUpButton)
        loginStackedView.addArrangedSubview(loginButton)
//
        loginStackedView.axis = .vertical
        loginStackedView.alignment = .center
        loginStackedView.distribution = .equalSpacing
    
        //userName.isUserInteractionEnabled = true
        //userName.topAnchor.constraint(equalTo: loginStackedView.topAnchor).isActive = true
//        loginStackedView.addArrangedSubview(userName)
        userName.heightAnchor.constraint(equalToConstant: 55).isActive = true
        userName.bottomAnchor.constraint(equalTo: passWord.topAnchor, constant: -10).isActive = true
        userName.widthAnchor.constraint(equalToConstant: blockwidth).isActive = true
        
//        loginStackedView.addArrangedSubview(passWord)
        passWord.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 10).isActive = true
        passWord.heightAnchor.constraint(equalToConstant: 55).isActive = true
        passWord.bottomAnchor.constraint(equalTo: passWord2.topAnchor, constant: -10).isActive = true
        passWord.widthAnchor.constraint(equalToConstant: blockwidth).isActive = true

//        loginStackedView.addArrangedSubview(passWord2)
        passWord2.topAnchor.constraint(equalTo: passWord.bottomAnchor, constant: 10).isActive = true
        passWord2.heightAnchor.constraint(equalToConstant: 55).isActive = true
        passWord2.bottomAnchor.constraint(equalTo: email.topAnchor, constant: -10).isActive = true
        passWord2.widthAnchor.constraint(equalToConstant: blockwidth).isActive = true
//
 //       loginStackedView.addArrangedSubview(email)
        email.topAnchor.constraint(equalTo: passWord2.bottomAnchor, constant: 10).isActive = true
        email.heightAnchor.constraint(equalToConstant: 55).isActive = true
        email.bottomAnchor.constraint(equalTo: phone.topAnchor, constant: -10).isActive = true
        email.widthAnchor.constraint(equalToConstant: blockwidth).isActive = true
//
//        loginStackedView.addArrangedSubview(phone)
        phone.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 10).isActive = true
        phone.heightAnchor.constraint(equalToConstant: 55).isActive = true
        phone.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -10).isActive = true
        phone.widthAnchor.constraint(equalToConstant: blockwidth).isActive = true
//
//        loginStackedView.addArrangedSubview(signUpButton)
        signUpButton.topAnchor.constraint(equalTo: phone.bottomAnchor, constant: 10).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        signUpButton.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -10).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant: blockwidth + 44).isActive = true
//
 //       loginStackedView.addArrangedSubview(loginButton)
        loginButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 10).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: blockwidth).isActive = true

        
    }
    @objc func signup(sender: UIButton){
        createUser(name: userName.text!, password: passWord.text!, email: email.text!, phonee: phone.text!)
    }
    @objc func login(sender: UIButton){
        logUser(email: email.text!, password: passWord.text!)
    }
    
    func layoutUI() {
        //view.backgroundColor = .systemYellow

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        //scrollView.backgroundColor = .systemPink
        
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8.0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8.0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8.0).isActive = true
        scrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true

        scrollView.addSubview(blockView)
        //blockView.backgroundColor = .systemGreen
        blockView.translatesAutoresizingMaskIntoConstraints = false
        blockView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        blockView.widthAnchor.constraint(greaterThanOrEqualToConstant: view.bounds.width/2).isActive = true
        blockView.leadingAnchor.constraint(greaterThanOrEqualTo: scrollView.leadingAnchor, constant: 10).isActive = true
        blockView.topAnchor.constraint(greaterThanOrEqualTo: scrollView.topAnchor, constant: 8.0).isActive = true
        blockView.trailingAnchor.constraint(greaterThanOrEqualTo: scrollView.trailingAnchor, constant: -10).isActive = true
        blockView.bottomAnchor.constraint(greaterThanOrEqualTo: scrollView.bottomAnchor, constant: -10).isActive = true

        blockView.addSubview(loginStackedView)
        loginStackedView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                    loginStackedView.topAnchor.constraint(equalTo: blockView.topAnchor, constant: 0.0),
                    loginStackedView.bottomAnchor.constraint(equalTo: blockView.bottomAnchor, constant: 0.0),
                    loginStackedView.leadingAnchor.constraint(equalTo: blockView.leadingAnchor, constant: 0.0),
                    loginStackedView.trailingAnchor.constraint(equalTo: blockView.trailingAnchor, constant: 0.0),

                    loginStackedView.widthAnchor.constraint(equalTo: blockView.widthAnchor, constant: 0.0),

                    ])


        loginStackedView.translatesAutoresizingMaskIntoConstraints = false
        loginStackedView.axis = .vertical
        loginStackedView.alignment = .center
        loginStackedView.distribution = .equalSpacing

          insertitemviews()

    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }

}

extension LoginViewController : UITextFieldDelegate {
  // when user select a textfield, this method will be called
  func textFieldDidBeginEditing(_ textField: UITextField) {
    // set the activeTextField to the selected textfield
    self.activeTextField = textField
  }
    
  // when user click 'done' or dismiss the keyboard
  func textFieldDidEndEditing(_ textField: UITextField) {
    self.activeTextField = nil
  }
}

