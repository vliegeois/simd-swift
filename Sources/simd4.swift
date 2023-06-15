//
//  simd4.swift
//  
//
//  Created by Damien Noël Dubuisson on 04/10/2021.
//

//#if canImport(simd)
//import simd
//#else

public typealias simd_double4 = SIMD4<Double>
public typealias simd_float4 = SIMD4<Float>

public struct SIMD4<Scalar>: Equatable where Scalar : FloatingPoint {
    /// The number of scalars in the vector.
    public let scalarCount: Int = 4

    /// Accesses the scalar at the specified position.
    public subscript(index: Int) -> Scalar {
        get {
            switch index {
            case 0: return x
            case 1: return y
            case 2: return z
            case 3: return w
            default: return .zero
            }
        }
        set {
            switch index {
            case 0: x = newValue
            case 1: y = newValue
            case 2: z = newValue
            case 3: w = newValue
            default: return
            }
        }
    }
    
    /// Creates a vector with zero in all lanes.
    public init() {
        x = .zero
        y = .zero
        z = .zero
        w = .zero
    }

    /// Creates a new vector from the given elements.
    public init(_ v0: Scalar, _ v1: Scalar, _ v2: Scalar, _ v3: Scalar) {
        x = v0
        y = v1
        z = v2
        w = v3
    }

    /// Creates a new vector from the given elements.
    ///
    /// - Parameters:
    ///   - x: The first element of the vector.
    ///   - y: The second element of the vector.
    ///   - z: The third element of the vector.
    ///   - w: The fourth element of the vector.
    public init(x: Scalar, y: Scalar, z: Scalar, w: Scalar) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }

    /// A four-element vector created by appending a scalar to a three-element vector.
    public init(_ xyz: SIMD3<Scalar>, _ w: Scalar) {
        x = xyz.x
        y = xyz.y
        z = xyz.z
        self.w = w
    }

    /// The first element of the vector.
    public var x: Scalar

    /// The second element of the vector.
    public var y: Scalar

    /// The third element of the vector.
    public var z: Scalar

    /// The fourth element of the vector.
    public var w: Scalar

    /// A vector with zero in all lanes.
    public static var zero: Self { .init() }
    /// A vector with one in all lanes.
    public static var one: Self { .init(x: .one, y: .one, z: .one, w: .one) }

    // MARK: - Min/Max

    /// The least element in the vector.
    public func min() -> Scalar { return Swift.min(x, y, z, w) }
    /// The greatest element in the vector.
    public func max() -> Scalar { return Swift.max(x, y, z, w) }

    // MARK: - Negative

    prefix public static func - (rhs: Self) -> Self {
        return .init(x: -rhs.x, y: -rhs.y, z: -rhs.z, w: -rhs.w)
    }

    // MARK: - Scalar

    public static func + (lhs: Scalar, rhs: Self) -> Self {
        return .init(x: lhs + rhs.x, y: lhs + rhs.y, z: lhs + rhs.z, w: lhs + rhs.w)
    }
    public static func - (lhs: Scalar, rhs: Self) -> Self {
        return .init(x: lhs - rhs.x, y: lhs - rhs.y, z: lhs - rhs.z, w: lhs - rhs.w)
    }
    public static func * (lhs: Scalar, rhs: Self) -> Self {
        return .init(x: lhs * rhs.x, y: lhs * rhs.y, z: lhs * rhs.z, w: lhs * rhs.w)
    }
    public static func / (lhs: Scalar, rhs: Self) -> Self {
        return .init(x: lhs / rhs.x, y: lhs / rhs.y, z: lhs / rhs.z, w: lhs / rhs.w)
    }

    public static func + (lhs: Self, rhs: Scalar) -> Self {
        return .init(x: lhs.x + rhs, y: lhs.y + rhs, z: lhs.z + rhs, w: lhs.w + rhs)
    }
    public static func - (lhs: Self, rhs: Scalar) -> Self {
        return .init(x: lhs.x - rhs, y: lhs.y - rhs, z: lhs.z - rhs, w: lhs.w - rhs)
    }
    public static func * (lhs: Self, rhs: Scalar) -> Self {
        return .init(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs, w: lhs.w * rhs)
    }
    public static func / (lhs: Self, rhs: Scalar) -> Self {
        return .init(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs, w: lhs.w / rhs)
    }

    // MARK: - Self's Operation

    /// Returns a Boolean value indicating whether two vectors are equal.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z && lhs.w == rhs.w
    }

    public static func + (lhs: Self, rhs: Self) -> Self {
        return .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z, w: lhs.w + rhs.w)
    }
    public static func - (lhs: Self, rhs: Self) -> Self {
        return .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z, w: lhs.w - rhs.w)
    }
    public static func * (lhs: Self, rhs: Self) -> Self {
        return .init(x: lhs.x * rhs.x, y: lhs.y * rhs.y, z: lhs.z * rhs.z, w: lhs.w * rhs.w)
    }
    public static func / (lhs: Self, rhs: Self) -> Self {
        return .init(x: lhs.x / rhs.x, y: lhs.y / rhs.y, z: lhs.z / rhs.z, w: lhs.w / rhs.w)
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
