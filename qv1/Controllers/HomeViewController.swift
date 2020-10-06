//
//  ViewController.swift
//  v0
//
//  Created by Ryota Yokote on 2020/10/03.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class HomeViewController: UIViewController, StoryboardView {
    typealias Reactor = MainViewReactor
    var disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var topLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func bind(reactor: Reactor) {
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension

        reactor.state.map { $0.articles }
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "TableViewCell", cellType: TableViewCell.self)) { _, item, cell in
                cell.setArticle(item)
            }
            .disposed(by: disposeBag)

        reactor.relay.selectItem
            .observeOn(MainScheduler.instance)
            .bind { [unowned self] article in
                push(name: "ArticleDetail", type: ArticleDetailViewController.self) { next in
                    next.article = article
                }
            }
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .map { Reactor.Action.selectItem($0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        tableView.rx.contentOffset.asDriver()
            .distinctUntilChanged()
            .map {
                let tableViewMaximumOffset = self.tableView.contentSize.height - self.tableView.frame.height
                return Int(tableViewMaximumOffset - $0.y)
            }
            .filter { $0 < 500 }
            .map { _ in Reactor.Action.fetchArticles }
            .drive(reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.textValue }
            .bind(to: topLabel.rx.text)
            .disposed(by: disposeBag)
        topButton.rx.tap
            .map { _ in Reactor.Action.updateTextValue("555") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        Observable.just(Reactor.Action.fetchArticles)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
