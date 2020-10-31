//
//  HomeThirdViewController.swift
//  qv1
//
//  Created by Ryota Yokote on 2020/10/31.
//

import Foundation

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class HomeThirdViewController: UIViewController {
    let disposeBag = DisposeBag()

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        tabBarItem.tag = 3
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        tabBarItem.tag = 3
    }

    override func viewDidLoad() {
        let width = scrollView.frame.size.width
        scrollView.rx.contentOffset.asDriver()
            .distinctUntilChanged()
            .map { Int($0.x / width) }
            .distinctUntilChanged()
            .drive(pageControl.rx.currentPage)
            .disposed(by: disposeBag)

        pageControl.isUserInteractionEnabled = false
    }
}
