//
//  simd_quatd.swift
//  
//
//  Created by Damien Noël Dubuisson on 05/10/2021.
//

import Darwin

public struct simd_quatd: Equatable {
    public var vector: simd_double4

    /// Creates a quaternion with zero in all lanes.
    public init() {
        vector = .zero
    }

    public init(vector: simd_double4) {
        self.vector = vector
    }

    /// Construct a quaternion from components.
    ///
    /// - Parameters:
    ///   - ix: The x-component of the imaginary (vector) part.
    ///   - iy: The y-component of the imaginary (vector) part.
    ///   - iz: The z-component of the imaginary (vector) part.
    ///   - r: The real (scalar) part.
    public init(ix: Double, iy: Double, iz: Double, r: Double) {
        vector = .init(ix, iy, iz, r)
    }

    /// Construct a quaternion from real and imaginary parts.
    public init(real: Double, imag: SIMD3<Double>) {
        vector = .init(imag, real)
    }

//    /// A quaternion whose action is a rotation by `angle` radians about `axis`.
//    ///
//    /// - Parameters:
//    ///   - angle: The angle to rotate by measured in radians.
//    ///   - axis: The axis to rotate around.
//    public init(angle: Double, axis: SIMD3<Double>)
//
//    /// A quaternion whose action rotates the vector `from` onto the vector `to`.
//    public init(from: SIMD3<Double>, to: SIMD3<Double>)
//
//    /// Construct a quaternion from `rotationMatrix`.
//    public init(_ rotationMatrix: simd_double3x3)
//
//    /// Construct a quaternion from `rotationMatrix`.
//    public init(_ rotationMatrix: simd_double4x4)

    /// The real (scalar) part of `self`.
    public var real: Double { vector.w }

    /// The imaginary (vector) part of `self`.
    public var imag: SIMD3<Double> { .init(vector.x, vector.y, vector.z) }

//    /// The angle (in radians) by which `self`'s action rotates.
//    public var angle: Double { get }
//
//    /// The normalized axis about which `self`'s action rotates.
//    public var axis: SIMD3<Double> { get }

    /// The conjugate of `self`.
    public var conjugate: simd_quatd {
        return .init(ix: -vector.x, iy: -vector.y, iz: -vector.z, r: vector.w)
    }

    /// The inverse of `self`.
    public var inverse: simd_quatd {
        let conjugate = conjugate
        let magnitude = length
        return .init(ix: conjugate.vector.x/(magnitude*magnitude),
                     iy: conjugate.vector.y/(magnitude*magnitude),
                     iz: conjugate.vector.z/(magnitude*magnitude),
                     r: conjugate.vector.w/(magnitude*magnitude))
    }

    /// The unit quaternion obtained by normalizing `self`.
    public var normalized: simd_quatd {
        let magnitude = length
        return .init(ix: vector.x/magnitude, iy: vector.y/magnitude, iz: vector.z/magnitude, r: vector.w/magnitude)
    }

    /// The length of the quaternion interpreted as a 4d vector.
    public var length: Double {
        return sqrt(vector.x*vector.x + vector.y*vector.y + vector.z*vector.z + vector.w*vector.w)
    }

    // MARK: - Self's Operation

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: simd_quatd, rhs: simd_quatd) -> Bool {
        return lhs.vector == rhs.vector
    }

    /// The sum of `lhs` and `rhs`.
    public static func + (lhs: simd_quatd, rhs: simd_quatd) -> simd_quatd {
        return .init(ix: lhs.vector.x + rhs.vector.x,
                     iy: lhs.vector.y + rhs.vector.y,
                     iz: lhs.vector.z + rhs.vector.z,
                     r: lhs.vector.w + rhs.vector.w)
    }

    /// Add `rhs` to `lhs`.
    public static func += (lhs: inout simd_quatd, rhs: simd_quatd) {
        lhs = lhs + rhs
    }

//    /// The difference of `lhs` and `rhs`.
//    public static func - (lhs: simd_quatd, rhs: simd_quatd) -> simd_quatd
//
//    /// Subtract `rhs` from `lhs`.
//    public static func -= (lhs: inout simd_quatd, rhs: simd_quatd)
//
//    /// The negation of `rhs`.
//    prefix public static func - (rhs: simd_quatd) -> simd_quatd
//
//    /// The product of `lhs` and `rhs`.
//    public static func * (lhs: simd_quatd, rhs: simd_quatd) -> simd_quatd
//
//    /// The product of `lhs` and `rhs`.
//    public static func * (lhs: Double, rhs: simd_quatd) -> simd_quatd
//
//    /// The product of `lhs` and `rhs`.
//    public static func * (lhs: simd_quatd, rhs: Double) -> simd_quatd
//
//    /// Multiply `lhs` by `rhs`.
//    public static func *= (lhs: inout simd_quatd, rhs: simd_quatd)
//
//    /// Multiply `lhs` by `rhs`.
//    public static func *= (lhs: inout simd_quatd, rhs: Double)
//
//    /// The quotient of `lhs` and `rhs`.
//    public static func / (lhs: simd_quatd, rhs: simd_quatd) -> simd_quatd
//
//    /// The quotient of `lhs` and `rhs`.
//    public static func / (lhs: simd_quatd, rhs: Double) -> simd_quatd
//
//    /// Divide `lhs` by `rhs`.
//    public static func /= (lhs: inout simd_quatd, rhs: simd_quatd)
//
//    /// Divide `lhs` by `rhs`.
//    public static func /= (lhs: inout simd_quatd, rhs: Double)
}
