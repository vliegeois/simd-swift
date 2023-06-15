//
//  simd_double3x3.swift
//  
//
//  Created by Damien Noël Dubuisson on 04/10/2021.
//

//#if canImport(simd) && RELEASE
//import simd
//#else

public struct simd_double3x3: Equatable {
    public var columns: (simd_double3, simd_double3, simd_double3)

    /// Creates a matrix with zero in all columns.
    public init() {
        columns = (.zero, .zero, .zero)
    }

    public init(columns: (simd_double3, simd_double3, simd_double3)) {
        self.columns = columns
    }

    /// Initialize matrix to have `scalar` on main diagonal, zeros elsewhere.
    public init(_ scalar: Double) {
        columns = (.init(x: scalar, y: .zero, z: .zero),
                   .init(x: .zero, y: scalar, z: .zero),
                   .init(x: .zero, y: .zero, z: scalar))
    }

    /// Initialize matrix to have specified `diagonal`, and zeros elsewhere.
    public init(diagonal: SIMD3<Double>) {
        columns = (.init(x: diagonal.x, y: .zero, z: .zero),
                   .init(x: .zero, y: diagonal.y, z: .zero),
                   .init(x: .zero, y: .zero, z: diagonal.z))
    }

    /// Initialize matrix to have specified `columns`.
    public init(_ columns: [SIMD3<Double>]) {
        var colArray = columns
        guard let col0 = colArray.safeRemoveFirst() else {
            self = .init()
            return
        }
        guard let col1 = colArray.safeRemoveFirst() else {
            self = .init(col0, .zero, .zero)
            return
        }
        guard let col2 = colArray.safeRemoveFirst() else {
            self = .init(col0, col1, .zero)
            return
        }
        self.columns = (col0, col1, col2)
    }

    /// Initialize matrix to have specified `rows`.
    public init(rows: [SIMD3<Double>]) {
        var rowArray = rows
        guard let row0 = rowArray.safeRemoveFirst() else {
            self = .init()
            return
        }
        guard let row1 = rowArray.safeRemoveFirst() else {
            columns = (.init(x: row0.x, y: .zero, z: .zero),
                       .init(x: row0.y, y: .zero, z: .zero),
                       .init(x: row0.z, y: .zero, z: .zero))
            return
        }
        guard let row2 = rowArray.safeRemoveFirst() else {
            columns = (.init(x: row0.x, y: row1.x, z: .zero),
                       .init(x: row0.y, y: row1.y, z: .zero),
                       .init(x: row0.z, y: row1.z, z: .zero))
            return
        }
        columns = (.init(x: row0.x, y: row1.x, z: row2.x),
                   .init(x: row0.y, y: row1.y, z: row2.y),
                   .init(x: row0.z, y: row1.z, z: row2.z))
    }

    internal init(_ doubles: [Double]) {
        guard doubles.count >= 9 else {
            self = .init(doubles.fill(.zero, to: 9))
            return
        }
        columns = (.init(x: doubles[0], y: doubles[1], z: doubles[2]),
                   .init(x: doubles[3], y: doubles[4], z: doubles[5]),
                   .init(x: doubles[6], y: doubles[7], z: doubles[8]))
    }

    /// Initialize matrix to have specified `columns`.
    public init(_ col0: SIMD3<Double>, _ col1: SIMD3<Double>, _ col2: SIMD3<Double>) {
        columns = (col0, col1, col2)
    }

    /// Access to individual columns.
    public subscript(column: Int) -> SIMD3<Double> {
        switch column {
        case 0: return columns.0
        case 1: return columns.1
        case 2: return columns.2
        default: return .zero
        }
    }

    /// Access to individual elements.
    public subscript(column: Int, row: Int) -> Double {
        switch column {
        case 0: return columns.0[row]
        case 1: return columns.1[row]
        case 2: return columns.2[row]
        default: return .zero
        }
    }

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: simd_double3x3, rhs: simd_double3x3) -> Bool {
        let lc = lhs.columns
        let rc = rhs.columns
        return lc.0.x == rc.0.x && lc.0.y == rc.0.y && lc.0.z == rc.0.z &&
               lc.1.x == rc.1.x && lc.1.y == rc.1.y && lc.1.z == rc.1.z &&
               lc.2.x == rc.2.x && lc.2.y == rc.2.y && lc.2.z == rc.2.z
    }

    /// Sum of two matrices.
    public static func + (lhs: simd_double3x3, rhs: simd_double3x3) -> simd_double3x3 {
        let lc = lhs.columns
        let rc = rhs.columns
        let col0 = simd_double3(x: lc.0.x + rc.0.x, y: lc.0.y + rc.0.y, z: lc.0.z + rc.0.z)
        let col1 = simd_double3(x: lc.1.x + rc.1.x, y: lc.1.y + rc.1.y, z: lc.1.z + rc.1.z)
        let col2 = simd_double3(x: lc.2.x + rc.2.x, y: lc.2.y + rc.2.y, z: lc.2.z + rc.2.z)
        return .init(col0, col1, col2)
    }

    /// Negation of a matrix.
    prefix public static func - (rhs: simd_double3x3) -> simd_double3x3 {
        let rc = rhs.columns
        return .init(.init(x: -rc.0.x, y: -rc.0.y, z: -rc.0.z),
                     .init(x: -rc.1.x, y: -rc.1.y, z: -rc.1.z),
                     .init(x: -rc.2.x, y: -rc.2.y, z: -rc.2.z))
    }

    /// Difference of two matrices.
    public static func - (lhs: simd_double3x3, rhs: simd_double3x3) -> simd_double3x3 {
        let lc = lhs.columns
        let rc = rhs.columns
        let col0 = simd_double3(x: lc.0.x - rc.0.x, y: lc.0.y - rc.0.y, z: lc.0.z - rc.0.z)
        let col1 = simd_double3(x: lc.1.x - rc.1.x, y: lc.1.y - rc.1.y, z: lc.1.z - rc.1.z)
        let col2 = simd_double3(x: lc.2.x - rc.2.x, y: lc.2.y - rc.2.y, z: lc.2.z - rc.2.z)
        return .init(col0, col1, col2)
    }

    public static func += (lhs: inout simd_double3x3, rhs: simd_double3x3) {
        lhs = lhs + rhs
    }

    public static func -= (lhs: inout simd_double3x3, rhs: simd_double3x3) {
        lhs = lhs - rhs
    }

    /// Scalar-Matrix multiplication.
    public static func * (lhs: Double, rhs: simd_double3x3) -> simd_double3x3 {
        return rhs * lhs
    }

    /// Matrix-Scalar multiplication.
    public static func * (lhs: simd_double3x3, rhs: Double) -> simd_double3x3 {
        let lc = lhs.columns
        let col0 = simd_double3(x: lc.0.x * rhs, y: lc.0.y * rhs, z: lc.0.z * rhs)
        let col1 = simd_double3(x: lc.1.x * rhs, y: lc.1.y * rhs, z: lc.1.z * rhs)
        let col2 = simd_double3(x: lc.2.x * rhs, y: lc.2.y * rhs, z: lc.2.z * rhs)
        return .init(col0, col1, col2)
    }

    public static func *= (lhs: inout simd_double3x3, rhs: Double) {
        lhs = lhs * rhs
    }

    /// Matrix-Vector multiplication.  Keep in mind that matrix types are named
    /// `DoubleNxM` where `N` is the number of *columns* and `M` is the number of
    /// *rows*, so we multiply a `Double3x2 * Double3` to get a `Double2`, for
    /// example.
    public static func * (lhs: simd_double3x3, rhs: SIMD3<Double>) -> SIMD3<Double> {
        return .init(x: lhs[0, 0] * rhs.x + lhs[1, 0] * rhs.y + lhs[2, 0] * rhs.z,
                     y: lhs[0, 1] * rhs.x + lhs[1, 1] * rhs.y + lhs[2, 1] * rhs.z,
                     z: lhs[0, 2] * rhs.x + lhs[1, 2] * rhs.y + lhs[2, 2] * rhs.z)
    }

    /// Vector-Matrix multiplication.
    public static func * (lhs: SIMD3<Double>, rhs: simd_double3x3) -> SIMD3<Double> {
        return rhs * lhs
    }

    /// Matrix multiplication (the "usual" matrix product, not the elementwise
    /// product).
    public static func * (lhs: simd_double3x3, rhs: simd_double3x3) -> simd_double3x3 {
        return .init([lhs[0, 0] * rhs[0, 0] + lhs[1, 0] * rhs[0, 1] + lhs[2, 0] * rhs[0, 2],
                      lhs[0, 0] * rhs[1, 0] + lhs[1, 0] * rhs[1, 1] + lhs[2, 0] * rhs[1, 2],
                      lhs[0, 0] * rhs[2, 0] + lhs[1, 0] * rhs[2, 1] + lhs[2, 0] * rhs[2, 2],
                      lhs[0, 1] * rhs[0, 0] + lhs[1, 1] * rhs[0, 1] + lhs[2, 1] * rhs[0, 2],
                      lhs[0, 1] * rhs[1, 0] + lhs[1, 1] * rhs[1, 1] + lhs[2, 1] * rhs[1, 2],
                      lhs[0, 1] * rhs[2, 0] + lhs[1, 1] * rhs[2, 1] + lhs[2, 1] * rhs[2, 2],
                      lhs[0, 2] * rhs[0, 0] + lhs[1, 2] * rhs[0, 1] + lhs[2, 2] * rhs[0, 2],
                      lhs[0, 2] * rhs[1, 0] + lhs[1, 2] * rhs[1, 1] + lhs[2, 2] * rhs[1, 2],
                      lhs[0, 2] * rhs[2, 0] + lhs[1, 2] * rhs[2, 1] + lhs[2, 2] * rhs[2, 2]])
    }

    /// Matrix multiplication (the "usual" matrix product, not the elementwise
    /// product).
    public static func *= (lhs: inout simd_double3x3, rhs: simd_double3x3) {
        lhs = lhs * rhs
    }
}

//#endif
