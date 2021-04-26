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
import PhotosUI

let STORAGE_IMAGE_DIR:String = "images/"
let STORAGE_DOCUMENT_DIR:String = "documents/"
enum StorageFileType : String{
    case JPG, PNG, PDF
}

//F

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
    var refrt = Database.database().reference()
    
    var myUID:String?
    var userEmail:String?// if you are logged in, if not, == nil
    var myUsername:String?
    typealias ResultProfileInfoModel = Result<ProfileInfoModel, Error>
    typealias ResultSecondBatch = Result<SecondBatch,Error>
    
    fileprivate init() {
        // setup USER listener
        Auth.auth().addStateDidChangeListener { [weak self] auth, listenerUser in
            if let user = listenerUser, let self = self {
                print("SIGN IN: \(user.email ?? user.uid)")
                self.myUID = user.uid
                self.userEmail = user.email
                if let email = user.email{
                    self.getUsername(email: email) { (res) in
                        switch res {
                        case .success(let username):
                            self.myUsername = username
                        case .failure(let err):
                            print(err)
                        }
                    }
                }
            } else {
                self?.myUID = nil
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
            //ref.document("users/\(email)").setData(["lastPost" : FieldValue.serverTimestamp()], merge: true)
            docref = ref.collection("users/\(email)/posts").addDocument(data:["message" : message, "timestamp": Timestamp.init(), "email":email, "postcreator":"nobodyfornow", "firma": "Enel" ]){ (error) in
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
    func getSecondBatchForProfileInfoModel(email:String, user:String, completionHandler: @escaping (ResultSecondBatch) -> ()) {
        
        self.refrt.child("bio/\(user)").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if let profile = snapshot.value as? [String : AnyObject]{
                completionHandler(ResultSecondBatch.success(SecondBatch(followers: profile["followers"] as? Int, following: profile["following"] as? Int, posts: profile["posts"] as? Int)))
            }
    }
        )
//    func getSecondBatchFoorProfileInfoModel(email:String, user:String, completionHandler: @escaping (Result<ProfileInfoModel,Error>) -> ()) {
//        
//        self.refrt.child("bio/\(user)").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
//                  let profile = snapshot.value as? [String : AnyObject]
//                    if let profile = profile {
//                        OpenProfileManager.shared.getInfoModel(email: email, user: user, completioHandler: { (infoProfile) in
//                            infoProfile.followers = profile["followers"] as? Int
//                            infoProfile.following = profile["following"] as? Int
//                            infoProfile.posts = profile["posts"] as? Int
//                            completionHandler(Result.success(infoProfile))
//                        }
//                        )
//                    }
//                }) { (err) in
//                    print("error cancel block realtime database \(err.localizedDescription)")
//                }
    }
    func getUsername(email:String,completionHandler: @escaping (Result<String,Error>) -> ()){
        refrt.child("accounts").queryOrdered(byChild: "email").queryStarting(atValue: email).queryEnding(atValue: "\(email)\\uf8ff").observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.exists() != false, let data = snapshot.value as? [String: Any] else { return }
            let userDict = data.values.first as? [String:Any]
            if let user = userDict{
                if let username = user["username"] as? String{
                    completionHandler(Result.success(username))
                }
            }
        }
    }
    func checkIfFollows(username:String, completionHandler: @escaping (Result<Bool,Error>) -> ()){
        refrt.child("following/\(self.myUsername ?? "")").child("\(username)/\(username)").observeSingleEvent(of: .value) { (snap) in
            //print(snap.value, username, self.myUsername, String(describing: self.myUsername))
            guard snap.exists() != false, let data = snap.value as? Bool else { return }
            completionHandler(Result.success(data))
        }
    }
//    func getFollowers(email:String?, completionHandler: @escaping (Result<ProfileInfoModel,Error>) -> ()){
//        guard let email = email else { return }
//        ref.document("users/\(email)").getDocument(completion: { (docsnapshot, err) in
//            if let data = docsnapshot, let datainfo = data.data(){
//                let info = ProfileInfoModel(followers: datainfo["followers"] as? Int, following: datainfo["following"] as? Int, posts: datainfo["posts"] as? Int)
//                completionHandler(Result.success(info))
//            }
//            if let errore = err {
//                print("error completion at getfollowers \(errore.localizedDescription)")
//            }
//        })
//    }
    
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
    func getCurrentUser() -> String? {
        if let user = self.myUsername{
            return user
        }
        return nil
    }
    func getCurrentEmail() -> String?{
        if let email = self.userEmail{
            return email
        }
        return nil
    }
    func getFeedCollectionRef() -> CollectionReference{
        let email = getCurrentEmail()
        return Firestore.firestore().collection("feed/\(email ?? "anonymously")/1")
    }
    
    func feetchFirstBatchOfProfileInfoModel(from email:String, and company:String, completionHandler: @escaping (ResultProfileInfoModel) -> Void){
        var result : ResultProfileInfoModel?
        let group = DispatchGroup()
        group.enter()
            self.ref.document("users/\(email)/firme/\(company)").getDocument(source: .default, completion: { (snap, err) in
                
                if let error = err {
                    print(error.localizedDescription)
                    result = ResultProfileInfoModel.failure(error)
                    group.leave()
                    
                }
                else{
                    if let info = snap?.data(){
                        result = ResultProfileInfoModel.success(ProfileInfoModel(name: info["name"] as! String, avatarImage: info["avatarImage"] as? NSData ?? NSData(data: UIImage(named: "unknown")!.pngData()!)))
                    }
                    group.leave()
                }
            })
        
        group.notify(queue: .main){
            guard let profile = result else { return }
            completionHandler(profile)
        }

//        self.ref.document("users/\(email)/firme/\(company)").getDocument(source: .default, completion: { (snap, err) in
//            if let error = err {
//                print(error.localizedDescription)
//                completionHandler(.failure(error))
//
//            }
//            else{
//                if let info = snap?.data(){
//                    completionHandler(.success(ProfileInfoModel(name: info["name"] as! String, avatarImage: info["avatarImage"] as? NSData ?? NSData(data: UIImage(named: "unknown")!.pngData()!))))
//                }
//
//            }
//        })
    }
    
    func fetchFirstBatchOfProfileInfoModel(from email:String, and company:String, completionHandler: @escaping (ResultProfileInfoModel) -> Void){
        //var source = fireNow
        let group = DispatchGroup()
        var result: ResultProfileInfoModel!
        group.enter()
        self.ref.document("users/\(email)/firme/\(company)").getDocument(source:.default, completion: { (snap, err) in
            
            if let error = err {
                //If there is no data in cache then we choose to read from the server
                //source = FirestoreSource.default
                print(error.localizedDescription)
                result = .failure(error)
                //completionHandler(.failure(error))
                //group.leave()
            }
            else{
                if let info = snap?.data(){
                    result = .success(ProfileInfoModel(name: info["name"] as! String, avatarImage: info["avatarImage"] as? NSData ?? NSData(data: UIImage(named: "unknown")!.pngData()!)))
                    //completionHandler(.success(ProfileInfoModel(name: info["name"] as! String, avatarImage: info["avatarImage"] as? NSData ?? NSData(data: UIImage(named: "unknown")!.pngData()!))))
                }
                
            }
            
            group.leave()
        })
        group.notify(queue: DispatchQueue.main) {
            completionHandler(result)
        }
    }
    
    func fetchFirstBatchOofProfileInfoModel(from email:String, and company:String, completionHandler: @escaping (Result<ProfileInfoModel, Error>) -> Void){
        
        self.ref.document("users/\(email)/firme/\(company)").getDocument(source: .default, completion: { (snap, err) in
            if let error = err {
                print(error.localizedDescription)
                completionHandler(.failure(error))
                
            }
            else{
                if let info = snap?.data(){
                    completionHandler(.success(ProfileInfoModel(name: info["name"] as! String, avatarImage: info["avatarImage"] as? NSData ?? NSData(data: UIImage(named: "unknown")!.pngData()!))))
                }
                
            }
        })
    }
    func fetchdata(_ reference: CollectionReference, completionHandler: @escaping (Result<[FeedData], Error>) -> ()) {
        let feedref = reference
        var tempdata = [FeedData]()
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
                let email = datafetched["email"] as! String
                //OpenProfileManager.shared.getInfoModel(email: email, user: company, completioHandler: { (res) in
               // })
                //OpenProfileManager.shared.temporarilyProfiles.value[email]?.append(company)
                //OpenProfileManager.shared.getInfoModel(email: email, user: company, completionHandler: nil)
                //tempdata.append(FeedData(feedUserDetails: infoModel, admin: admin, message: message, timestamp: timediffstring))
                tempdata.append(FeedData(user: company, email: email, admin: admin, message: message, timestamp: timediffstring))
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completionHandler(Result.success(tempdata))
                tempdata.removeAll()
            }
            //completionHandler(Result.success(tempdata))
            //tempdata.removeAll()
        }
    }
    func changeAvatarImage(with image: UIImage?, for company:String, completionHandler: @escaping (Result<String, Error>) -> ()){
        guard let image = image else { return }
        guard let compressedImage = image.compressTo(0.2) else { return }
        guard let userEmail = userEmail else { return }
        guard let imageForFirebase = compressedImage.pngData() as NSData? else { return }
        ref.document("users/\(userEmail)/firme/\(company)").setData(["avatarImage" : imageForFirebase], merge: true) { (err) in
            if let error = err{
                print(error.localizedDescription)
            }
        }
    }
}
