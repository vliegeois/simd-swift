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
        XCTAssertEqual(a.length, 1.0, accuracy: 1e-13)
        XCTAssertEqual(a.real, sqrt(3)/2, accuracy: 1e-13)
        XCTAssertEqual(a.imag, 0.5*v, accuracy: 1e-10)
        XCTAssertEqual(a.angle, Double.pi/3, accuracy: 1e-13)
        XCTAssertEqual(a.axis, v, accuracy: 1e-10)
        
    }
//    func testSimd_quatdFromTo() throws {
//    }
//    func testSimd_quatdRotMat() throws {
//        let a = simd_quatd(angle: Double.pi/3, axis: normalize(.init(x: 1, y: -2, z: -1.5)))
//        let rotMat = double3x3(a)
//        let b = simd_quadt(rotMat)
//        XCTAssertEqual(a.vector, b.vector, accuracy: 1e-10)
//    }
}
