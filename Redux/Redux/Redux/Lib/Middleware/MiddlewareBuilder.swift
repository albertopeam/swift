//
//  MiddlewareBuilder.swift
//  Redux
//
//  Created by Alberto Penas Amor on 14/7/22.
//

import Foundation

@resultBuilder
struct MiddlewareBuilder<Action> {
    static func buildArray(
        _ components: [MiddlewarePipeline<Action>]
    ) -> AnyMiddleware<Action> {
        MiddlewarePipeline(components.map { $0.eraseToAnyMiddleware() })
            .eraseToAnyMiddleware()
    }

    static func buildBlock(
        _ components: AnyMiddleware<Action>...
    ) -> MiddlewarePipeline<Action> {
        .init(components)
    }

    static func buildEither<M: Middleware>(
        first component: M
    ) -> AnyMiddleware<Action> where M.Action == Action {
        component.eraseToAnyMiddleware()
    }

    static func buildEither<M: Middleware>(
        second component: M
    ) -> AnyMiddleware<Action> where M.Action == Action {
        component.eraseToAnyMiddleware()
    }

    static func buildExpression<M: Middleware>(
        _ expression: M
    ) -> AnyMiddleware<Action> where M.Action == Action {
        expression.eraseToAnyMiddleware()
    }

    static func buildFinalResult<M: Middleware>(
        _ component: M
    ) -> AnyMiddleware<Action> where M.Action == Action {
        component.eraseToAnyMiddleware()
    }

    static func buildOptional(
        _ component: MiddlewarePipeline<Action>?
    ) -> AnyMiddleware<Action> {
        guard let component = component else {
            return EchoMiddleware<Action>().eraseToAnyMiddleware()
        }

        return component.eraseToAnyMiddleware()
    }
}
