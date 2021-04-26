//
//  AddPost.swift
//  bucovat
//
//  Created by Arnold Mitricã on 09.02.2021.
//

import UIKit
import BSImagePicker
import Photos

class AddPost: UIViewController, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    private var textview: UITextView!
    private let cancelButton: UIBarButtonItem! = nil
    private var postbutton = AddNewPostButton()
    private var collectionView: UICollectionView!
    private var photoSliderView = PhotoSliderView()
    private let identifier: String = "imageidentifier"
    private var selectedImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Add post"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissview))
        textviewinit()
        imagesviewinit()
        
    }
    
    @objc func dismissview(){
        self.dismiss(animated: true) {
            self.textview.resignFirstResponder()
            print("Dismiss addpost")
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    @objc func addimages(){
        
    }
    deinit {
        print("Deinit said dismissed")
    }
    
    func textviewinit(){
        postbutton.button.setTitle("Post", for: .normal)
        postbutton.button.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title1)
        postbutton.button.titleLabel?.adjustsFontForContentSizeCategory = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: postbutton)
        //textview = UITextView()
        textview = UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
    //    textview.snapshotView(afterScreenUpdates: false)

        self.view.addSubview(textview)
        photoSliderView = PhotoSliderView()
        self.view.addSubview(photoSliderView)
        photoSliderView.translatesAutoresizingMaskIntoConstraints = false
        photoSliderView.backgroundColor = .systemRed
        photoSliderView.anchor(top: textview.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 5, paddingBottom: 20, paddingRight: 5)
        photoSliderView.heightAnchor.constraint(greaterThanOrEqualToConstant: 300).isActive = true
        Utilities.styleShadow(textview)
        textview.text = "Enter your post here"
        textview.textColor = .orange
        textview.font = .systemFont(ofSize: 26)
        //textview.becomeFirstResponder()
        
        //constraints
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        textview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        textview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        textview.bottomAnchor.constraint(equalTo: photoSliderView.topAnchor, constant: -20).isActive = true
        textview.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        //textview.backgroundColor = .systemBlue
        textview.delegate = self

        textview.addKeyboardToolBar(leftButtons: [.camera], rightButtons: [], toolBarDelegate: self)
        //textview.snapshotView(afterScreenUpdates: true)
        
        postbutton.button.addTarget(self, action: #selector(sendmessagetofirebase), for: .touchUpInside)
    }
    

    
    func textViewDidChange(_ textView: UITextView) {
        if textView.contentSize.height >= 160.0
        {
            textView.isScrollEnabled = true
        }
        else
        {
            let size = CGSize(width: view.frame.width, height: .infinity)
            let approxSize = textView.sizeThatFits(size)

            textView.constraints.forEach {(constraint) in

                if constraint.firstAttribute == .height{
                    constraint.constant = approxSize.height
                }
            }
            textView.isScrollEnabled = false
        }
    }


    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textview did begin editing")
       // print(textView.attributedText)

        textView.backgroundColor = UIColor.lightGray

        if (textView.text == "Enter your post here")
        {
            textView.text = ""
            textView.textColor = .black
        }

    }

//    override func updateViewConstraints() {
//        print("update view constraints")
//        super.updateViewConstraints()
//    }

    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = UIColor.white

        if (textView.text == "")
        {
            textView.text = "Enter your post here"
            textView.textColor = .lightGray
        }
    }
    

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.endEditing(true)
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func addphotosliderview(){
        
    }
    
    func imagesviewinit(){
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.itemSize = CGSize(width: 300, height: 300)
        
    }
             
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return selectedImages.count
        }
         
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let data: UIImage = selectedImages[indexPath.item]
            let cell: ImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ImageCell
            cell.image.image = data
            return cell
        }
    
    @objc func sendmessagetofirebase(){
        guard let message = textview.text, textview.text != "", textview.text != "Enter your post here" else { return }
        print("message is \(message)")
        //let email = 
        Fire.shared.postData(message: message) { [weak self] (result) in
            if result == true{
                self?.dismiss(animated: true, completion: nil)
                self?.tabBarController?.selectedIndex = 0
            }
        }
        
    }
    
}

extension AddPost: KeyboardToolbarDelegate {
    //let group = DispatchGroup()
    func keyboardToolbar(button: UIBarButtonItem, type: KeyboardToolbarButton, isInputAccessoryViewOf textView: UITextView) {
        if type == .camera{
            //button.action = #selector(selectImages(sender:))
            print("Tapped button type: \(type) | \(textView)")
            let imagePicker = ImagePickerController()
            presentImagePicker(imagePicker, select: { (asset) in
            }, deselect: { (asset) in
                 
            }, cancel: { (assets) in
                 
            }, finish: { (assets) in
                 
                let options: PHImageRequestOptions = PHImageRequestOptions()
                options.deliveryMode = .fastFormat
                let group = DispatchGroup()
                self.selectedImages = []
                self.photoSliderView.scrollView.reloadInputViews()
                    for asset in assets {
                        group.enter()
                            PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options) { (image, info) in
                                self.selectedImages.append(image!)
                                if (self.selectedImages.count != 0){
                                    print("\(self.selectedImages.count) \n")
                                }
                                group.leave()
                            }
                    }
                group.notify(queue: DispatchQueue.main) {
                    print("Done")
                    self.photoSliderView.configure(with: self.selectedImages)
                }
            })
        }
    }

}
