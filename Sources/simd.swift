//
//  File.swift
//  
//
//  Created by Vincent LIEGEOIS on 16/06/2023.
//

import Foundation

public protocol SIMD<Scalar>: Equatable {
    associatedtype Scalar
//}
//extension SIMD where Scalar : FloatingPoint {

    /// Creates a vector with zero in all lanes.
    init()
    
    /// A vector with the specified value in all lanes.
    init(repeating value: Scalar)
    
    /// Creates a vector from the given sequence.
    ///
    /// - Precondition: `scalars` must have the same number of elements as the
    ///   vector type.
    ///
    /// - Parameter scalars: The elements to use in the vector.
    init(_ scalars: Array<Scalar>)
    
    /// A vector with zero in all lanes.
    static var zero: Self { get }

    /// A vector with one in all lanes.
    static var one: Self { get }

    static func + (a: Self, b: Self) -> Self

    static func - (a: Self, b: Self) -> Self

    static func * (a: Self, b: Self) -> Self

    static func / (a: Self, b: Self) -> Self


    /// The least scalar in the vector.
    func min() -> Self.Scalar

    /// The greatest scalar in the vector.
    func max() -> Self.Scalar

    /// The sum of the scalars in the vector.
    func sum() -> Self.Scalar

    prefix static func - (a: Self) -> Self

    static func + (a: Self.Scalar, b: Self) -> Self

    static func - (a: Self.Scalar, b: Self) -> Self

    static func * (a: Self.Scalar, b: Self) -> Self

    static func / (a: Self.Scalar, b: Self) -> Self

    static func + (a: Self, b: Self.Scalar) -> Self

    static func - (a: Self, b: Self.Scalar) -> Self

    static func * (a: Self, b: Self.Scalar) -> Self

    static func / (a: Self, b: Self.Scalar) -> Self

    static func += (a: inout Self, b: Self)

    static func -= (a: inout Self, b: Self)

    static func *= (a: inout Self, b: Self)

    static func /= (a: inout Self, b: Self)

    static func += (a: inout Self, b: Self.Scalar)

    static func -= (a: inout Self, b: Self.Scalar)

    static func *= (a: inout Self, b: Self.Scalar)

    static func /= (a: inout Self, b: Self.Scalar)

}
