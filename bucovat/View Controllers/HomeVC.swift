//
//  HomeVC.swift
//  bucovat
//
//  Created by Arnold Mitricã on 29.12.2020.
//

import UIKit
import SideMenu
import Firebase

class HomeVC: UITableViewController {
    var data = [CellData]()
    var currentemail:String?
    var expandedIndexSet: IndexSet = []

    var addPostButton:AddNewPostButton!
    var addPostButtonBottomAnchor:NSLayoutConstraint!
    var sideMenu = SideMenuNavigationController(rootViewController: SideMenuViewController(with: ["Hi, you!", "Make an observation", "Add companies"]))
    
    func setamnewsfeed(){
        print("Setting newsfeed called")
        fetchdata { (datatofetch,email)  in
            if let datatofetch2 = datatofetch{
                print("Datatofetched not nil")
                DispatchQueue.main.async {
                    self.data = datatofetch2
                    self.currentemail = email
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    }
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear homevc")
        super.viewWillAppear(animated)
        
        sideMenu = SideMenuNavigationController(rootViewController: SideMenuViewController(with: ["Hi, You!", "Add a topic"]))
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        
//        Auth.auth().addStateDidChangeListener{ [weak self] (auth, user) in
//            guard let strongSelf = self else { return }
//            if Auth.auth().currentUser != nil{
//                let name = Auth.auth().currentUser?.displayName
//                strongSelf.sideMenu = SideMenuNavigationController(rootViewController: SideMenuViewController(with: ["2Hi, \(name ?? "You") !", "Add a topic"]))
//                SideMenuManager.default.leftMenuNavigationController = strongSelf.sideMenu
//            }
//            else{
//                print("Auth current user este == nil in viewillappear homevc")
//                strongSelf.sideMenu = SideMenuNavigationController(rootViewController: SideMenuViewController(with: ["2Hi, \("Hi, you!")", "Add a topic"]))
//            }
        }
    override func viewDidAppear(_ animated: Bool) {
        
//        let navController = UINavigationController(rootViewController: LoginViewController(delegatee: self)) // gives you the top bar
//        present(navController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view, forMenu: .left)
        //SideMenuManager.default.addPanGestureToPresent(toView: view)
        
        addpostsetting()
                
        setamnewsfeed()
        
        let refreshControll = UIRefreshControl()
        self.tableView.refreshControl = refreshControll
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        self.tableView.register(CustomMessageCell.self, forCellReuseIdentifier: "custom")

    }

    @objc func handleRefresh(){
        print("Refresh")
        let db = Firestore.firestore()
        //var feedref:DocumentReference?
        //var flagDocument: DocumentSnapshot
        if let email = currentemail{
            print("email handle \(email)")
            db.collection("feed").document(email).getDocument(completion: { [weak self] (snap, err) in
                if let values = snap?.data(){
                    if let state = values["sent"] as? Bool{
                        if state == false {
                            self?.setamnewsfeed()
                            db.collection("feed").document(email).setData(["sent" : true], merge: true)
                            self?.tableView.refreshControl?.endRefreshing()
                        }
                        else{
                            print("You are up to date")
                            self?.tableView.refreshControl?.endRefreshing()
                        }
                    }
                }
            })
        }
//        db.runTransaction { (transaction, nserror) -> Any? in
//            do {
//                if let feedref = feedref{
//                    try flagDocument = transaction.getDocument(feedref)
//                }
//            } catch let fetchError as NSError {
//                nserror?.pointee = fetchError
//                return nil
//            }
//
//            guard let oldState = flagDocument.data()?["sent"] as? Bool else {
//                let error = NSError(
//                    domain: "AppErrorDomain",
//                    code: -1,
//                    userInfo: [
//                        NSLocalizedDescriptionKey: "Unable to retrieve state from snapshot \(flagDocument)"
//                    ]
//                )
//                nserror?.pointee = error
//                return nil
//            }
//
//        } completion: { (<#Any?#>, <#Error?#>) in
//            <#code#>
//        }
        
    }
    
    @objc func newpost(){
        let post = AddPost()
        post.modalPresentationStyle = .overFullScreen
        
        let navController = UINavigationController(rootViewController: post)

        self.present(navController, animated: true)
    }
    
    func addpostsetting(){
        addPostButton = AddNewPostButton()
        view.addSubview(addPostButton)
        addPostButton.translatesAutoresizingMaskIntoConstraints = false
        addPostButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addPostButtonBottomAnchor = addPostButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25)
        addPostButtonBottomAnchor.isActive = true
        addPostButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        //addPostButton.widthAnchor.constraint(equalToConstant: addPostButton.button.bounds.width).isActive = true
        //addPostButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        addPostButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 75).isActive = true
        addPostButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 75).isActive = true
        addPostButton.button.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title3)
        addPostButton.button.titleLabel?.adjustsFontForContentSizeCategory = true
        
        addPostButton.button.addTarget(self, action: #selector(newpost), for: .touchUpInside)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if(expandedIndexSet.contains(indexPath.row)){
            expandedIndexSet.remove(indexPath.row)
            print("remove")
        }
        else{
            expandedIndexSet.insert(indexPath.row)
            print("insert")
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom", for: indexPath) as! CustomMessageCell
        cell.coimage = data[indexPath.row].coimage
        cell.message = data[indexPath.row].message
        cell.admin = data[indexPath.row].admin
        cell.company = data[indexPath.row].company
        cell.messageView.text = cell.message

        if expandedIndexSet.contains(indexPath.row){
            cell.messageView.numberOfLines = 0
        }
        else{
            cell.messageView.numberOfLines = 3
        }
        // Configure the cell...
        cell.layoutSubviews()
        return cell
    }


}


func fetchdata(completion: @escaping (_ data:[CellData]?, _ email: String)->()){
    if Auth.auth().currentUser != nil {
        let email = Auth.auth().currentUser?.email
        print("Auth current user email: \(String(describing: email))")
        let db = Firestore.firestore()
        var feedquery : Query?
        var tempdata: [CellData] = []
        if let emailul = email{
            let feedref = db.collection("feed").document(emailul).collection("1")
            feedquery = feedref.order(by: "timestamp", descending: true).limit(to: 3)
            if let feed = feedquery{
                feed.getDocuments { (snap, err) in
                    if let error = err{
                        print("avem o eroare la feedref2 \(error)")
                    }
                    else{
                        //print("Snap. documents: \(snap?.documents)")
                        if let documents = snap?.documents{
                            for document in documents{
                                let datafetched = document.data()
                                let coimage = UIImage(named: datafetched["firma"] as! String)
                                let message = datafetched["message"] as! String
                                let company = datafetched["firma"] as! String
                                let admin = datafetched["postcreator"] as! String
                                
                                tempdata.append(CellData(company: company, coimage: coimage, admin: admin, message: message))
                               // print("Document ID : \(document.documentID) and document data \(document.data())")
                            }
                            //print("Finished tempdata: \(tempdata)")
                            DispatchQueue.main.async {
                                completion(tempdata, emailul)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension HomeVC: SendCredentials {
    
    func sendcredentials(menuItems : [String]?){
        
        if let menuItems = menuItems{
           sideMenu = SideMenuNavigationController(rootViewController: SideMenuViewController(with: menuItems))
            SideMenuManager.default.leftMenuNavigationController = sideMenu
        }
        print("am ajuns extension homevc")
        
    }
    
}
