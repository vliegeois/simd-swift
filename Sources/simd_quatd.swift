//
//  simd_quatd.swift
//  
//
//  Created by Damien Noël Dubuisson on 05/10/2021.
//

#if os(macOS) || os(iOS)
import Darwin
#elseif os(Linux) || CYGWIN
import Glibc
#endif

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

    /// A quaternion whose action is a rotation by `angle` radians about `axis`.
    ///
    /// - Parameters:
    ///   - angle: The angle to rotate by measured in radians.
    ///   - axis: The axis to rotate around.
    public init(angle: Double, axis: SIMD3<Double>) {
        //    Q = cos(theta/2) + sin(theta/2) * v
        let s = sin(angle/2.0)
        let axis = simd_normalize(axis)
        vector = .init(axis.x * s, axis.y * s, axis.z * s, cos(angle/2.0))
    }

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
    
    //    Q = cos(theta/2) + sin(theta/2) * v
    //    where v is a unit vector along the rotation axis
    //    We want theta from -pi -> pi
    //    But theta,n gives the same quaternion as -theta,-n
    //    Therefore, theta: 0 -> pi, theta/2: 0 -> pi/2
    //    cos >0 while sin > 0
    //        If cos <0, Q' = -Q: correspond to have theta + 2pi
    //        We can allow theta to be -pi -> pi if we restrict n to be in 4 octant instead of the 8 octant.
    //        var cosine = self.scalar
    //        var vector = self.vector
    //        if cosine < 0.0 {
    //             // reverse the sign of the scalar and vector part of the Quaternion
    //            cosine = -cosine
    //            vector = -vector
    //        }
    //        var sine = length(vector)
    //        if abs(sine) < 1.0e-8 {
    //            // zero vector part
    //            return Rotation(angle: 0.0, andAxis: SIMD3<Double>())
    //        }
    //        // determine in which octant is v
    //        vector *= (1.0 / sine) // the vector is normalized
    //        let octantX = Double(signOf: vector.x, magnitudeOf: 1.0)
    //        let octantY = Double(signOf: vector.y, magnitudeOf: 1.0)
    //        let octantZ = Double(signOf: vector.z, magnitudeOf: 1.0)
    //        let octant: Int = Int(octantX + octantY + octantZ)
    //        if octant < 0 {
    //            vector = -vector
    //            sine = -sine
    //        }
    //        let thetahalf = atan2(sine, cosine)
    //        return Rotation(angle: thetahalf * 2.0, andAxis: vector)
    //    }
    
    /// The angle (in radians) by which `self`'s action rotates.
    public var angle: Double { 2.0 * acos(vector.w) }

    /// The normalized axis about which `self`'s action rotates.
    public var axis: SIMD3<Double> {
        let a = sin(angle/2.0)
        return .init(vector.x / a, vector.y / a, vector.z / a)
    }

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


extension double3x3 {
    public init(_ quatd: simd_quatd) {
        let q0 = quatd.real
        let qx = quatd.imag.x
        let qy = quatd.imag.y
        let qz = quatd.imag.z
        self.init(rows: [
            .init(x: q0*q0+qx*qx-qy*qy-qz*qz, y: 2.0*(qx*qy-q0*qz), z: 2.0*(qx*qz+q0*qy)),
            .init(x: 2.0*(qy*qx+q0*qz), y: q0*q0-qx*qx+qy*qy-qz*qz, z: 2.0*(qy*qz-q0*qx)),
            .init(x: 2.0*(qz*qx-q0*qy), y: 2.0*(qz*qy+q0*qx), z: q0*q0-qx*qx-qy*qy+qz*qz)
        ])
    }
}
