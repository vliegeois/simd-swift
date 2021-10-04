//
//  Array.swift
//  
//
//  Created by Damien Noël Dubuisson on 04/10/2021.
//

public extension Array {
    mutating func safeRemoveFirst() -> Element? {
        guard !isEmpty else { return nil }
        return removeFirst()
    }

    func fill(_ value: Element, to size: Int) -> Self {
        var returnArray = self
        for _ in count..<size {
            returnArray.append(value)
        }
        return returnArray
    }
}
