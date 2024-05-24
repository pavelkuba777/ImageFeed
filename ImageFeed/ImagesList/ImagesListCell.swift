//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Павел Куба on 19.05.2024.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
}
