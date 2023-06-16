//
//  simdStatic.swift
//  
//
//  Created by Damien Noël Dubuisson on 05/10/2021.
//

#if os(macOS) || os(iOS)
import Darwin
#elseif os(Linux) || CYGWIN
import Glibc
#endif

// Will define all static helpers for simd

// MARK: - Double/Float
/// Reciprocal square root.
public func rsqrt(_ x: Double) -> Double { return 1.0 / sqrt(x) }

/// Reciprocal square root.
public func rsqrt(_ x: Float) -> Float { return 1.0 / sqrt(x) }

// MARK: - simd_double3
public func length_squared(_ __x: simd_double3) -> Double {simd_length_squared(__x)}
public func simd_length_squared(_ __x: simd_double3) -> Double {
    return __x.x*__x.x + __x.y*__x.y + __x.z*__x.z
}

public func length(_ __x: simd_double3) -> Double {simd_length(__x)}
public func simd_length(_ __x: simd_double3) -> Double {
    return sqrt(simd_length_squared(__x))
}

public func normalize(_ __x: simd_double3) -> simd_double3 {simd_normalize(__x)}
public func simd_normalize(_ __x: simd_double3) -> simd_double3 {
    let magnitude = simd_length(__x)
    return .init(__x.x / magnitude, __x.y / magnitude, __x.z / magnitude)
}

public func cross(_ __x: simd_double3, _ __y: simd_double3) -> simd_double3 { simd_cross(__x, __y)}
public func simd_cross(_ __x: simd_double3, _ __y: simd_double3) -> simd_double3 {
    return .init(__x.y*__y.z - __x.z*__y.y,
                 __x.z*__y.x - __x.x*__y.z,
                 __x.x*__y.y - __x.y*__y.x)
}

// MARK: - simd_float3
public func length_squared(_ __x: simd_float3) -> Float {simd_length_squared(__x)}
public func simd_length_squared(_ __x: simd_float3) -> Float {
    return __x.x*__x.x + __x.y*__x.y + __x.z*__x.z
}

public func length(_ __x: simd_float3) -> Float {simd_length(__x)}
public func simd_length(_ __x: simd_float3) -> Float {
    return sqrt(simd_length_squared(__x))
}

public func normalize(_ __x: simd_float3) -> simd_float3 {simd_normalize(__x)}
public func simd_normalize(_ __x: simd_float3) -> simd_float3 {
    let magnitude = simd_length(__x)
    return .init(__x.x / magnitude, __x.y / magnitude, __x.z / magnitude)
}

public func cross(_ __x: simd_float3, _ __y: simd_float3) -> simd_float3 { simd_cross(__x, __y)}
public func simd_cross(_ __x: simd_float3, _ __y: simd_float3) -> simd_float3 {
    return .init(__x.y*__y.z - __x.z*__y.y,
                 __x.z*__y.x - __x.x*__y.z,
                 __x.x*__y.y - __x.y*__y.x)
}

// MARK: - simd_double4
public func length_squared(_ __x: simd_double4) -> Double {simd_length_squared(__x)}
public func simd_length_squared(_ __x: simd_double4) -> Double {
    return __x.x*__x.x + __x.y*__x.y + __x.z*__x.z + __x.w*__x.w
}
public func length(_ __x: simd_double4) -> Double {simd_length(__x)}
public func simd_length(_ __x: simd_double4) -> Double {
    return sqrt(simd_length_squared(__x))
}
public func normalize(_ __x: simd_double4) -> simd_double4 {simd_normalize(__x)}
public func simd_normalize(_ __x: simd_double4) -> simd_double4 {
    let magnitude = simd_length(__x)
    return .init(__x.x / magnitude, __x.y / magnitude, __x.z / magnitude, __x.w / magnitude)
}

// MARK: - simd_float4
public func length_squared(_ __x: simd_float4) -> Float {simd_length_squared(__x)}
public func simd_length_squared(_ __x: simd_float4) -> Float {
    return __x.x*__x.x + __x.y*__x.y + __x.z*__x.z + __x.w*__x.w
}
public func length(_ __x: simd_float4) -> Float {simd_length(__x)}
public func simd_length(_ __x: simd_float4) -> Float {
    return sqrt(simd_length_squared(__x))
}
public func normalize(_ __x: simd_float4) -> simd_float4 {simd_normalize(__x)}
public func simd_normalize(_ __x: simd_float4) -> simd_float4 {
    let magnitude = simd_length(__x)
    return .init(__x.x / magnitude, __x.y / magnitude, __x.z / magnitude, __x.w / magnitude)
}

// MARK: - dot
/// Dot product of `x` and `y`.
public func dot(_ __x: simd_double3, _ __y: simd_double3) -> Double {
    __x.x*__y.x + __x.y*__y.y + __x.z*__y.z
}
/// Dot product of `x` and `y`.
public func dot(_ __x: simd_float3, _ __y: simd_float3) -> Float {
    __x.x*__y.x + __x.y*__y.y + __x.z*__y.z
}
/// Dot product of `x` and `y`.
public func dot(_ __x: simd_double4, _ __y: simd_double4) -> Double {
    __x.x*__y.x + __x.y*__y.y + __x.z*__y.z + __x.w*__y.w
}
/// Dot product of `x` and `y`.
public func dot(_ __x: simd_float4, _ __y: simd_float4) -> Float {
    __x.x*__y.x + __x.y*__y.y + __x.z*__y.z + __x.w*__y.w
}

// MARK: - project
/// Projection of `x` onto `y`.
public func project(_ __x: simd_double3, _ __y: simd_double3) -> simd_double3 {simd_project(__x, __y)}
/// Projection of `x` onto `y`.
public func simd_project(_ __x: simd_double3, _ __y: simd_double3) -> simd_double3 {
    let n = simd_normalize(__y)
    return dot(__x, n) * n
}
/// Projection of `x` onto `y`.
public func project(_ __x: simd_float3, _ __y: simd_float3) -> simd_float3 {simd_project(__x, __y)}
/// Projection of `x` onto `y`.
public func simd_project(_ __x: simd_float3, _ __y: simd_float3) -> simd_float3 {
    let n = simd_normalize(__y)
    return dot(__x, n) * n
}
/// Projection of `x` onto `y`.
public func project(_ __x: simd_double4, _ __y: simd_double4) -> simd_double4 {simd_project(__x, __y)}
/// Projection of `x` onto `y`.
public func simd_project(_ __x: simd_double4, _ __y: simd_double4) -> simd_double4 {
    let n = simd_normalize(__y)
    return dot(__x, n) * n
}
/// Projection of `x` onto `y`.
public func project(_ __x: simd_float4, _ __y: simd_float4) -> simd_float4 {simd_project(__x, __y)}
/// Projection of `x` onto `y`.
public func simd_project(_ __x: simd_float4, _ __y: simd_float4) -> simd_float4 {
    let n = simd_normalize(__y)
    return dot(__x, n) * n
}

// MARK: - reflect
/// Reflects x through the plane perpendicular to the normal vector n.
///
/// `x` reflected through the hyperplane with unit normal vector `n`, passing
/// through the origin.  E.g. if `x` is [1,2,3] and `n` is [0,0,1], the result
/// is [1,2,-3].
public func reflect(_ x: simd_double3, n: simd_double3) -> simd_double3 {
    simd_reflect(x, n)
}
/// Reflects x through the plane perpendicular to the normal vector n.
///
/// `x` reflected through the hyperplane with unit normal vector `n`, passing
/// through the origin.  E.g. if `x` is [1,2,3] and `n` is [0,0,1], the result
/// is [1,2,-3].
public func simd_reflect(_ __x: simd_double3, _ __n: simd_double3) -> simd_double3 {
    return __x - 2 * dot(__x, __n) * __n
}
/// Reflects x through the plane perpendicular to the normal vector n.
///
/// `x` reflected through the hyperplane with unit normal vector `n`, passing
/// through the origin.  E.g. if `x` is [1,2,3] and `n` is [0,0,1], the result
/// is [1,2,-3].
public func reflect(_ x: simd_float3, n: simd_float3) -> simd_float3 {
    simd_reflect(x, n)
}
/// Reflects x through the plane perpendicular to the normal vector n.
///
/// `x` reflected through the hyperplane with unit normal vector `n`, passing
/// through the origin.  E.g. if `x` is [1,2,3] and `n` is [0,0,1], the result
/// is [1,2,-3].
public func simd_reflect(_ __x: simd_float3, _ __n: simd_float3) -> simd_float3 {
    return __x - 2 * dot(__x, __n) * __n
}
/// Reflects x through the plane perpendicular to the normal vector n.
///
/// `x` reflected through the hyperplane with unit normal vector `n`, passing
/// through the origin.  E.g. if `x` is [1,2,3] and `n` is [0,0,1], the result
/// is [1,2,-3].
public func reflect(_ x: simd_double4, n: simd_double4) -> simd_double4 {
    simd_reflect(x, n)
}
/// Reflects x through the plane perpendicular to the normal vector n.
///
/// `x` reflected through the hyperplane with unit normal vector `n`, passing
/// through the origin.  E.g. if `x` is [1,2,3] and `n` is [0,0,1], the result
/// is [1,2,-3].
public func simd_reflect(_ __x: simd_double4, _ __n: simd_double4) -> simd_double4 {
    return __x - 2 * dot(__x, __n) * __n
}
/// Reflects x through the plane perpendicular to the normal vector n.
///
/// `x` reflected through the hyperplane with unit normal vector `n`, passing
/// through the origin.  E.g. if `x` is [1,2,3] and `n` is [0,0,1], the result
/// is [1,2,-3].
public func reflect(_ x: simd_float4, n: simd_float4) -> simd_float4 {
    simd_reflect(x, n)
}
/// Reflects x through the plane perpendicular to the normal vector n.
///
/// `x` reflected through the hyperplane with unit normal vector `n`, passing
/// through the origin.  E.g. if `x` is [1,2,3] and `n` is [0,0,1], the result
/// is [1,2,-3].
public func simd_reflect(_ __x: simd_float4, _ __n: simd_float4) -> simd_float4 {
    return __x - 2 * dot(__x, __n) * __n
}

// MARK: - distance

/// Distance between `x` and `y`.
public func distance(_ x: simd_double3, _ y: simd_double3) -> Double {
    sqrt(distance_squared(x, y))
}
/// Distance between `x` and `y`, squared.
public func distance_squared(_ x: simd_double3, _ y: simd_double3) -> Double {
    simd_length_squared(x-y)
}
/// Distance between `x` and `y`.
public func distance(_ x: simd_float3, _ y: simd_float3) -> Float {
    sqrt(distance_squared(x, y))
}
/// Distance between `x` and `y`, squared.
public func distance_squared(_ x: simd_float3, _ y: simd_float3) -> Float {
    simd_length_squared(x-y)
}
/// Distance between `x` and `y`.
public func distance(_ x: simd_double4, _ y: simd_double4) -> Double {
    sqrt(distance_squared(x, y))
}
/// Distance between `x` and `y`, squared.
public func distance_squared(_ x: simd_double4, _ y: simd_double4) -> Double {
    simd_length_squared(x-y)
}
/// Distance between `x` and `y`.
public func distance(_ x: simd_float4, _ y: simd_float4) -> Float {
    sqrt(distance_squared(x, y))
}
/// Distance between `x` and `y`, squared.
public func distance_squared(_ x: simd_float4, _ y: simd_float4) -> Float {
    simd_length_squared(x-y)
}

