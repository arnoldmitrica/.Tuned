//
//  FeedViewModel.swift
//  bucovat
//
//  Created by Arnold Mitricã on 24.02.2021.
//

import UIKit
import Firebase

class FeedView: UIViewController {
    
    var feedview = UITableView()
    var data = CellData()
    
    var ref: Firestore?
    
    override func viewDidLoad() {
        view.addSubview(feedview)
        configureTableView()
        
    }
    
    func configureTableView(){
        view.addSubview(feedview)
        feedview.delegate = self
        feedview.dataSource = self
    }


    
}

extension FeedView:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
}

