//
//  ArticleDetailViewController.swift
//  v0
//
//  Created by Ryota Yokote on 2020/10/03.
//

import UIKit

class ArticleDetailViewController: UIViewController {
    @IBOutlet weak var textLabel: UILabel!

    var article: Article?

    override func viewDidLoad() {
        super.viewDidLoad()

        textLabel.text = article?.body ?? ""
    }
}
