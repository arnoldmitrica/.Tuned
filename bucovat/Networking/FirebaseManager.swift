//
//  FirebaseManager.swift
//  bucovat
//
//  Created by Arnold Mitricã on 17.02.2021.
//

import Foundation
import UIKit
import Firebase

let STORAGE_IMAGE_DIR:String = "images/"
let STORAGE_DOCUMENT_DIR:String = "documents/"
enum StorageFileType : String{
    case JPG, PNG, PDF
}

//struct StorageFileMetadata {
//    var filename:String
//    var fullpath:String
//    var directory:String
//    var contentType:String
//    var type:StorageFileType
//    var size:Int
//    var url:URL?
//    var description:String?
//}

// getting an image requires restriction on anticipated image file size
let IMG_SIZE_MAX:Int64 = 15  // megabytes

class Fire {
    static let shared = Fire()
    
    let ref = Firestore.firestore()
    
    var myUID:String?
    var userEmail:String?// if you are logged in, if not, == nil
    
    fileprivate init() {
        // setup USER listener
        Auth.auth().addStateDidChangeListener { auth, listenerUser in
            if let user = listenerUser {
                print("SIGN IN: \(user.email ?? user.uid)")
                self.myUID = user.uid
                self.userEmail = user.email
            } else {
                self.myUID = nil
                print("SIGN OUT: no user")
            }
        }
        if let email = Auth.auth().currentUser?.email {
            self.userEmail = email
            if let uid = Auth.auth().currentUser?.uid{
                self.myUID = uid
            }
        }
        print("Fileprivate init + \(String(describing: self.userEmail))")
    }
    func postData(message:String, completionHandler: @escaping (Bool) -> ()){
        if let email = self.userEmail {
            print("postdata + \(email)")
            var docref: DocumentReference? = nil
            ref.document("users/\(email)").setData(["lastPost" : Firebase.FieldValue.serverTimestamp()], merge: true)
            docref = ref.collection("users/\(email)/posts").addDocument(data:["message" : message, "timestamp": Firebase.FieldValue.serverTimestamp(), "email":email, "postcreator":"nobodyfornow", "firma": "enel" ]){ (error) in
                if let err = error {
                    print("Error adding document: \(err)")
                    completionHandler(false)
                } else {
                    print("Document added with ID: \(docref!.documentID)")
                    completionHandler(true)
                }
            }
        }
    }

    func newUser(userEmail: String) {
        ref.document("users/\(userEmail)/followers/1").setData([userEmail: true])
        ref.document("users/\(userEmail)").setData(["createdAt":Firebase.FieldValue.serverTimestamp()])
        print("Fire shared set new user data")
    }
    
    func checkuser(userEmail: String) {
        
    }
    
    func trySignIn(_ userEmail: String, _ password: String, completionHandler: @escaping (Bool) -> ()) {
        Auth.auth().signIn(withEmail: userEmail, password: password) { (result, err) in
            if let error = err{
                if error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                    print("Invalid username or passowrd")
                    
                }
                else{
                    print("error at sign in, \(String(describing: error.localizedDescription))")
                }
                completionHandler(false)
            }
            else{
                completionHandler(true)
            }
        }
        
    }
    
    func createUser(_ userEmail: String, _ password: String, completionHandler: @escaping (Bool) -> ()) {
        Auth.auth().createUser(withEmail: userEmail, password: password) { (result, err) in
            if let error = err{
                print("error at creating user, \(String(describing: error.localizedDescription))")
                completionHandler(false)
            }
            else{
                print("Create user succesfull")
                completionHandler(true)
            }
        }
    }
}
