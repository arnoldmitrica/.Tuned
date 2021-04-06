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
    var data = [CompanyData]()
    var currentemail:String?
    var expandedIndexSet: IndexSet = []

    var seeNewPostButton:AddNewPostButton!
    var seeNewPostButtonTopAnchor:NSLayoutConstraint!
    var addPostButton:AddNewPostButton!
    var addPostButtonBottomAnchor:NSLayoutConstraint!
    var sideMenu = SideMenuNavigationController(rootViewController: SideMenuViewController(with: ["Hi, you!", "Make an observation", "Add companies"]))
    
    var viewModel:HomeViewModel{
        return controller.viewModel
    }
    lazy var controller : HomeController = {
        return HomeController()
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
            ])
        label.textColor = UIColor.white
        label.font = UIFont(name: "AmericanTypewriter-Bold", size: 24)
        return label
    }()
    
    func initBinding() {
        viewModel.viewModels.addObserver(fireNow: false) { [weak self] (viewModels) in
            self?.tableView.reloadData()
        }

        viewModel.title.addObserver { [weak self] (title) in
            //self?.titleLabel.text = title
        }

        viewModel.isTableViewHidden.addObserver { [weak self] (isHidden) in
            print("isHidden = \(isHidden)")
            self?.tableView.isHidden = isHidden
        }

        viewModel.isLoading.addObserver(fireNow: true) { [weak self] (isLoading) in
            if isLoading {
                self?.titleLabel.text = "Loading..."
                //self?.titleLabel.topAnchor.constraint(equalTo: (self?.view.safeAreaLayoutGuide.topAnchor)!,constant: 10).isActive = true
                print("isLoading = true")
            } else {
                self?.titleLabel.text = ""
                //self?.titleLabel.topAnchor.constraint(equalTo: (self?.view.safeAreaLayoutGuide.topAnchor)!,constant: -30).isActive = true
                print("isLoading = false")
            }
        }
    }
    func initView(){
        let refreshControll = UIRefreshControl()
        self.tableView.refreshControl = refreshControll
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
                
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
//    func setamnewsfeed(){
//        print("Setting newsfeed called")
//        currentemail = Auth.auth().currentUser?.email
//        Fire.shared.fetchdata(Firestore.firestore().collection("feed/\(currentemail ?? "anonymously")/1"), completionHandler: { (result) in
//
//            switch result {
//
//            case .success(let datatofetch):
//                print("Datatofetched not nil")
//                DispatchQueue.main.async {
//                    self.data = datatofetch
//                    self.seeNewPostButton.button.setTitle("New posts added", for: .normal)
//                    self.seeNewPostButtonTopAnchor.constant = 20
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                        self.seeNewPostButtonTopAnchor.constant = -44
//                    }
//                    self.tableView.reloadData()
//                }
//            case .failure(let err):
//                print("Error occured: \(err.localizedDescription)")
//            }
//        })
//    }
    
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
        navigationItem.title = ".Tuned"
        super.viewDidLoad()
        sideMenu.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view, forMenu: .left)
        //SideMenuManager.default.addPanGestureToPresent(toView: view)
        tableView.separatorStyle = .none
        addpostsetting()
                
        //setamnewsfeed()
        
        initView()
        initBinding()
        controller.start()
    }

    @objc func handleRefresh(){
        print("Refresh")
        tableView.reloadData()
        refreshControl?.endRefreshing()
        
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
        addPostButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 75).isActive = true
        addPostButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 75).isActive = true
        addPostButton.button.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title3)
        addPostButton.button.titleLabel?.adjustsFontForContentSizeCategory = true
        
        addPostButton.button.addTarget(self, action: #selector(newpost), for: .touchUpInside)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Profile") as! OpenProfileViewController
        
        vc.controller.viewModel.email.value = viewModel.viewModels.value[indexPath.row].email
        vc.controller.viewModel.name.value = viewModel.viewModels.value[indexPath.row].name
        self.navigationController?.pushViewController(vc, animated: true)
//        if(expandedIndexSet.contains(indexPath.row)){
//            expandedIndexSet.remove(indexPath.row)
//            print("remove")
//        }
//        else{
//            expandedIndexSet.insert(indexPath.row)
//            print("insert")
//        }
//        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.viewModels.value.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowViewModel = viewModel.viewModels.value[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: controller.cellIdentifier(for: rowViewModel), for: indexPath)
        
        
        if let cell = cell as? CellConfigurable {
            cell.setup(viewModel: rowViewModel)
        }
        
        /*

        if expandedIndexSet.contains(indexPath.row){
            cell.messageView.numberOfLines = 0
        }
        else{
            cell.messageView.numberOfLines = 3
        }
 
 */
        // Configure the cell...
        //cell.layoutSubviews()
        
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
