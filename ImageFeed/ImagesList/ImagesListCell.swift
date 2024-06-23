//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Павел Куба on 19.05.2024.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Public properties
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - Outlets
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
}

// MARK: - Extansion
extension ImagesListCell {
    func config(image: UIImage?, date: String, isLiked: Bool) {
        let likedImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        
        cellImage.image = image
        dateLabel.text = date
        likeButton.setImage(likedImage, for: .normal)
    }
}
