//
//  HomeVC.swift
//  bucovat
//
//  Created by Arnold Mitricã on 29.12.2020.
//

import UIKit
import SideMenu
import Firebase
import FirebaseFirestore

class HomeVC: UITableViewController {
    var data = [CellData]()
    var currentemail:String?
    var expandedIndexSet: IndexSet = []

    var seeNewPostButton:AddNewPostButton!
    var seeNewPostButtonTopAnchor:NSLayoutConstraint!
    var addPostButton:AddNewPostButton!
    var addPostButtonBottomAnchor:NSLayoutConstraint!
    var sideMenu = SideMenuNavigationController(rootViewController: SideMenuViewController(with: ["Hi, you!", "Make an observation", "Add companies"]))
    
    func setamnewsfeed(){
        print("Setting newsfeed called")
        currentemail = Auth.auth().currentUser?.email
        Fire.shared.fetchdata(Firestore.firestore().collection("feed/\(currentemail ?? "anonymously")/1"), completionHandler: { (result) in
            
            switch result {
            
            case .success(let datatofetch):
                print("Datatofetched not nil")
                DispatchQueue.main.async {
                    self.data = datatofetch
                    self.seeNewPostButton.button.setTitle("New posts added", for: .normal)
                    self.seeNewPostButtonTopAnchor.constant = 20
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.seeNewPostButtonTopAnchor.constant = -44
                    }
                    self.tableView.reloadData()
                }
            case .failure(let err):
                print("Error occured: \(err.localizedDescription)")
            }
        })
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    }
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear homevc")
        super.viewWillAppear(animated)
        
        sideMenu = SideMenuNavigationController(rootViewController: SideMenuViewController(with: ["Hi, You!", "Add a topic"]))
        SideMenuManager.default.leftMenuNavigationController = sideMenu
    
        }
    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view, forMenu: .left)
        //SideMenuManager.default.addPanGestureToPresent(toView: view)
        tableView.separatorStyle = .none
        addpostsetting()
                
        setamnewsfeed()
        
        let refreshControll = UIRefreshControl()
        self.tableView.refreshControl = refreshControll
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        self.tableView.register(CustomMessageCell.self, forCellReuseIdentifier: "custom")
        
        seeNewPostButton = AddNewPostButton()
        view.addSubview(seeNewPostButton)
        seeNewPostButton.translatesAutoresizingMaskIntoConstraints = false
//        seeNewPostButtonTopAnchor = view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -44)
        seeNewPostButtonTopAnchor = seeNewPostButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -10)
        seeNewPostButtonTopAnchor.isActive = true
        seeNewPostButton.widthAnchor.constraint(equalToConstant: seeNewPostButton.button.bounds.width).isActive = true
        seeNewPostButton.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        seeNewPostButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        seeNewPostButton.button.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
    }

    @objc func handleRefresh(){
        print("Refresh")
        let db = Firestore.firestore()

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
        //cell.messageView.text = cell.message
        cell.timestamp = data[indexPath.row].timestamp

        if expandedIndexSet.contains(indexPath.row){
            cell.messageView.numberOfLines = 0
        }
        else{
            cell.messageView.numberOfLines = 3
        }
        // Configure the cell...
        cell.layoutSubviews()
        
        //Utilities.styleLabel(cell.messageView, height: self.tableView.estimatedRowHeight)
        return cell
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

extension Date {

    static func timeFromLshToRhs (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}

extension TimeInterval {
    var formatted: String {
        let endingDate = Date()
        let startingDate = endingDate.addingTimeInterval(-self)
        let calendar = Calendar.current

        let componentsNow = calendar.dateComponents([.hour, .minute, .second], from: startingDate, to: endingDate)
        if let hour = componentsNow.hour, let minute = componentsNow.minute, let seconds = componentsNow.second {
            //return "\(String(format: "%02d", hour)):\(String(format: "%02d", minute)):\(String(format: "%02d", seconds))"
            if hour < 2{
                if minute < 2 {
                    if minute == 0 {
                        return "about \(String(format: "%02d", seconds)) seconds ago "
                    }
                    return "\(String(format: "%02d", minute)) min. and \(String(format: "%02d", seconds)) sec. ago "
                }
                if hour == 0 {
                    return "\(String(format: "%02d", minute)) minutes ago "
                }
                return "about \(String(format: "%02d", hour)) hours and \(String(format: "%02d", minute)) minutes ago "
            }
            if hour > 24 {
                return "\(String(format: "%02d", hour/24)) days, \(hour % 24) h ago"
            }
            return "about \(String(format: "%02d", hour + 1)) hours ago"
    
        } else {
            return ""
        }
    }
}
