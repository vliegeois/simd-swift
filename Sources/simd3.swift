//
//  simd3.swift
//  
//
//  Created by Damien Noël Dubuisson on 04/10/2021.
//

//#if canImport(simd) && RELEASE
//import simd
//#else

public typealias simd_double3 = SIMD3<Double>
public typealias simd_float3 = SIMD3<Float>

public struct SIMD3<Scalar>: Equatable where Scalar : FloatingPoint {
    /// The number of scalars in the vector.
    public let scalarCount: Int = 3

    /// Accesses the scalar at the specified position.
    public subscript(index: Int) -> Scalar {
        get {
            switch index {
            case 0: return x
            case 1: return y
            case 2: return z
            default: return .zero
            }
        }
        set {
            switch index {
            case 0: x = newValue
            case 1: y = newValue
            case 2: z = newValue
            default: return
            }
        }
    }

    /// Creates a vector with zero in all lanes.
    public init() {
        x = .zero
        y = .zero
        z = .zero
    }

    /// Creates a new vector from the given elements.
    public init(_ v0: Scalar, _ v1: Scalar, _ v2: Scalar) {
        x = v0
        y = v1
        z = v2
    }

    /// Creates a new vector from the given elements.
    ///
    /// - Parameters:
    ///   - x: The first element of the vector.
    ///   - y: The second element of the vector.
    ///   - z: The third element of the vector.
    public init(x: Scalar, y: Scalar, z: Scalar) {
        self.x = x
        self.y = y
        self.z = z
    }

    /// The first element of the vector.
    public var x: Scalar

    /// The second element of the vector.
    public var y: Scalar

    /// The third element of the vector.
    public var z: Scalar

    /// A vector with zero in all lanes.
    public static var zero: Self { .init() }
    /// A vector with one in all lanes.
    public static var one: Self { .init(x: .one, y: .one, z: .one) }

    // MARK: - Min/Max/Sum

    /// The least element in the vector.
    public func min() -> Scalar { return Swift.min(x, y, z) }
    /// The greatest element in the vector.
    public func max() -> Scalar { return Swift.max(x, y, z) }
    /// Returns the sum of the scalars in the vector.
    public func sum() -> Scalar { return x + y + z }

    // MARK: - Negative

    prefix public static func - (rhs: Self) -> Self {
        return .init(x: -rhs.x, y: -rhs.y, z: -rhs.z)
    }

    // MARK: - Scalar

    public static func + (lhs: Scalar, rhs: Self) -> Self {
        return .init(x: lhs + rhs.x, y: lhs + rhs.y, z: lhs + rhs.z)
    }
    public static func - (lhs: Scalar, rhs: Self) -> Self {
        return .init(x: lhs - rhs.x, y: lhs - rhs.y, z: lhs - rhs.z)
    }
    public static func * (lhs: Scalar, rhs: Self) -> Self {
        return .init(x: lhs * rhs.x, y: lhs * rhs.y, z: lhs * rhs.z)
    }
    public static func / (lhs: Scalar, rhs: Self) -> Self {
        return .init(x: lhs / rhs.x, y: lhs / rhs.y, z: lhs / rhs.z)
    }

    public static func + (lhs: Self, rhs: Scalar) -> Self {
        return .init(x: lhs.x + rhs, y: lhs.y + rhs, z: lhs.z + rhs)
    }
    public static func - (lhs: Self, rhs: Scalar) -> Self {
        return .init(x: lhs.x - rhs, y: lhs.y - rhs, z: lhs.z - rhs)
    }
    public static func * (lhs: Self, rhs: Scalar) -> Self {
        return .init(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
    }
    public static func / (lhs: Self, rhs: Scalar) -> Self {
        return .init(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs)
    }

    // MARK: - Self's Operation

    /// Returns a Boolean value indicating whether two vectors are equal.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }

    public static func + (lhs: Self, rhs: Self) -> Self {
        return .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
    public static func - (lhs: Self, rhs: Self) -> Self {
        return .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
    public static func * (lhs: Self, rhs: Self) -> Self {
        return .init(x: lhs.x * rhs.x, y: lhs.y * rhs.y, z: lhs.z * rhs.z)
    }
    public static func / (lhs: Self, rhs: Self) -> Self {
        return .init(x: lhs.x / rhs.x, y: lhs.y / rhs.y, z: lhs.z / rhs.z)
    }

    public static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    public static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }

    public static func += (lhs: inout Self, rhs: Scalar) {
        lhs = lhs + rhs
    }
    public static func -= (lhs: inout Self, rhs: Scalar) {
        lhs = lhs - rhs
    }
    public static func *= (lhs: inout Self, rhs: Scalar) {
        lhs = lhs * rhs
    }
    public static func /= (lhs: inout Self, rhs: Scalar) {
        lhs = lhs / rhs
    }
}

//#endif
