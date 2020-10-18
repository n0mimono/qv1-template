//
//  RootViewController.swift
//  v0
//
//  Created by Ryota Yokote on 2020/10/10.
//

import UIKit

class RootViewController: UIViewController {
    private var current: UIViewController?

    override func viewDidLoad() {
        let service = ServiceProvider()

        move(name: "HomeView", identifier: "HomeView", type: HomeViewController.self, parent: self) { [self] next in
            next.reactor = HomeViewReactor(service: service)
            self.current = next
        }
    }
}

extension UIViewController {
    func move<T: UIViewController>(name: String, identifier: String, type: T.Type, parent: UIViewController, _ did: ((T) -> Void)?) {
        guard let next = UIStoryboard(name: name, bundle: nil)
            .instantiateViewController(identifier: identifier)
            as? T else { return }
        parent.children.forEach { $0.removeFromParent() }

        did?(next)
        parent.addChild(next)
        parent.view.addSubview(next.view)
        next.didMove(toParent: parent)
    }

    func push<T: UIViewController>(name: String, type: T.Type, did: ((T) -> Void)?) {
        guard let next = UIStoryboard(name: name, bundle: nil)
            .instantiateInitialViewController()
            as? T else { return }

        did?(next)
        navigationController?.pushViewController(next, animated: true)
    }
}
