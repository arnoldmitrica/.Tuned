//
//  AddPost.swift
//  bucovat
//
//  Created by Arnold Mitricã on 09.02.2021.
//

import UIKit

class AddPost: UIViewController, UITextViewDelegate {
    var textview: UITextView!
    let cancelButton: UIBarButtonItem! = nil
    var postbutton = AddNewPostButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissview))
        print("Post button bounds \(postbutton.bounds)")
        textviewinit()
        
    }
    
    @objc func dismissview(){
        self.dismiss(animated: true) {
            print("Dismiss addpost")
        }
    }
    deinit {
        print("Deinit said dismissed")
    }
    
    func textviewinit(){
        postbutton.button.setTitle("Post", for: .normal)
        postbutton.button.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title1)
        postbutton.button.titleLabel?.adjustsFontForContentSizeCategory = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: postbutton)
        textview = UITextView()
        //textview = UITextView(frame: CGRect(x: 0, y: 150, width: 150, height: 150), textContainer: NSTextContainer(size: CGSize(width: 100, height: 100)))
        textview.text = "Mesaj text viewMesaj text view Mesaj text view Mesaj text view Mesaj text view Mesaj text view Mesaj text view Mesaj text view Mesaj text view Mesaj text view Mesaj text view Mesaj text view"
        self.view.addSubview(textview)
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        textview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        textview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        textview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

}
