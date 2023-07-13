//
//  simd_quatd.swift
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
        let s = Double.sin(angle/2.0)
        let axis = simd_normalize(axis)
        vector = .init(axis.x * s, axis.y * s, axis.z * s, Double.cos(angle/2.0))
    }

    /// A quaternion whose action rotates the vector `from` onto the vector `to`.
    public init(from: SIMD3<Double>, to: SIMD3<Double>) {
        var initialDirection = from
        var finalDirection = to
        if SimdSwift.length(initialDirection) < 1.0e-6 || SimdSwift.length(finalDirection) < 1.0e-6 {
            self.init(angle: .zero, axis: SIMD3<Double>(1.0, 0.0, 0.0))
            return
        }
        // normalize the vectors
        initialDirection = normalize(initialDirection)
        finalDirection = normalize(finalDirection)
        // dot product ang angle
        var s = dot(initialDirection, finalDirection)
        // problem with dot product equal -1.000 or 1.000
        if s < -1.00 {
            s = -1.00
        } else if s > 1.00 {
            s = 1.00
        }
        let angle = Double.acos(s)
        var axis: SIMD3<Double>
        // axis vector of rotation
        if (1.0 - abs(s)) < 1.0e-8 { // the initialDirection and finalDirection are colinear
            // generate random unit vector
            let dummy = normalize(simd_double3.random(in: 10...100))
            axis = dummy - project(dummy, initialDirection)
            axis = axis - project (axis, finalDirection)
        } else {
            axis = cross(initialDirection, finalDirection)
        }
        // normalize the axis
        if SimdSwift.length(axis) < 1.0e-6 {
            self.init(angle: .zero, axis: SIMD3<Double>(1.0, 0.0, 0.0))
            return
        }
        self.init(angle: angle, axis: normalize(axis))
    }
    
    /// Construct a quaternion from `rotationMatrix`.
    public init(_ rotMat: double3x3) {
        // http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToAngle/
        // the global formula has an issue (singularity) if theta = 0° or 180°
        // Check for singularity
        if abs(rotMat[0, 1] - rotMat[1, 0]) < 0.001 && abs(rotMat[0, 2] - rotMat[2, 0]) < 0.001 && abs(rotMat[1, 2] - rotMat[2, 1]) < 0.001 {
            // Angle is either 0° or 180°
            // Test for 0 angle which give identity rotMat
            let trace = rotMat[0, 0] + rotMat[1, 1] + rotMat[2, 2]
            if abs(rotMat[0, 1] + rotMat[1, 0]) < 0.001 && abs(rotMat[0, 2] + rotMat[2, 0]) < 0.001 && abs(rotMat[1, 2] + rotMat[2, 1]) < 0.001 && abs(trace - 3) < 0.001 {
                self.init(angle: .zero, axis: SIMD3<Double>(1.0, 0.0, 0.0))
                return
            }
            // Singularity is 180°
            // rotMat is
            // 2*x*x-1    2*x*y    2*x*z
            // 2*x*y    2*y*y-1    2*y*z
            // 2*x*z    2*y*z    2*z*z*-1
            let angle = Double.pi
            let axis: SIMD3<Double>
            let invsqrt2 = 1.0 / Double.sqrt(2.0)
            let xx = (rotMat[0, 0] + 1.0) / 2.0
            let yy = (rotMat[1, 1] + 1.0) / 2.0
            let zz = (rotMat[2, 2] + 1.0) / 2.0
            let xy = (rotMat[0, 1] + rotMat[1, 0]) / 4.0
            let xz = (rotMat[0, 2] + rotMat[2, 0]) / 4.0
            let yz = (rotMat[1, 2] + rotMat[2, 1]) / 4.0
            if xx > yy && xx > zz { // r11 is the largest diagonal
                if xx < 0.001 {
                    axis = SIMD3<Double>(0, invsqrt2, invsqrt2)
                } else {
                    let x = Double.sqrt(xx)
                    axis = SIMD3<Double>(x, xy/x, xz/x)
                }
            } else if yy > zz { // r22 is the largest diagonal
                if yy < 0.001 {
                    axis = SIMD3<Double>(invsqrt2, 0, invsqrt2)
                } else {
                    let y = Double.sqrt(yy)
                    axis = SIMD3<Double>(xy/y, y, yz/y)
                }
            } else { // r33 is the largest diagonal
                if zz < 0.001 {
                    axis = SIMD3<Double>(invsqrt2, invsqrt2, 0)
                } else {
                    let z = Double.sqrt(zz)
                    axis = SIMD3<Double>(xz/z, yz/z, z)
                }
            }
            self.init(angle: angle, axis: axis)
        } else {
            let trace = rotMat[0, 0] + rotMat[1, 1] + rotMat[2, 2]
            var cosVal = (trace - 1.0) / 2.0
            if cosVal < -1.0 {
                cosVal = -1.0
            } else if cosVal > 1.0 {
                cosVal = 1.0
            }
            let angle = Double.acos(cosVal)
            let den2 = Double.pow(rotMat[2, 1] - rotMat[1, 2], 2) + Double.pow(rotMat[0, 2] - rotMat[2, 0], 2) + Double.pow(rotMat[1, 0] - rotMat[0, 1], 2)
            let den = Double.sqrt(den2)
            let f = 1.0 / den
            let x = f * (rotMat[1, 2] - rotMat[2, 1])
            let y = f * (rotMat[2, 0] - rotMat[0, 2])
            let z = f * (rotMat[0, 1] - rotMat[1, 0])
            let axis = SIMD3<Double>(x, y, z)
            self.init(angle: angle, axis: axis)
        }
    }
    
    // Construct a quaternion from `rotationMatrix`.
    public init(_ rotationMatrix: double4x4) {
        let cols = rotationMatrix.columns
        self.init(double3x3(SIMD3(x: cols.0.x, y: cols.0.y, z: cols.0.z), SIMD3(x: cols.1.x, y: cols.1.y, z: cols.1.z), SIMD3(x: cols.2.x, y: cols.2.y, z: cols.2.z)))
    }

    /// The real (scalar) part of `self`.
    public var real: Double { vector.w }

    /// The imaginary (vector) part of `self`.
    public var imag: SIMD3<Double> { .init(vector.x, vector.y, vector.z) }
    
    /// The angle (in radians) from -pi to pi and the normalized axis by which `self`'s action rotates as a tuple.
    ///
    /// The axis must lies one of the fourth octant where no more than one direction is negative
    public var angleAxis: (angle: Double, axis: SIMD3<Double>) {
    //    Q = cos(theta/2) + sin(theta/2) * v
    //    where v is a unit vector along the rotation axis
    //    We want theta from -pi -> pi
    //    But theta,n gives the same quaternion as -theta,-n
    //    Therefore, theta: 0 -> pi, theta/2: 0 -> pi/2
    //    cos >0 while sin > 0
    //        If cos <0, Q' = -Q: correspond to have theta + 2pi
    //        We can allow theta to be -pi -> pi if we restrict n to be in 4 octant instead of the 8 octant.
        var cosine = self.real
        var vector = self.imag
        if cosine < 0.0 {
            // reverse the sign of the scalar and vector part of the Quaternion
            cosine = -cosine
            vector = -vector
        }
        var sine = SimdSwift.length(vector)
        if abs(sine) < 1.0e-8 {
            // zero vector part
            return (angle: 0.0, axis: SIMD3<Double>())
        }
        // determine in which octant is v
        vector *= (1.0 / sine) // the vector is normalized
        let octantX = Double(signOf: vector.x, magnitudeOf: 1.0)
        let octantY = Double(signOf: vector.y, magnitudeOf: 1.0)
        let octantZ = Double(signOf: vector.z, magnitudeOf: 1.0)
        let octant: Int = Int(octantX + octantY + octantZ)
        if octant < 0 {
            vector = -vector
            sine = -sine
        }
        let thetahalf = Double.atan2(y: sine, x: cosine)
        return (angle: thetahalf * 2.0, axis: vector)
    }
    
    /// The angle (in radians) from 0 to 2*pi by which `self`'s action rotates.
    public var angle: Double { 2.0 * Double.acos(vector.w) }

    /// The normalized axis about which `self`'s action rotates.
    public var axis: SIMD3<Double> {
        let a = Double.sin(angle/2.0)
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
        return Double.sqrt(vector.x*vector.x + vector.y*vector.y + vector.z*vector.z + vector.w*vector.w)
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

extension simd_quatd: Codable {
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

extension double4x4 {
    public init(_ quatd: simd_quatd) {
        let rot = double3x3(quatd)
        self.init(SIMD4(rot.columns.0, .zero), SIMD4(rot.columns.1, .zero), SIMD4(rot.columns.2, .zero), SIMD4(.zero, 1.0))
    }
}
