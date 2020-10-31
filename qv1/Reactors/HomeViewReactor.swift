//
//  ViewReactor.swift
//  v0
//
//  Created by Ryota Yokote on 2020/10/04.
//

import Foundation
import ReactorKit
import RxRelay

final class HomeViewReactor: Reactor {
    enum Action {
        case fetchArticles
        case fetchArticlesAdditive
        case selectItem(Int)
    }

    enum Mutation {
        case setArticles([Article])
        case addArticles([Article])
        case setLoading(Bool)
        case selectItem(Article?)
    }

    struct State {
        var articles: [Article]
        var isLoading: Bool
        var page: Int
    }

    let initialState: State

    struct Relay {
        let selectItem = PublishRelay<Article?>()
    }

    let relay = Relay()

    let service: ServiceProvider

    init(service: ServiceProvider) {
        self.service = service

        initialState = State(
            articles: [],
            isLoading: false,
            page: 1
        )
        _ = state
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchArticles:
            guard !currentState.isLoading else {
                return Observable.empty()
            }
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                service.api.request(Qiita.GetItems(page: initialState.page, perPage: 20))
                    .compactMap { Mutation.setArticles($0) },
                Observable.just(Mutation.setLoading(false))
            ])
        case .fetchArticlesAdditive:
            guard !currentState.isLoading else {
                return Observable.empty()
            }
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                service.api.request(Qiita.GetItems(page: currentState.page, perPage: 20))
                    .compactMap { Mutation.setArticles($0) },
                Observable.just(Mutation.setLoading(false))
            ])
        case let .selectItem(index):
            let article = currentState.articles[index]
            return Observable.just(Mutation.selectItem(article))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setArticles(articles):
            state.articles = articles
            state.page = initialState.page + 1
        case let .addArticles(articles):
            state.articles += articles
            state.page += 1
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        case let .selectItem(article):
            relay.selectItem.accept(article)
        }
        return state
    }
}
