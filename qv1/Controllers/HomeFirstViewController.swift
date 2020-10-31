//
//  HomeFirstViewController.swift
//  qv1
//
//  Created by Ryota Yokote on 2020/10/31.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class HomeFirstViewController: UIViewController, StoryboardView {
    typealias Reactor = HomeViewReactor
    var disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!

    let reflesh = UIRefreshControl()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        tabBarItem.tag = 1
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        tabBarItem.tag = 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
                    self?.headerView.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0.8, alpha: 0.5)
                } else if offset > 100 {
                    self?.headerView.backgroundColor = UIColor(red: 0.8, green: 1, blue: 0.8, alpha: 0.5)
                } else {
                    self?.headerView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
                }
            })
            .disposed(by: disposeBag)

        tableView.refreshControl = reflesh
        reflesh.rx.controlEvent(.valueChanged)
            .bind { [weak self] _ in
                self?.reflesh.endRefreshing()
            }
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

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
}
