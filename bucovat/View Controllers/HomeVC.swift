//
//  HomeVC.swift
//  bucovat
//
//  Created by Arnold Mitricã on 29.11.2020.
//

import UIKit
import SideMenu
import Firebase
import FirebaseFirestore

class HomeVC: UITableViewController {
    var data = [FeedData]()
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
        self.navigationController?.view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: (navigationController?.view.centerYAnchor)!),
            label.centerXAnchor.constraint(equalTo: (navigationController?.view.centerXAnchor)!, constant: 0)
            ])
        label.textColor = UIColor.white
        label.font = UIFont(name: "AmericanTypewriter-Bold", size: 24)
        return label
    }()
    
    private lazy var dataSource = makeDataSource()
    
    func initBinding() {
        viewModel.viewModels.addObserver(fireNow: false) { [weak self] (viewModels) in
            self?.updateTable(list: viewModels)
            
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
                self?.navigationController?.setNavigationBarHidden(true, animated: true)
                //self?.titleLabel.topAnchor.constraint(equalTo: (self?.view.safeAreaLayoutGuide.topAnchor)!,constant: 10).isActive = true
                print("isLoading = true")
                self?.tabBarController?.tabBar.isHidden = true
            } else {
                self?.titleLabel.text = ""
                self?.navigationController?.setNavigationBarHidden(false, animated: true)
                self?.tabBarController?.tabBar.isHidden = false
                //self?.titleLabel.topAnchor.constraint(equalTo: (self?.view.safeAreaLayoutGuide.topAnchor)!,constant: -30).isActive = true
                print("isLoading = false")
            }
        }
    }
    func initView(){
        let refreshControll = UIRefreshControl()
        self.tableView.refreshControl = refreshControll
        tableView.refreshControl?.addTarget(self, action: #selector(HomeVC.handleRefresh), for: .valueChanged)
                
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    }
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear homevc")
        super.viewWillAppear(animated)
        //self.titleLabel.text = "Loading..."
        sideMenu = SideMenuNavigationController(rootViewController: SideMenuViewController(with: ["Hi, You!", "Add a topic"]))
        SideMenuManager.default.leftMenuNavigationController = sideMenu
    
        }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func viewDidLoad() {
        
        let titleLabel = UILabel()
        titleLabel.text = "  .Tuned"
        titleLabel.font = UIFont(name: "AmericanTypewriter-Bold", size: 23)
        titleLabel.sizeToFit()
        
        let leftItem = UIBarButtonItem(customView: titleLabel)
        self.navigationItem.leftBarButtonItem = leftItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .done, target: self, action: #selector(logout))
        navigationController?.setNavigationBarHidden(true, animated: true)
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: nil)
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
        //var snap = HomeVC.
        var snap = self.dataSource.snapshot()
        snap.reloadItems(viewModel.viewModels.value)
        self.dataSource.apply(snap)
        refreshControl?.endRefreshing()
        
    }
    
    @objc func logout(){
        
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
            
        switch viewModel.viewModels.value[indexPath.row].viewModel {
        case .company(let company):
            vc.controller.viewModel.email.value = company.email
            vc.controller.viewModel.name.value = company.name
        }
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
    
}


extension HomeVC: SendCredentials {
    
    func sendcredentials(menuItems : [String]?){
        
        if let menuItems = menuItems{
           sideMenu = SideMenuNavigationController(rootViewController: SideMenuViewController(with: menuItems))
            SideMenuManager.default.leftMenuNavigationController = sideMenu
        }
        // print("am ajuns extension homevc")
        
    }
    
}

private extension HomeVC {
    func makeDataSource() -> UITableViewDiffableDataSource<Section, WrapperForUserTypes> {
        
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { [weak self]  tableView, indexPath, user in
                switch user.viewModel{
                case .company(let company):
                    let cell = tableView.dequeueReusableCell(withIdentifier: (self?.controller.cellIdentifier(for: company as RowViewModel))!, for: indexPath)
                    if let cell = cell as? CellConfigurable{
                        cell.setup(viewModel: company as RowViewModel)
                    }
//                    if let cell = cell as? CompanyViewCell{
//                        cell.infoModel = company
//                    }
                    return cell
                }
            }
        )
    }
}
extension HomeVC {
    enum Section: CaseIterable {
        case company
        case empty
    }
}

    extension HomeVC {
        private func updateTable(list: [WrapperForUserTypes]) {
            // Create a new snapshot on each load. Normally you might pull
            // the existing snapshot and update it.
            var snapshot = NSDiffableDataSourceSnapshot<Section, WrapperForUserTypes>()
            defer {
                DispatchQueue.main.async {
                    self.dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
                    print("snapshot.numberof \(snapshot.numberOfItems)")
                }
            }
            
            // If we have no data, just show the empty view
            //        guard list = list. else{
            //            snapshot.appendSections([Section.empty])
            //            snapshot.appendItems([], toSection: .empty)
            //        }
            
            //snapshot.appendItems(<#T##identifiers: [Wrapper]##[Wrapper]#>, toSection: [])
            snapshot.appendSections([.company])
            snapshot.appendItems(list,toSection: .company)
        }
    }
