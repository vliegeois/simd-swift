//
//  simd_double3Tests.swift
//  Simd-SwiftTests
//
//  Created by Damien Noël Dubuisson on 04/10/2021.
//

import XCTest
//#if canImport(simd)
import simd
//#else
//@testable import SimdSwift
//#endif

class simd_double3Tests: XCTestCase {
    func testSimd_double3() throws {
        let a = simd_double3(x: 1.0, y: 2.0, z: 3.0)
        let b = simd_double3(x: 2.0, y: 2.0, z: 2.0)

        XCTAssertEqual(-a, simd_double3(x: -1.0, y: -2.0, z: -3.0))
        XCTAssertEqual(a + b, simd_double3(x: 3.0, y: 4.0, z: 5.0))
        XCTAssertEqual(a - b, simd_double3(x: -1.0, y: 0.0, z: 1.0))
        XCTAssertEqual(a * b, simd_double3(x: 2.0, y: 4.0, z: 6.0))
        XCTAssertEqual(a / b, simd_double3(x: 0.5, y: 1.0, z: 1.5))

        XCTAssertEqual(simd_double3(x: 0.0, y: 0.0, z: 0.0), .zero)
        XCTAssertEqual(simd_double3(x: 1.0, y: 1.0, z: 1.0), .one)

        XCTAssertEqual(a + 2.0, simd_double3(x: 3.0, y: 4.0, z: 5.0))
        XCTAssertEqual(a - 2.0, simd_double3(x: -1.0, y: 0.0, z: 1.0))
        XCTAssertEqual(a * 2.0, simd_double3(x: 2.0, y: 4.0, z: 6.0))
        XCTAssertEqual(a / 2.0, simd_double3(x: 0.5, y: 1.0, z: 1.5))

        XCTAssertEqual(2.0 + b, simd_double3(x: 4.0, y: 4.0, z: 4.0))
        XCTAssertEqual(2.0 - b, simd_double3(x: 0.0, y: 0.0, z: 0.0))
        XCTAssertEqual(2.0 * b, simd_double3(x: 4.0, y: 4.0, z: 4.0))
        XCTAssertEqual(2.0 / b, simd_double3(x: 1.0, y: 1.0, z: 1.0))

        let c = simd_double3(3.0, 1.0, 2.0)
        let cMagnitude = sqrt(c.x*c.x + c.y*c.y + c.z*c.z)
        let cNormalize = c / cMagnitude
        XCTAssertEqual(simd_normalize(c), cNormalize)

        let aCrossB = simd_double3(x: -2.0, y: 4.0, z: -2.0)
        let bCrossA = simd_double3(x: 2.0, y: -4.0, z: 2.0)
        XCTAssertEqual(simd_cross(a, b), aCrossB)
        XCTAssertEqual(simd_cross(b, a), bCrossA)

        XCTAssertEqual(a.sum(), 6.0)
        XCTAssertEqual(simd_double3(x: 2.0, y: 4.0, z: 6.0).sum(), 12.0)

        let inverseSqrt = rsqrt(25.0)
        XCTAssertEqual(1.0 / sqrt(25.0), inverseSqrt)

        let normalise = a * rsqrt(simd_length_squared(a))
        XCTAssertEqual(simd_normalize(a), normalise)
    }
}

public func XCTAssertEqual(_ expression1: simd_double3, _ expression2: simd_double3, accuracy: Double, _ message: @autoclosure () -> String = "", file: StaticString = #filePath, line: UInt = #line) {
    XCTAssertEqual(expression1.x, expression2.x, accuracy: accuracy)
    XCTAssertEqual(expression1.y, expression2.y, accuracy: accuracy)
    XCTAssertEqual(expression1.z, expression2.z, accuracy: accuracy)
}
