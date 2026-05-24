//
//  Injected.swift
//  zkouska_prac
//
//  Created by Matěj on 23.05.2026.
//

@propertyWrapper
struct Injected<T> {
    let wrappedValue: T

    init() {
        wrappedValue = DIContainer.shared.resolve()
    }
}
