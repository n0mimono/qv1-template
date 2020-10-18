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
    typealias Reactor = HomeViewReactor
    var disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.title = "Home"

        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension

        let originHeaderHeight = headerHeightConstraint.constant
        tableView.rx.contentOffset.asDriver()
            .distinctUntilChanged()
            .map { max(0, -$0.y) }
            .drive(onNext: { [weak self] offset in
                self?.headerHeightConstraint.constant = originHeaderHeight + offset

                if offset > 200 {
                    self?.headerView.backgroundColor = UIColor(ciColor: .red)
                } else if offset > 100 {
                    self?.headerView.backgroundColor = UIColor(ciColor: .green)
                } else {
                    self?.headerView.backgroundColor = UIColor(ciColor: .white)
                }
            })
            .disposed(by: disposeBag)
    }

    func bind(reactor: Reactor) {
        reactor.state.map { $0.articles }
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "TableViewCell", cellType: TableViewCell.self)) { _, item, cell in
                cell.setArticle(item)
            }
            .disposed(by: disposeBag)

        reactor.relay.selectItem
            .observeOn(MainScheduler.instance)
            .bind { [weak self] article in
                self?.push(name: "ArticleDetail", type: ArticleDetailViewController.self) { next in
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
            .map { _ in Reactor.Action.fetchArticlesAdditive }
            .drive(reactor.action)
            .disposed(by: disposeBag)

        Observable.just(Reactor.Action.fetchArticles)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
