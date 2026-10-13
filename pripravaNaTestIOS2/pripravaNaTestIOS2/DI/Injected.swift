//
//  Injected.swift
//  pripravaNaTestIOS2
//
//  Created by endurovojta173 on 10.10.2026.
//

@propertyWrapper
struct Injected<T> {
    let wrappedValue: T

    init() {
        wrappedValue = DIContainer.shared.resolve()
    }
}
