//
//  SideMenuViewController.swift
//  bucovat
//
//  Created by Arnold Mitricã on 31.12.2020.
//

import UIKit


class SideMenuViewController: UITableViewController {
    private static let reuseCell = "customsidemenucell"
    private var currentUser:String = "you"
    private var menuItems = ["Hi, you!", "Make an observation", "Add companies"]

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    init(with menuItems: [String]?){
        if let menuItems = menuItems{
            self.menuItems = menuItems
        }
        print("menuItems initialized: \(self.menuItems)")
        super.init(nibName: nil, bundle: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: SideMenuViewController.reuseCell)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        let defaults = UserDefaults.standard
//        //... get the new settings
//        if let menuitemss =  defaults.value(forKey: "menuItems") as? [String] {
//            self.menuItems = menuitemss
//        }
//        else{
//            self.menuItems = ["2Hi, \(currentUser)" , "Add a topic"]
//        }
//        defaults.synchronize()
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuViewController.reuseCell, for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        cell.backgroundColor = .systemRed

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    deinit{
        print("Side menu view controller has been deinit  \(self.menuItems) ")
    }
}

