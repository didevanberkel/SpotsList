//
//  PostCell.swift
//  spotslist
//
//  Created by Dide van Berkel on 13-03-16.
//  Copyright © 2016 Gary Grape Productions. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        postImage.layer.cornerRadius = 5.0
        postImage.clipsToBounds = true
    }
    
    func configureCell(post: Post) {
        titleLbl.text = post.title
        descriptionLbl.text = post.postDescription
        postImage.image = DataService.instance.getImageForPath(post.imagePath)
    }
    
}
