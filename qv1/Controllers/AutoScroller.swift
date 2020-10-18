//
//  AutoScroller.swift
//  qv1
//
//  Created by Ryota Yokote on 2020/10/25.
//

import Foundation
import RxRelay
import RxSwift
import UIKit

class AutoScroller {
    private let origin: CGFloat

    private let playLength: CGFloat
    private var play: CGFloat

    private var current: CGFloat

    let value = PublishRelay<CGFloat>()

    init(origin: CGFloat) {
        self.origin = origin
        current = 0

        playLength = -origin * 2
        play = origin
    }

    @discardableResult
    func move(to position: CGFloat) -> CGFloat {
        let mov = position - current
        current = position

        play = min(playLength, max(origin - playLength, play + mov))
        let next = min(0, max(origin, play))

        value.accept(next)
        return next
    }
}

extension AutoScroller: ObserverType {
    typealias Element = CGFloat

    func on(_ event: Event<Element>) {
        guard let position = event.element else { return }
        move(to: position)
    }
}
