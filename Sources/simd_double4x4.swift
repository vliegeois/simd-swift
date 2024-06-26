//
//  simd_double4x4.swift
//
//
//  Created by Vincent LIEGEOIS on 16/06/2023.
//

//#if canImport(simd) && RELEASE
//import simd
//#else

public typealias double4x4 = simd_double4x4

public struct simd_double4x4: Equatable {
    public var columns: (simd_double4, simd_double4, simd_double4, simd_double4)

    /// Creates a matrix with zero in all columns.
    public init() {
        columns = (.zero, .zero, .zero, .zero)
    }

    public init(columns: (simd_double4, simd_double4, simd_double4, simd_double4)) {
        self.columns = columns
    }

    /// Initialize matrix to have `scalar` on main diagonal, zeros elsewhere.
    public init(_ scalar: Double) {
        columns = (.init(x: scalar, y: .zero, z: .zero, w: .zero),
                   .init(x: .zero, y: scalar, z: .zero, w: .zero),
                   .init(x: .zero, y: .zero, z: scalar, w: .zero),
                   .init(x: .zero, y: .zero, z: .zero, w: scalar))
    }

    /// Initialize matrix to have specified `diagonal`, and zeros elsewhere.
    public init(diagonal: SIMD4<Double>) {
        columns = (.init(x: diagonal.x, y: .zero, z: .zero, w: .zero),
                   .init(x: .zero, y: diagonal.y, z: .zero, w: .zero),
                   .init(x: .zero, y: .zero, z: diagonal.z, w: .zero),
                   .init(x: .zero, y: .zero, z: .zero, w: diagonal.w))
    }

    /// Initialize matrix to have specified `columns`.
    public init(_ columns: [SIMD4<Double>]) {
        var colArray = columns
        guard let col0 = colArray.safeRemoveFirst() else {
            self = .init()
            return
        }
        guard let col1 = colArray.safeRemoveFirst() else {
            self = .init(col0, .zero, .zero, .zero)
            return
        }
        guard let col2 = colArray.safeRemoveFirst() else {
            self = .init(col0, col1, .zero, .zero)
            return
        }
        guard let col3 = colArray.safeRemoveFirst() else {
            self = .init(col0, col1, col2, .zero)
            return
        }
        self.columns = (col0, col1, col2, col3)
    }

    /// Initialize matrix to have specified `rows`.
    public init(rows: [SIMD4<Double>]) {
        var rowArray = rows
        guard let row0 = rowArray.safeRemoveFirst() else {
            self = .init()
            return
        }
        guard let row1 = rowArray.safeRemoveFirst() else {
            columns = (.init(x: row0.x, y: .zero, z: .zero, w: .zero),
                       .init(x: row0.y, y: .zero, z: .zero, w: .zero),
                       .init(x: row0.z, y: .zero, z: .zero, w: .zero),
                       .init(x: row0.w, y: .zero, z: .zero, w: .zero))
            return
        }
        guard let row2 = rowArray.safeRemoveFirst() else {
            columns = (.init(x: row0.x, y: row1.x, z: .zero, w: .zero),
                       .init(x: row0.y, y: row1.y, z: .zero, w: .zero),
                       .init(x: row0.z, y: row1.z, z: .zero, w: .zero),
                       .init(x: row0.w, y: row1.w, z: .zero, w: .zero))
            return
        }
        guard let row3 = rowArray.safeRemoveFirst() else {
            columns = (.init(x: row0.x, y: row1.x, z: row2.x, w: .zero),
                       .init(x: row0.y, y: row1.y, z: row2.y, w: .zero),
                       .init(x: row0.z, y: row1.z, z: row2.z, w: .zero),
                       .init(x: row0.w, y: row1.w, z: row2.w, w: .zero))
            return
        }
        columns = (.init(x: row0.x, y: row1.x, z: row2.x, w: row3.x),
                   .init(x: row0.y, y: row1.y, z: row2.y, w: row3.y),
                   .init(x: row0.z, y: row1.z, z: row2.z, w: row3.z),
                   .init(x: row0.w, y: row1.w, z: row2.w, w: row3.w))
    }

    internal init(_ doubles: [Double]) {
        guard doubles.count >= 16 else {
            self = .init(doubles.fill(.zero, to: 16))
            return
        }
        columns = (.init(x: doubles[0], y: doubles[1], z: doubles[2], w: doubles[3]),
                   .init(x: doubles[4], y: doubles[5], z: doubles[6], w: doubles[7]),
                   .init(x: doubles[8], y: doubles[9], z: doubles[10], w: doubles[11]),
                   .init(x: doubles[12], y: doubles[13], z: doubles[14], w: doubles[15]))
    }

    /// Initialize matrix to have specified `columns`.
    public init(_ col0: SIMD4<Double>, _ col1: SIMD4<Double>, _ col2: SIMD4<Double>, _ col3: SIMD4<Double>) {
        columns = (col0, col1, col2, col3)
    }

    /// Access to individual columns.
    public subscript(column: Int) -> SIMD4<Double> {
        get {
            switch column {
            case 0: return columns.0
            case 1: return columns.1
            case 2: return columns.2
            case 3: return columns.3
            default: return .zero
            }
        }
        set {
            switch column {
            case 0: columns.0 = newValue
            case 1: columns.1 = newValue
            case 2: columns.2 = newValue
            case 3: columns.3 = newValue
            default: return
            }
        }
    }

    /// Access to individual elements.
    public subscript(column: Int, row: Int) -> Double {
        get {
            switch column {
            case 0: return columns.0[row]
            case 1: return columns.1[row]
            case 2: return columns.2[row]
            case 3: return columns.3[row]
            default: return .zero
            }
        }
        set {
            switch column {
            case 0: columns.0[row] = newValue
            case 1: columns.1[row] = newValue
            case 2: columns.2[row] = newValue
            case 3: columns.3[row] =  newValue
            default: return
            }
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
    public static func == (lhs: simd_double4x4, rhs: simd_double4x4) -> Bool {
        let lc = lhs.columns
        let rc = rhs.columns
        return lc.0.x == rc.0.x && lc.0.y == rc.0.y && lc.0.z == rc.0.z && lc.0.w == rc.0.w &&
               lc.1.x == rc.1.x && lc.1.y == rc.1.y && lc.1.z == rc.1.z && lc.1.w == rc.1.w &&
               lc.2.x == rc.2.x && lc.2.y == rc.2.y && lc.2.z == rc.2.z && lc.2.w == rc.2.w &&
               lc.3.x == rc.3.x && lc.3.y == rc.3.y && lc.3.z == rc.3.z && lc.3.w == rc.3.w
    }

    /// Sum of two matrices.
    public static func + (lhs: simd_double4x4, rhs: simd_double4x4) -> simd_double4x4 {
        let lc = lhs.columns
        let rc = rhs.columns
        let col0 = simd_double4(x: lc.0.x + rc.0.x, y: lc.0.y + rc.0.y, z: lc.0.z + rc.0.z, w: lc.0.w + rc.0.w)
        let col1 = simd_double4(x: lc.1.x + rc.1.x, y: lc.1.y + rc.1.y, z: lc.1.z + rc.1.z, w: lc.1.w + rc.1.w)
        let col2 = simd_double4(x: lc.2.x + rc.2.x, y: lc.2.y + rc.2.y, z: lc.2.z + rc.2.z, w: lc.2.w + rc.2.w)
        let col3 = simd_double4(x: lc.3.x + rc.3.x, y: lc.3.y + rc.3.y, z: lc.3.z + rc.3.z, w: lc.3.w + rc.3.w)
        return .init(col0, col1, col2, col3)
    }

    /// Negation of a matrix.
    prefix public static func - (rhs: simd_double4x4) -> simd_double4x4 {
        let rc = rhs.columns
        return .init(.init(x: -rc.0.x, y: -rc.0.y, z: -rc.0.z, w: -rc.0.w),
                     .init(x: -rc.1.x, y: -rc.1.y, z: -rc.1.z, w: -rc.1.w),
                     .init(x: -rc.2.x, y: -rc.2.y, z: -rc.2.z, w: -rc.2.w),
                     .init(x: -rc.3.x, y: -rc.3.y, z: -rc.3.z, w: -rc.3.w))
    }

    /// Difference of two matrices.
    public static func - (lhs: simd_double4x4, rhs: simd_double4x4) -> simd_double4x4 {
        let lc = lhs.columns
        let rc = rhs.columns
        let col0 = simd_double4(x: lc.0.x - rc.0.x, y: lc.0.y - rc.0.y, z: lc.0.z - rc.0.z, w: lc.0.w - rc.0.w)
        let col1 = simd_double4(x: lc.1.x - rc.1.x, y: lc.1.y - rc.1.y, z: lc.1.z - rc.1.z, w: lc.1.w - rc.1.w)
        let col2 = simd_double4(x: lc.2.x - rc.2.x, y: lc.2.y - rc.2.y, z: lc.2.z - rc.2.z, w: lc.2.w - rc.2.w)
        let col3 = simd_double4(x: lc.3.x - rc.3.x, y: lc.3.y - rc.3.y, z: lc.3.z - rc.3.z, w: lc.3.w - rc.3.w)
        return .init(col0, col1, col2, col3)
    }

    public static func += (lhs: inout simd_double4x4, rhs: simd_double4x4) {
        lhs = lhs + rhs
    }

    public static func -= (lhs: inout simd_double4x4, rhs: simd_double4x4) {
        lhs = lhs - rhs
    }

    /// Scalar-Matrix multiplication.
    public static func * (lhs: Double, rhs: simd_double4x4) -> simd_double4x4 {
        return rhs * lhs
    }

    /// Matrix-Scalar multiplication.
    public static func * (lhs: simd_double4x4, rhs: Double) -> simd_double4x4 {
        let lc = lhs.columns
        let col0 = simd_double4(x: lc.0.x * rhs, y: lc.0.y * rhs, z: lc.0.z * rhs, w: lc.0.z * rhs)
        let col1 = simd_double4(x: lc.1.x * rhs, y: lc.1.y * rhs, z: lc.1.z * rhs, w: lc.1.z * rhs)
        let col2 = simd_double4(x: lc.2.x * rhs, y: lc.2.y * rhs, z: lc.2.z * rhs, w: lc.2.z * rhs)
        let col3 = simd_double4(x: lc.3.x * rhs, y: lc.3.y * rhs, z: lc.3.z * rhs, w: lc.3.z * rhs)
        return .init(col0, col1, col2, col3)
    }

    public static func *= (lhs: inout simd_double4x4, rhs: Double) {
        lhs = lhs * rhs
    }

    /// Matrix-Vector multiplication.  Keep in mind that matrix types are named
    /// `DoubleNxM` where `N` is the number of *columns* and `M` is the number of
    /// *rows*, so we multiply a `Double3x2 * Double3` to get a `Double2`, for
    /// example.
    public static func * (lhs: simd_double4x4, rhs: SIMD4<Double>) -> SIMD4<Double> {
        return .init(x: lhs[0, 0] * rhs.x + lhs[1, 0] * rhs.y + lhs[2, 0] * rhs.z + lhs[3, 0] * rhs.w,
                     y: lhs[0, 1] * rhs.x + lhs[1, 1] * rhs.y + lhs[2, 1] * rhs.z + lhs[3, 1] * rhs.w,
                     z: lhs[0, 2] * rhs.x + lhs[1, 2] * rhs.y + lhs[2, 2] * rhs.z + lhs[3, 2] * rhs.w,
                     w: lhs[0, 3] * rhs.x + lhs[1, 3] * rhs.y + lhs[2, 3] * rhs.z + lhs[3, 3] * rhs.w)
    }

    /// Vector-Matrix multiplication.
    public static func * (lhs: SIMD4<Double>, rhs: simd_double4x4) -> SIMD4<Double> {
        return rhs * lhs
    }

    /// Matrix multiplication (the "usual" matrix product, not the elementwise
    /// product).
    public static func * (lhs: simd_double4x4, rhs: simd_double4x4) -> simd_double4x4 {
        return .init([lhs[0, 0] * rhs[0, 0] + lhs[1, 0] * rhs[0, 1] + lhs[2, 0] * rhs[0, 2] + lhs[3, 0] * rhs[0, 3],
                      lhs[0, 1] * rhs[0, 0] + lhs[1, 1] * rhs[0, 1] + lhs[2, 1] * rhs[0, 2] + lhs[3, 1] * rhs[0, 3],
                      lhs[0, 2] * rhs[0, 0] + lhs[1, 2] * rhs[0, 1] + lhs[2, 2] * rhs[0, 2] + lhs[3, 2] * rhs[0, 3],
                      lhs[0, 3] * rhs[0, 0] + lhs[1, 3] * rhs[0, 1] + lhs[2, 3] * rhs[0, 2] + lhs[3, 3] * rhs[0, 3],
                      lhs[0, 0] * rhs[1, 0] + lhs[1, 0] * rhs[1, 1] + lhs[2, 0] * rhs[1, 2] + lhs[3, 0] * rhs[1, 3],
                      lhs[0, 1] * rhs[1, 0] + lhs[1, 1] * rhs[1, 1] + lhs[2, 1] * rhs[1, 2] + lhs[3, 1] * rhs[1, 3],
                      lhs[0, 2] * rhs[1, 0] + lhs[1, 2] * rhs[1, 1] + lhs[2, 2] * rhs[1, 2] + lhs[3, 2] * rhs[1, 3],
                      lhs[0, 3] * rhs[1, 0] + lhs[1, 3] * rhs[1, 1] + lhs[2, 3] * rhs[1, 2] + lhs[3, 3] * rhs[1, 3],
                      lhs[0, 0] * rhs[2, 0] + lhs[1, 0] * rhs[2, 1] + lhs[2, 0] * rhs[2, 2] + lhs[3, 0] * rhs[2, 3],
                      lhs[0, 1] * rhs[2, 0] + lhs[1, 1] * rhs[2, 1] + lhs[2, 1] * rhs[2, 2] + lhs[3, 1] * rhs[2, 3],
                      lhs[0, 2] * rhs[2, 0] + lhs[1, 2] * rhs[2, 1] + lhs[2, 2] * rhs[2, 2] + lhs[3, 2] * rhs[2, 3],
                      lhs[0, 3] * rhs[2, 0] + lhs[1, 3] * rhs[2, 1] + lhs[2, 3] * rhs[2, 2] + lhs[3, 3] * rhs[2, 3],
                      lhs[0, 0] * rhs[3, 0] + lhs[1, 0] * rhs[3, 1] + lhs[2, 0] * rhs[3, 2] + lhs[3, 0] * rhs[3, 3],
                      lhs[0, 1] * rhs[3, 0] + lhs[1, 1] * rhs[3, 1] + lhs[2, 1] * rhs[3, 2] + lhs[3, 1] * rhs[3, 3],
                      lhs[0, 2] * rhs[3, 0] + lhs[1, 2] * rhs[3, 1] + lhs[2, 2] * rhs[3, 2] + lhs[3, 2] * rhs[3, 3],
                      lhs[0, 3] * rhs[3, 0] + lhs[1, 3] * rhs[3, 1] + lhs[2, 3] * rhs[3, 2] + lhs[3, 3] * rhs[3, 3]])
    }

    /// Matrix multiplication (the "usual" matrix product, not the elementwise
    /// product).
    public static func *= (lhs: inout simd_double4x4, rhs: simd_double4x4) {
        lhs = lhs * rhs
    }
}

//#endif
