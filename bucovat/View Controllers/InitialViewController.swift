//
//  InitialViewController.swift
//  bucovat
//
//  Created by Arnold Mitricã on 21.02.2021.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import Gifu

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

class InitialViewController: UIViewController, UITextFieldDelegate{
    
    lazy var gifImageView: GIFImageView = {
        let gifview = GIFImageView()
        gifview.contentMode = .scaleAspectFit
        gifview.animate(withGIFNamed: "loading")
        //gifview.stopAnimatingGIF()
        gifview.translatesAutoresizingMaskIntoConstraints = false
        return gifview
    }()
    
    lazy var emailTextField:UITextField = {
        
        let textField = MDCOutlinedTextField()
        textField.label.text = "Your e-mail"
        textField.placeholder = "Youremail@gmail.com"
        textField.leadingAssistiveLabel.text = "E-mail associated with your account"
        textField.sizeToFit()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setOutlineColor(.purple, for: .normal)
        return textField
    }()
    lazy var nextButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.systemGray4, for: .normal)
        button.addTarget(self, action: #selector(addpaswordtextfield), for: .touchUpInside)
        //button.setTitleShadowColor(.systemBackground, for: .normal)
        Utilities.styleFilledButton(button)
        return button
    }()
    
    lazy var passTextField: MDCOutlinedTextField = {
        let textField = MDCOutlinedTextField()
        textField.label.text = "Password"
        textField.placeholder = "Your password"
        textField.leadingAssistiveLabel.text = "Password associated with your e-mail"
        textField.sizeToFit()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setOutlineColor(.purple, for: .normal)
        return textField
    }()
    
    var emailtextfieldBottomAnchor:NSLayoutConstraint!
    var buttonBottomAnchor:NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Welcome to .Tuned"
        view.backgroundColor = .systemPink
        let width = view.frame.width
        let imageView = UIImageView(image: UIImage(named: "car.jpg"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        view.addSubview(emailTextField)
        view.addSubview(nextButton)

        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        emailtextfieldBottomAnchor = emailTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -300)
        buttonBottomAnchor = nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -230)
        
        NSLayoutConstraint.activate([emailtextfieldBottomAnchor,
                                     emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     emailTextField.widthAnchor.constraint(equalToConstant: width/1.3),
                                     
                                     buttonBottomAnchor,
                                     nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     nextButton.widthAnchor.constraint(equalToConstant: width/1.3)])
                
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        // Do any additional setup after loading the view.
    }
    
    @objc func addpaswordtextfield(){
        guard let email = emailTextField.text, email != "", email.isValidEmail() else {
            print("Ceva nu e in regula la email")
            return }
        
        view.addSubview(passTextField)
        passTextField.translatesAutoresizingMaskIntoConstraints = false
        
        emailtextfieldBottomAnchor.constant = -400
        buttonBottomAnchor.constant = -240
        nextButton.setTitle("Login or register", for: .normal)
        passTextField.isSecureTextEntry = true
        
//        passTextField.trailingViewMode = .whileEditing
//        passTextField.trailingView = .init(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        
        NSLayoutConstraint.activate([

                                    passTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                    //passTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                    passTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
                                    passTextField.bottomAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 90)])
        passTextField.becomeFirstResponder()
        nextButton.addTarget(self, action: #selector(checkuser), for: .touchUpInside)
        
        view.layoutIfNeeded()
        
    }
    
    @objc func checkuser() {
        guard let email = emailTextField.text, let password = passTextField.text, email != "", email.isValidEmail() else {
            print("Ceva nu e in regula la email")
            return }
        Fire.shared.trySignIn(email, password) { (bool) in
            let defaults = UserDefaults.standard
            if bool == false{
                defaults.setValue(true, forKey: "isUserLoggedIn")
                print("something happened)")
                
                //Good bye initial view controller
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                    let sceneDelegate = windowScene.delegate as? SceneDelegate
                  else {
                    return
                  }
                defaults.setValue(true, forKey: "isUserLoggedIn")
                  sceneDelegate.window?.rootViewController = ViewController()
                
            }
            else{
                defaults.setValue(true, forKey: "isUserLoggedIn")
                print("All right")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        nextButton.heightAnchor.constraint(equalTo: emailTextField.heightAnchor, constant: -30).isActive = true
    }
    
    deinit {
        print("Initial view controller deinitialized")
    }
}
