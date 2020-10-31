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

final class HomeViewController: UITabBarController, StoryboardView {
    typealias Reactor = HomeViewReactor
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        delegate = self

        guard let viewControllers = viewControllers else { return }
        for viewController in viewControllers {
            if let homeFirst = viewController as? HomeFirstViewController {
                homeFirst.reactor = reactor
            }
        }
    }

    func bind(reactor: HomeViewReactor) {}

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {}
}

extension HomeViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false
        }

        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.28, options: [.transitionCrossDissolve], completion: nil)
        }

        return true
    }
}
