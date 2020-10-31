//
//  HomeSecondDetailPresentationController.swift
//  qv1
//
//  Created by Ryota Yokote on 2020/11/01.
//

import UIKit

import RxCocoa
import RxGesture
import RxSwift

class HomeSecondDetailPresentationController: UIPresentationController {
    let disposeBag = DisposeBag()

    let overlayView = UIView()
    let margin = (x: CGFloat(20), y: CGFloat(110))

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }

        overlayView.frame = containerView.bounds
        overlayView.backgroundColor = .black
        overlayView.alpha = 0.0
        overlayView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                self?.presentedViewController.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        containerView.insertSubview(overlayView, at: 0)

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.overlayView.alpha = 0.7
        }, completion: nil)
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {}

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.overlayView.alpha = 0.0
        }, completion: nil)
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            overlayView.removeFromSuperview()
        }
    }

    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width - 2 * margin.x, height: parentSize.height - 2 * margin.y)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let bounds = containerView?.bounds else { return CGRect() }
        return CGRect(
            origin: CGPoint(x: margin.x, y: margin.y),
            size: size(forChildContentContainer: presentedViewController, withParentContainerSize: bounds.size)
        )
    }

    override func containerViewWillLayoutSubviews() {
        guard let containerView = containerView else { return }
        overlayView.frame = containerView.bounds
        presentedView?.frame = frameOfPresentedViewInContainerView
        presentedView?.layer.cornerRadius = 10
        presentedView?.clipsToBounds = true
    }

    override func containerViewDidLayoutSubviews() {}
}
