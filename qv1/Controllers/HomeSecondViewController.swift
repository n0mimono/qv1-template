//
//  HomeSecondViewController.swift
//  qv1
//
//  Created by Ryota Yokote on 2020/10/31.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class HomeSecondViewController: UIViewController {
    let disposeBag = DisposeBag()

    @IBOutlet weak var button: UIButton!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        tabBarItem.tag = 2
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        tabBarItem.tag = 2
    }

    override func viewDidLoad() {
        button.rx.tap
            .bind { [weak self] _ in
                self?.present(name: "HomeSecondDetailView", type: HomeSecondDetailViewController.self) { next in
                    next.modalPresentationStyle = .custom
                    next.transitioningDelegate = self
                }
            }
            .disposed(by: disposeBag)
    }
}

extension HomeSecondViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HomeSecondDetailPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
