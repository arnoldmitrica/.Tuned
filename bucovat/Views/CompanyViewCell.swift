//
//  CompanyViewCell.swift
//  bucovat
//
//  Created by Arnold Mitricã on 02.04.2021.
//

import UIKit

class CompanyViewCell: UITableViewCell, CellConfigurable {
    @IBOutlet var photoOutlet: UIButton!
    @IBOutlet var nameOutlet: UILabel!
    @IBOutlet var imageViewOutlet: UIImageView!
    @IBOutlet var timeOutlet: UILabel!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var textOutlet: UILabel!
    
    static let reuseIdentifier = "CompanyCell"
    
    var post:CompanyData!{
        didSet{
            updateUI()
        }
    }
    
    var viewModel:CompanyViewModel?
    func updateUI(){
        //photoOutlet.imageView?.image = post.coimage
        let tintedImage = post.coimage?.withRenderingMode(.alwaysOriginal)
        photoOutlet.setImage(tintedImage, for: .normal)
        photoOutlet.imageView?.contentMode = .scaleAspectFit
        photoOutlet.layer.cornerRadius = 20
        photoOutlet.layer.borderWidth = 1.3
        photoOutlet.layer.borderColor = UIColor.systemPurple.cgColor
        photoOutlet.layer.masksToBounds = true
        imageViewOutlet.image = UIImage(named: "profileimage2.jpg")
        //imageViewOutlet.heightAnchor.constraint(equalToConstant: 140).isActive = true
       // photoOutlet.imageView?.backgroundColor = .red
        nameOutlet.text = post.name
        //nameOutlet.backgroundColor = .yellow
        textOutlet.text = post.message
        //textOutlet.backgroundColor = .blue
        //timeOutlet.backgroundColor = .cyan
        timeOutlet.text = post.timestamp
        //stackView.backgroundColor = .red
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
        viewModel.avatarImage.addObserver(fireNow: false) { [weak self] (img) in
            self?.photoOutlet.setImage(img, for: .normal)
        }
        viewModel.postImage.addObserver(fireNow: true) { [weak self] (img) in
            self?.imageViewOutlet.image = img
        }
        
        viewModel.timestamp.addObserver(fireNow: true) { [weak self] (timestamp) in
            self?.timeOutlet.text = timestamp
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
