//
//  Stack.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 10/5/21.
//

import Foundation

struct Stack {
    private var array: [Any] = []

    mutating func push(_ element: Any) {
        array.append(element)
    }

    mutating func pop() -> Any? {
        return array.popLast()
    }

    func peek() -> Any? {
        guard let top = array.last else { return nil }
        return top
    }
}
