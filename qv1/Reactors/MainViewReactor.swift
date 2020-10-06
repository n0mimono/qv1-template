//
//  ViewReactor.swift
//  v0
//
//  Created by Ryota Yokote on 2020/10/04.
//

import Foundation
import ReactorKit
import RxRelay

final class MainViewReactor: Reactor {
    enum Action {
        case fetchArticles
        case selectItem(Int)
        case updateTextValue(String)
    }

    enum Mutation {
        case addArticles([Article])
        case setLoading(Bool)
        case selectItem(Article?)
        case updateTextValue(String)
    }

    struct State {
        var articles: [Article]
        var isLoading: Bool
        var page: Int
        var textValue: String
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
            page: 1,
            textValue: "000"
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchArticles:
            guard !currentState.isLoading else {
                return Observable.empty()
            }
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                service.api.request(ItemRequest(page: currentState.page), ItemsResponse.self)
                    .compactMap { Mutation.addArticles($0.articles) },
                Observable.just(Mutation.setLoading(false))
            ])
        case let .selectItem(index):
            let article = currentState.articles[index]
            return Observable.just(Mutation.selectItem(article))
        case let .updateTextValue(text):
            return Observable.just(Mutation.updateTextValue(text))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .addArticles(articles):
            state.articles += articles
            state.page += 1
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        case let .selectItem(article):
            relay.selectItem.accept(article)
        case let .updateTextValue(text):
            state.textValue = text
        }
        return state
    }
}
