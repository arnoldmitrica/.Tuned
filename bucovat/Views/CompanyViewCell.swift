//
//  CompanyViewCell.swift
//  bucovat
//
//  Created by Arnold Mitricã on 02.04.2021.
//

import UIKit
import FirebaseUI

class CompanyViewCell: UITableViewCell, CellConfigurable {
    @IBOutlet var photoOutlet: UIButton!
    @IBOutlet var nameOutlet: UILabel!
    @IBOutlet var imageViewOutlet: UIImageView!
    @IBOutlet var timeOutlet: UILabel!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var textOutlet: UILabel!
    
    static let reuseIdentifier = "CompanyCell"
    var infoModel: ProfileInfoModel!
    
    var post:FeedData!{
        didSet{
            updateUI()
        }
    }
    
    var viewModel:CompanyViewModel?
    func updateUI(){
        let tintedImage = infoModel.nsDataToIMG().withRenderingMode(.alwaysOriginal)
        photoOutlet.setImage(tintedImage, for: .normal)
        photoOutlet.imageView?.contentMode = .scaleAspectFit
        photoOutlet.layer.cornerRadius = 24
        photoOutlet.layer.borderWidth = 1.3
        photoOutlet.layer.borderColor = UIColor.systemPurple.cgColor
        photoOutlet.layer.masksToBounds = true
        imageViewOutlet.image = UIImage(named: "profileimage2.jpg")
        nameOutlet.text = infoModel.name
        textOutlet.text = post.message
        timeOutlet.text = post.timestamp
    }
    
    func setup(viewModel: RowViewModel) {
        guard let viewModel = viewModel as? CompanyViewModel else { return }
        self.viewModel = viewModel
        let tintedImage = viewModel.avatarImage.value.withRenderingMode(.alwaysOriginal)
        photoOutlet.setImage(tintedImage, for: .normal)
        photoOutlet.imageView?.contentMode = .scaleAspectFit
        photoOutlet.layer.cornerRadius = 24
        photoOutlet.layer.borderWidth = 1.3
        photoOutlet.layer.borderColor = UIColor.systemPurple.cgColor
        photoOutlet.layer.masksToBounds = true
        nameOutlet.text = viewModel.name
        
        viewModel.message.addObserver(fireNow: true) { [weak self] (message) in
            self?.textOutlet.text = message
        }
        //photoOutlet.sd_set
        viewModel.avatarImage.addObserver(fireNow: false) { [weak self] (img) in
            let tintedImage = img.withRenderingMode(.alwaysOriginal)
            self?.photoOutlet.setImage(tintedImage, for: .normal)
            self?.photoOutlet.imageView?.contentMode = .scaleAspectFit
            self?.photoOutlet.layer.cornerRadius = 24
            self?.photoOutlet.layer.borderWidth = 1.3
            self?.photoOutlet.layer.borderColor = UIColor.systemPurple.cgColor
            self?.photoOutlet.layer.masksToBounds = true
        }
        viewModel.postImage.addObserver(fireNow: true) { [weak self] (img) in
            self?.imageViewOutlet.image = img
        }
        
        viewModel.timestamp.addObserver(fireNow: true) { [weak self] (timestamp) in
            self?.timeOutlet.text = timestamp
        }
        
        viewModel.firstBatchState.addObserver { [weak self] (state) in
            if state == false {
                let resultProfile = OpenProfileManager.shared.getInfoModelFromCache(email: viewModel.email, user: viewModel.name)
                switch resultProfile{
                case .success(let profile):
                    let tintedImage = profile.nsDataToIMG().withRenderingMode(.alwaysOriginal)
                    self?.photoOutlet.setImage(tintedImage, for: .normal)
                    self?.photoOutlet.imageView?.contentMode = .scaleAspectFit
                    self?.photoOutlet.layer.cornerRadius = 24
                    self?.photoOutlet.layer.borderWidth = 1.3
                    self?.photoOutlet.layer.borderColor = UIColor.systemPurple.cgColor
                    self?.photoOutlet.layer.masksToBounds = true

                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        setNeedsLayout()
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        viewModel?.avatarImage.removeObserver()
        viewModel?.postImage.removeObserver()
        viewModel?.message.removeObserver()
        viewModel?.timestamp.removeObserver()
    }

}

public extension UITableViewCell {
    /// Generated cell identifier derived from class name
    static func cellIdentifier() -> String {
        return String(describing: self)
    }
}
