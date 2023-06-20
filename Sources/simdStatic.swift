//
//  simdStatic.swift
//  
//
//  Created by Damien Noël Dubuisson on 05/10/2021.
//

//#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//import Darwin
//#elseif os(Linux)
//import Glibc
//#elseif os(Windows)
//import ucrt
//#endif

import Numerics

// Will define all static helpers for simd

// MARK: - Double/Float
extension SIMD3 where Scalar: Real {
    public func squareRoot() -> SIMD3<Scalar> {
        .init(x: Scalar.sqrt(x), y: Scalar.sqrt(y), z: Scalar.sqrt(z))
    }
}
extension SIMD4 where Scalar: Real {
    public func squareRoot() -> SIMD4<Scalar> {
        .init(x: Scalar.sqrt(x), y: Scalar.sqrt(y), z: Scalar.sqrt(z), w: Scalar.sqrt(w))
    }
}
/// Reciprocal square root.
public func rsqrt<T: Real>(_ x: T) -> T { return T(1) / T.sqrt(x) }

///// Reciprocal square root.
//public func rsqrt(_ x: Float) -> Float { return 1.0 / sqrt(x) }

// MARK: - simd_double3/simd_float3
public func length_squared<T: Real>(_ __x: SIMD3<T>) -> T {simd_length_squared(__x)}
public func simd_length_squared<T>(_ __x: SIMD3<T>) -> T {
    return __x.x*__x.x + __x.y*__x.y + __x.z*__x.z
}

public func length<T: Real>(_ __x: SIMD3<T>) -> T {simd_length(__x)}
public func simd_length<T: Real>(_ __x: SIMD3<T>) -> T {
    return T.sqrt(simd_length_squared(__x))
}

public func normalize<T: Real>(_ __x: SIMD3<T>) -> SIMD3<T> {simd_normalize(__x)}
public func simd_normalize<T: Real>(_ __x: SIMD3<T>) -> SIMD3<T> {
    let magnitude = simd_length(__x)
    return .init(__x.x / magnitude, __x.y / magnitude, __x.z / magnitude)
}

public func cross<T: Real>(_ __x: SIMD3<T>, _ __y: SIMD3<T>) -> SIMD3<T> { simd_cross(__x, __y)}
public func simd_cross<T: Real>(_ __x: SIMD3<T>, _ __y: SIMD3<T>) -> SIMD3<T> {
    return SIMD3<T>(__x.y*__y.z - __x.z*__y.y,
                 __x.z*__y.x - __x.x*__y.z,
                 __x.x*__y.y - __x.y*__y.x)
}

// MARK: - simd_double4/simd_float4
public func length_squared<T: Real>(_ __x: SIMD4<T>) -> T {simd_length_squared(__x)}
public func simd_length_squared<T: Real>(_ __x: SIMD4<T>) -> T {
    return __x.x*__x.x + __x.y*__x.y + __x.z*__x.z + __x.w*__x.w
}
public func length<T: Real>(_ __x: SIMD4<T>) -> T {simd_length(__x)}
public func simd_length<T: Real>(_ __x: SIMD4<T>) -> T {
    return T.sqrt(simd_length_squared(__x))
}
public func normalize<T: Real>(_ __x: SIMD4<T>) -> SIMD4<T> {simd_normalize(__x)}
public func simd_normalize<T: Real>(_ __x: SIMD4<T>) -> SIMD4<T> {
    let magnitude = simd_length(__x)
    return .init(__x.x / magnitude, __x.y / magnitude, __x.z / magnitude, __x.w / magnitude)
}

// MARK: - dot
/// Dot product of `x` and `y`.
public func dot<T: Real>(_ __x: SIMD3<T>, _ __y: SIMD3<T>) -> T {
    __x.x*__y.x + __x.y*__y.y + __x.z*__y.z
}
/// Dot product of `x` and `y`.
public func dot<T: Real>(_ __x: SIMD4<T>, _ __y: SIMD4<T>) -> T {
    __x.x*__y.x + __x.y*__y.y + __x.z*__y.z + __x.w*__y.w
}


// MARK: - project
/// Projection of `x` onto `y`.
public func project<T: Real>(_ __x: SIMD3<T>, _ __y: SIMD3<T>) -> SIMD3<T> {simd_project(__x, __y)}
/// Projection of `x` onto `y`.
public func simd_project<T: Real>(_ __x: SIMD3<T>, _ __y: SIMD3<T>) -> SIMD3<T> {
    let n = simd_normalize(__y)
    return dot(__x, n) * n
}
/// Projection of `x` onto `y`.
public func project<T: Real>(_ __x: SIMD4<T>, _ __y: SIMD4<T>) -> SIMD4<T> {simd_project(__x, __y)}
/// Projection of `x` onto `y`.
public func simd_project<T: Real>(_ __x: SIMD4<T>, _ __y: SIMD4<T>) -> SIMD4<T> {
    let n = simd_normalize(__y)
    return dot(__x, n) * n
}

// MARK: - reflect
/// Reflects x through the plane perpendicular to the normal vector n.
///
/// `x` reflected through the hyperplane with unit normal vector `n`, passing
/// through the origin.  E.g. if `x` is [1,2,3] and `n` is [0,0,1], the result
/// is [1,2,-3].
public func reflect<T: Real>(_ x: SIMD3<T>, n: SIMD3<T>) -> SIMD3<T> {
    simd_reflect(x, n)
}
/// Reflects x through the plane perpendicular to the normal vector n.
///
/// `x` reflected through the hyperplane with unit normal vector `n`, passing
/// through the origin.  E.g. if `x` is [1,2,3] and `n` is [0,0,1], the result
/// is [1,2,-3].
public func simd_reflect<T: Real>(_ __x: SIMD3<T>, _ __n: SIMD3<T>) -> SIMD3<T> {
    return __x - 2 * dot(__x, __n) * __n
}

/// Reflects x through the plane perpendicular to the normal vector n.
///
/// `x` reflected through the hyperplane with unit normal vector `n`, passing
/// through the origin.  E.g. if `x` is [1,2,3] and `n` is [0,0,1], the result
/// is [1,2,-3].
public func reflect<T: Real>(_ x: SIMD4<T>, n: SIMD4<T>) -> SIMD4<T> {
    simd_reflect(x, n)
}
/// Reflects x through the plane perpendicular to the normal vector n.
///
/// `x` reflected through the hyperplane with unit normal vector `n`, passing
/// through the origin.  E.g. if `x` is [1,2,3] and `n` is [0,0,1], the result
/// is [1,2,-3].
public func simd_reflect<T: Real>(_ __x: SIMD4<T>, _ __n: SIMD4<T>) -> SIMD4<T> {
    return __x - 2 * dot(__x, __n) * __n
}

// MARK: - distance

/// Distance between `x` and `y`.
public func distance<T: Real>(_ x: SIMD3<T>, _ y: SIMD3<T>) -> T {
    T.sqrt(distance_squared(x, y))
}
/// Distance between `x` and `y`, squared.
public func distance_squared<T: Real>(_ x: SIMD3<T>, _ y: SIMD3<T>) -> T {
    simd_length_squared(x-y)
}

/// Distance between `x` and `y`.
public func distance<T: Real>(_ x: SIMD4<T>, _ y: SIMD4<T>) -> T {
    T.sqrt(distance_squared(x, y))
}
/// Distance between `x` and `y`, squared.
public func distance_squared<T: Real>(_ x: SIMD4<T>, _ y: SIMD4<T>) -> T {
    simd_length_squared(x-y)
}

// MARK: Min/Max

/// Elementwise maximum of two vectors.  Each component of the result is the
/// larger of the corresponding component of the inputs.
public func max<T: Real>(_ x: SIMD3<T>, _ y: SIMD3<T>) -> SIMD3<T> {
    .init(x: max(x.x, y.x), y: max(x.y, y.y), z: max(x.z, y.z))
}
/// Vector-scalar maximum.  Each component of the result is the maximum of the
/// corresponding element of the input vector and the scalar.
public func max<T: Real>(_ x: SIMD3<T>, _ scalar: T) -> SIMD3<T> {
    .init(x: max(x.x, scalar), y: max(x.y, scalar), z: max(x.z, scalar))
}
/// Elementwise maximum of two vectors.  Each component of the result is the
/// larger of the corresponding component of the inputs.
public func max<T: Real>(_ x: SIMD4<T>, _ y: SIMD4<T>) -> SIMD4<T> {
    .init(x: max(x.x, y.x), y: max(x.y, y.y), z: max(x.z, y.z), w: max(x.w, y.w))
}
/// Vector-scalar maximum.  Each component of the result is the maximum of the
/// corresponding element of the input vector and the scalar.
public func max<T: Real>(_ x: SIMD4<T>, _ scalar: T) -> SIMD4<T> {
    .init(x: max(x.x, scalar), y: max(x.y, scalar), z: max(x.z, scalar), w: max(x.w, scalar))
}

/// Elementwise minimum of two vectors.  Each component of the result is the
/// smaller of the corresponding component of the inputs.
public func min<T: Real>(_ x: SIMD3<T>, _ y: SIMD3<T>) -> SIMD3<T> {
    .init(x: min(x.x, y.x), y: min(x.y, y.y), z: min(x.z, y.z))
}
/// Vector-scalar minimum.  Each component of the result is the minimum of the
/// corresponding element of the input vector and the scalar.
public func min<T: Real>(_ x: SIMD3<T>, _ scalar: T) -> SIMD3<T> {
    .init(x: min(x.x, scalar), y: min(x.y, scalar), z: min(x.z, scalar))
}
/// Elementwise minimum of two vectors.  Each component of the result is the
/// smaller of the corresponding component of the inputs.
public func min<T: Real>(_ x: SIMD4<T>, _ y: SIMD4<T>) -> SIMD4<T> {
    .init(x: min(x.x, y.x), y: min(x.y, y.y), z: min(x.z, y.z), w: min(x.w, y.w))
}
/// Vector-scalar minimum.  Each component of the result is the minimum of the
/// corresponding element of the input vector and the scalar.
public func min<T: Real>(_ x: SIMD4<T>, _ scalar: T) -> SIMD4<T> {
    .init(x: min(x.x, scalar), y: min(x.y, scalar), z: min(x.z, scalar), w: min(x.w, scalar))
}


// MARK: abs
public func abs<T: Real>(_ v: SIMD3<T>) -> SIMD3<T> {
    .init(x: abs(v.x), y: abs(v.y), z: abs(v.z))
}
public func abs<T: Real>(_ v: SIMD4<T>) -> SIMD4<T> {
    .init(x: abs(v.x), y: abs(v.y), z: abs(v.z), w: abs(v.w))
}

// MARK: floor, ceil, trunc
public func floor<T: Real>(_ v: SIMD3<T>) -> SIMD3<T> {
    v.rounded(.down)
}
public func ceil<T: Real>(_ v: SIMD3<T>) -> SIMD3<T> {
    v.rounded(.up)
}
public func trunc<T: Real>(_ v: SIMD3<T>) -> SIMD3<T> {
    v.rounded(.towardZero)
}


public func floor<T: Real>(_ v: SIMD4<T>) -> SIMD4<T> {
    v.rounded(.down)
}
public func ceil<T: Real>(_ v: SIMD4<T>) -> SIMD4<T> {
    v.rounded(.up)
}
public func trunc<T: Real>(_ v: SIMD4<T>) -> SIMD4<T> {
    v.rounded(.towardZero)
}
