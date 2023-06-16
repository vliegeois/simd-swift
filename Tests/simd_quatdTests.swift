//
//  simd_quatdTests.swift
//  SimdSwiftTests
//
//  Created by Damien Noël Dubuisson on 05/10/2021.
//

import XCTest
//#if canImport(simd)
//import simd
//#else
@testable import SimdSwift
//#endif

class simd_quatdTests: XCTestCase {
    func testSimd_quatd() throws {
        let a = simd_quatd(vector: .init(4.0, 5.0, 9.0, 7.0))
        let aInverse = simd_quatd(real: 0.04093567251461988, imag: SIMD3<Double>(-0.023391812865497075, -0.029239766081871343, -0.05263157894736842))
        XCTAssertEqual(a.inverse, aInverse)

        let b = simd_quatd(vector: .init(1.0, 2.0, 3.0, 4.0))
        XCTAssertEqual(a + b, .init(ix: 5.0, iy: 7.0, iz: 12.0, r: 11.0))

        let c = simd_quatd(angle: 90.0.toRadians, axis: .init(1.0, 0.0, 0.0))
        let c2 = simd_quatd(ix: 0.7071067811865475, iy: 0.0, iz: 0.0, r: 0.7071067811865476)
        XCTAssertEqual(c, c2)
        XCTAssertEqual(c2.angle.toDegrees, 90.0, accuracy: 1e-13)
        XCTAssertEqual(c2.axis, .init(1.0, 0.0, 0.0))
    }
    func testSimd_quatdAngleAxis() throws {
        let v = normalize(SIMD3<Double>(x: 1, y: -2, z: -1.5))
        let a = simd_quatd(angle: Double.pi/3, axis: v)
        let aa = a.angleAxis
        XCTAssertEqual(a.length, 1.0, accuracy: 1e-13)
        XCTAssertEqual(a.real, sqrt(3)/2, accuracy: 1e-13)
        XCTAssertEqual(a.imag, 0.5*v, accuracy: 1e-10)
        XCTAssertEqual(a.angle, Double.pi/3, accuracy: 1e-13)
        XCTAssertEqual(a.axis, v, accuracy: 1e-10)
        XCTAssertEqual(aa.angle, -Double.pi/3, accuracy: 1e-13)
        XCTAssertEqual(aa.axis, -v, accuracy: 1e-10)
    }
    func testSimd_quatdFromTo() throws {
        let a = simd_double3(x: 1, y: 0, z: 0)
        let b = simd_double3(x: 0, y: 1, z: 0)
        let q = simd_quatd(from: a, to: b)
        XCTAssertEqual(q, .init(angle: Double.pi/2, axis: simd_double3(x: 0, y: 0, z: 1)), accuracy: 1e-10)
    }
    func testSimd_quatdRotMat() throws {
        let a = simd_quatd(angle: Double.pi/3, axis: normalize(.init(x: 1, y: -2, z: 1.5)))
        let rotMat = double3x3(a)
        let b = simd_quatd(rotMat)
        XCTAssertEqual(a, b, accuracy: 1e-10)
    }
}

public func XCTAssertEqual(_ expression1: simd_quatd, _ expression2: simd_quatd, accuracy: Double, _ message: @autoclosure () -> String = "", file: StaticString = #filePath, line: UInt = #line) {
    XCTAssertEqual(expression1.vector, expression2.vector, accuracy: accuracy)
}
