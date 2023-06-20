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

public struct SIMD3<Scalar>: SIMD where Scalar : SIMDScalar {
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

    /// A vector with the specified value in all lanes.
    public init(repeating value: Scalar) {
        self.init(x: value, y: value, z: value)
    }
    
    /// Creates a vector from the given sequence.
    ///
    /// - Precondition: `scalars` must have the same number of elements as the
    ///   vector type.
    ///
    /// - Parameter scalars: The elements to use in the vector.
    public init(_ scalars: Array<Scalar>) {
        var values = scalars
        guard let val0 = values.safeRemoveFirst() else {
            self = .init()
            return
        }
        guard let val1 = values.safeRemoveFirst() else {
            self.init(x: val0, y: .zero, z: .zero)
            return
        }
        guard let val2 = values.safeRemoveFirst() else {
            self.init(x: val0, y: val1, z: .zero)
            return
        }
        self.init(x: val0, y: val1, z: val2)
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

extension SIMD3 where Scalar: BinaryFloatingPoint {
    /// Creates a vector from another one
    public init<T: BinaryFloatingPoint>(_ v: SIMD3<T>) {
        x = Scalar(v.x)
        y = Scalar(v.y)
        z = Scalar(v.z)
    }
}

extension SIMD3 where Scalar: FloatingPoint {
    /// A vector formed by rounding each lane of the source vector to an integral
    /// value according to the specified rounding `rule`.
    public func rounded(_ rule: FloatingPointRoundingRule) -> SIMD3<Scalar> {
        .init(x: x.rounded(rule), y: y.rounded(rule), z: z.rounded(rule))
    }
}

extension SIMD3 where Scalar == Double {
    /// Returns a vector with random values from within the specified range in
    /// all lanes.
    @inlinable public static func random(in range: Range<Scalar>) -> Self {
        .init(x: Scalar.random(in: range), y: Scalar.random(in: range), z: Scalar.random(in: range))
    }

    /// Returns a vector with random values from within the specified range in
    /// all lanes.
    @inlinable public static func random(in range: ClosedRange<Scalar>) -> Self {
        .init(x: Scalar.random(in: range), y: Scalar.random(in: range), z: Scalar.random(in: range))
    }
}

extension SIMD3 where Scalar == Float {
    /// Returns a vector with random values from within the specified range in
    /// all lanes.
    @inlinable public static func random(in range: Range<Scalar>) -> Self {
        .init(x: Scalar.random(in: range), y: Scalar.random(in: range), z: Scalar.random(in: range))
    }

    /// Returns a vector with random values from within the specified range in
    /// all lanes.
    @inlinable public static func random(in range: ClosedRange<Scalar>) -> Self {
        .init(x: Scalar.random(in: range), y: Scalar.random(in: range), z: Scalar.random(in: range))
    }
}

//#endif
