//
//  TableViewCell.swift
//  v0
//
//  Created by Ryota Yokote on 2020/10/03.
//

import Alamofire
import SDWebImage
import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userThumbImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setArticle(_ article: Article) {
        titleLabel.text = article.title
        userNameLabel.text = article.user.id
        userThumbImageView.sd_setImage(with: URL(string: article.user.profileImageUrl))
    }
}
