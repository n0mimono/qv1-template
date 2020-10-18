//
//  ArticleDetailViewController.swift
//  v0
//
//  Created by Ryota Yokote on 2020/10/03.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

class ArticleDetailViewController: UIViewController {
    var disposeBag = DisposeBag()

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerPositionConstraint: NSLayoutConstraint!

    var article: Article?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let article = article else { return }
        headerLabel.text = article.title
        textView.text = article.body

        let scroller = AutoScroller(origin: headerPositionConstraint.constant)
        textView.rx.contentOffset.asDriver()
            .distinctUntilChanged()
            .map { scroller.move(to: $0.y) }
            .drive(headerPositionConstraint.rx.constant)
            .disposed(by: disposeBag)
    }
}
