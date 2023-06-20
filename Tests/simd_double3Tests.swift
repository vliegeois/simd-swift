//
//  simd_double3Tests.swift
//  Simd-SwiftTests
//
//  Created by Damien Noël Dubuisson on 04/10/2021.
//

import XCTest
//#if canImport(simd)
//import simd
//#else
@testable import SimdSwift
//#endif

class simd_double3Tests: XCTestCase {
    func testSimd_double3() throws {
        let a = simd_double3(x: 1.0, y: 2.0, z: 3.0)
        let b = simd_double3(x: 2.0, y: 2.0, z: 2.0)

        XCTAssertEqual(-a, simd_double3(x: -1.0, y: -2.0, z: -3.0), accuracy: 1e-10)
        XCTAssertEqual(a + b, simd_double3(x: 3.0, y: 4.0, z: 5.0), accuracy: 1e-10)
        XCTAssertEqual(a - b, simd_double3(x: -1.0, y: 0.0, z: 1.0), accuracy: 1e-10)
        XCTAssertEqual(a * b, simd_double3(x: 2.0, y: 4.0, z: 6.0), accuracy: 1e-10)
        XCTAssertEqual(a / b, simd_double3(x: 0.5, y: 1.0, z: 1.5), accuracy: 1e-10)

        XCTAssertEqual(simd_double3(x: 0.0, y: 0.0, z: 0.0), .zero, accuracy: 1e-10)
        XCTAssertEqual(simd_double3(x: 1.0, y: 1.0, z: 1.0), .one, accuracy: 1e-10)

        XCTAssertEqual(a + 2.0, simd_double3(x: 3.0, y: 4.0, z: 5.0), accuracy: 1e-10)
        XCTAssertEqual(a - 2.0, simd_double3(x: -1.0, y: 0.0, z: 1.0), accuracy: 1e-10)
        XCTAssertEqual(a * 2.0, simd_double3(x: 2.0, y: 4.0, z: 6.0), accuracy: 1e-10)
        XCTAssertEqual(a / 2.0, simd_double3(x: 0.5, y: 1.0, z: 1.5), accuracy: 1e-10)

        XCTAssertEqual(2.0 + b, simd_double3(x: 4.0, y: 4.0, z: 4.0), accuracy: 1e-10)
        XCTAssertEqual(2.0 - b, simd_double3(x: 0.0, y: 0.0, z: 0.0), accuracy: 1e-10)
        XCTAssertEqual(2.0 * b, simd_double3(x: 4.0, y: 4.0, z: 4.0), accuracy: 1e-10)
        XCTAssertEqual(2.0 / b, simd_double3(x: 1.0, y: 1.0, z: 1.0), accuracy: 1e-10)

        let c = simd_double3(3.0, 1.0, 2.0)
        let cMagnitude = sqrt(c.x*c.x + c.y*c.y + c.z*c.z)
        let cNormalize = c / cMagnitude
        XCTAssertEqual(simd_normalize(c), cNormalize, accuracy: 1e-10)

        let aCrossB = simd_double3(x: -2.0, y: 4.0, z: -2.0)
        let bCrossA = simd_double3(x: 2.0, y: -4.0, z: 2.0)
        XCTAssertEqual(simd_cross(a, b), aCrossB, accuracy: 1e-10)
        XCTAssertEqual(simd_cross(b, a), bCrossA, accuracy: 1e-10)

        XCTAssertEqual(a.sum(), 6.0, accuracy: 1e-10)
        XCTAssertEqual(simd_double3(x: 2.0, y: 4.0, z: 6.0).sum(), 12.0, accuracy: 1e-10)

        let inverseSqrt = rsqrt(25.0)
        XCTAssertEqual(1.0 / sqrt(25.0), inverseSqrt, accuracy: 1e-10)

        let normalise = a * rsqrt(simd_length_squared(a))
        XCTAssertEqual(simd_normalize(a), normalise, accuracy: 1e-10)
        
        let aInt = SIMD3<Int>(a)
        XCTAssertEqual(aInt.x, 1)
        XCTAssertEqual(aInt.y, 2)
        XCTAssertEqual(aInt.z, 3)
        let aDouble = SIMD3<Double>(aInt)
        XCTAssertEqual(aDouble, simd_double3(x: 1.0, y: 2.0, z: 3.0), accuracy: 1e-10)
        let aTrunc = trunc(simd_double3(x: 1.3, y: 2.5, z: -4.3))
        XCTAssertEqual(aTrunc, simd_double3(x: 1.0, y: 2.0, z: -4.0), accuracy: 1e-10)
        let aAbs = abs(simd_double3(x: 1.3, y: 2.5, z: -4.3))
        XCTAssertEqual(aAbs, simd_double3(x: 1.3, y: 2.5, z: 4.3), accuracy: 1e-10)
        let aMin = min(simd_double3(x: 1.3, y: 2.5, z: -4.3), 2.0)
        XCTAssertEqual(aMin, simd_double3(x: 1.3, y: 2.0, z: -4.3), accuracy: 1e-10)
        let aMax = max(simd_double3(x: 1.3, y: 2.5, z: -4.3), 2.0)
        XCTAssertEqual(aMax, simd_double3(x: 2.0, y: 2.5, z: 2.0), accuracy: 1e-10)
    }
}

public func XCTAssertEqual(_ expression1: simd_double3, _ expression2: simd_double3, accuracy: Double, _ message: @autoclosure () -> String = "", file: StaticString = #filePath, line: UInt = #line) {
    XCTAssertEqual(expression1.x, expression2.x, accuracy: accuracy)
    XCTAssertEqual(expression1.y, expression2.y, accuracy: accuracy)
    XCTAssertEqual(expression1.z, expression2.z, accuracy: accuracy)
}
