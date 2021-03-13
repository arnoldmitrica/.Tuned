//
//  FeedViewController.swift
//  bucovat
//
//  Created by Arnold Mitricã on 24.02.2021.
//

import UIKit
import Firebase
import FirebaseFirestore

class FeedViewController: UIViewController {
    

    var feedview = UITableView()
    var data = [CellData]()
    
    var ref: CollectionReference?
    
    fileprivate init(reference: CollectionReference) {
        self.ref = reference
        super.init(nibName: nil, bundle: nil)
        //super.in
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.addSubview(feedview)
        configureTableView()
        fetchdata()
        
    }
    
    func fetchdata(){
        if let reference = ref {
            Fire.shared.fetchdata(reference) { (data) in
                DispatchQueue.main.async {
                    self.data = data
                    self.feedview.reloadData()
                }
            }
        }
    }
    
    func configureTableView(){
        view.addSubview(feedview)
        feedview.delegate = self
        feedview.dataSource = self
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom", for: indexPath) as! CustomMessageCell
        
        
        cell.coimage = data[indexPath.row].coimage
        cell.message = data[indexPath.row].message
        cell.admin = data[indexPath.row].admin
        cell.company = data[indexPath.row].company
        cell.messageView.text = cell.message

//        if expandedIndexSet.contains(indexPath.row){
//            cell.messageView.numberOfLines = 0
//        }
//        else{
//            cell.messageView.numberOfLines = 3
//        }
        // Configure the cell...
        cell.layoutSubviews()
        return cell
    }
}
