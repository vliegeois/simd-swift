//
//  simdStatic.swift
//  
//
//  Created by Damien Noël Dubuisson on 05/10/2021.
//

import Darwin

// Will define all static helpers for simd

// MARK: - simd_double3

public func simd_length_squared(_ __x: simd_double3) -> Double {
    return sqrt(__x.x*__x.x + __x.y*__x.y + __x.z*__x.z)
}

public func simd_normalize(_ __x: simd_double3) -> simd_double3 {
    let magnitude = simd_length_squared(__x)
    return .init(__x.x / magnitude, __x.y / magnitude, __x.z / magnitude)
}

public func simd_cross(_ __x: simd_double3, _ __y: simd_double3) -> simd_double3 {
    return .init(__x.y*__y.z - __x.z*__y.y,
                 __x.z*__y.x - __x.x*__y.z,
                 __x.x*__y.y - __x.y*__y.x)
}
