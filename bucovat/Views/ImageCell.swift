//
//  ImageCell.swift
//  bucovat
//
//  Created by Arnold Mitricã on 16.02.2021.
//

import Foundation
import UIKit

class ImageCell: UICollectionViewCell {
    var image: UIImageView!
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
     
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
     
    private func setupViews() {
        image = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        addSubview(image)
    }
}
