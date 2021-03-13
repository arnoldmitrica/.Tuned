//
//  FirebaseManager.swift
//  bucovat
//
//  Created by Arnold Mitricã on 17.02.2021.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

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

//typealias completionCallback = (Result<[CellData], Error>) -> Void

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
            ref.document("users/\(email)").setData(["lastPost" : FieldValue.serverTimestamp()], merge: true)
            docref = ref.collection("users/\(email)/posts").addDocument(data:["message" : message, "timestamp": Timestamp.init(), "email":email, "postcreator":"nobodyfornow", "firma": "enel" ]){ (error) in
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
        ref.document("users/\(userEmail)").setData(["createdAt":FieldValue.serverTimestamp()])
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
    
    func fetchdata(_ reference: CollectionReference, completionHandler: @escaping (Result<[CellData], Error>) -> ()) {
        let feedref = reference
        var tempdata = [CellData]()
        let feedquery = feedref.order(by: "timestamp", descending: true).limit(to: 3)
        feedquery.addSnapshotListener { (datasnapshot, error) in
            guard let document = datasnapshot else {
                print("Error fetching document: \(error!)")
                completionHandler(Result.failure("Error fetching the documents. Collection refference invalid." as! Error))
                return
            }
            let source = document.metadata.hasPendingWrites ? "Local" : "Server"
            print("\(source) refference: \(reference.path)")
            for document in document.documents{
                let datafetched = document.data()
                let coimage = UIImage(named: datafetched["firma"] as! String)
                let message = datafetched["message"] as! String
                let company = datafetched["firma"] as! String
                let admin = datafetched["postcreator"] as! String
        
                let timefromdoc = datafetched["timestamp"] as! Timestamp
                let timefromdocToDate = Date(timeIntervalSince1970: TimeInterval(timefromdoc.seconds))
                //let timefromdocument = Date(timeIntervalSince1970: datafetched["timestamp"].seconds
                let timenow = Date()
                
                let timediff = Date.timeFromLshToRhs(lhs: timenow, rhs: timefromdocToDate)
                let timediffstring = TimeInterval(timediff).formatted
                //let timediff = Date.timeFromLshToRhs(lhs: timenow, rhs: timefromdocument)
                
                tempdata.append(CellData(company: company, coimage: coimage, admin: admin, message: message, timestamp: timediffstring))
            }
            completionHandler(Result.success(tempdata))
            tempdata.removeAll()
        }
//        feedquery.getDocuments { (snap, err) in
//            if let error = err{
//                print("avem o eroare la feedref2 \(error)")
//            }
//            else{
//                //print("Snap. documents: \(snap?.documents)")
//                if let documents = snap?.documents{
//                    for document in documents{
//                        let datafetched = document.data()
//                        let coimage = UIImage(named: datafetched["firma"] as! String)
//                        let message = datafetched["message"] as! String
//                        let company = datafetched["firma"] as! String
//                        let admin = datafetched["postcreator"] as! String
//
//                        tempdata.append(CellData(company: company, coimage: coimage, admin: admin, message: message))
//                        // print("Document ID : \(document.documentID) and document data \(document.data())")
//                    }
//                    //print("Finished tempdata: \(tempdata)")
//                    completionHandler(tempdata)
//                }
//            }
//        }
    }
}
