//
//  FloatingPoint.swift
//  
//
//  Created by Damien Noël Dubuisson on 04/10/2021.
//

public extension SIMDScalar {
    /// Returns the scalar 1.
    static var one: Self { 1 }
    
}

public extension FloatingPoint {
    /// Convert current degrees to radians
    var toRadians: Self { .pi * self / Self(180) }

    /// Convert current radians to degrees
    var toDegrees: Self { self * Self(180) / .pi }
}
