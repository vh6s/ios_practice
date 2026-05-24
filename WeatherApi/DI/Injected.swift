//
//  Injected.swift
//  WeatherApi
//
//  Created by Matěj on 24.05.2026.
//

@propertyWrapper
struct Injected<T> {
    let wrappedValue: T

    init() {
        wrappedValue = DIContainer.shared.resolve()
    }
}
