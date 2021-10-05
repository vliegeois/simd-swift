//
//  simd_double4Tests.swift
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

class simd_double4Tests: XCTestCase {
    func testSimd_double4() throws {
        let a = simd_double4(x: 1.0, y: 2.0, z: 3.0, w: 4.0)
        let b = simd_double4(x: 2.0, y: 2.0, z: 2.0, w: 2.0)

        XCTAssertEqual(-a, simd_double4(x: -1.0, y: -2.0, z: -3.0, w: -4.0))
        XCTAssertEqual(a + b, simd_double4(x: 3.0, y: 4.0, z: 5.0, w: 6.0))
        XCTAssertEqual(a - b, simd_double4(x: -1.0, y: 0.0, z: 1.0, w: 2.0))
        XCTAssertEqual(a * b, simd_double4(x: 2.0, y: 4.0, z: 6.0, w: 8.0))
        XCTAssertEqual(a / b, simd_double4(x: 0.5, y: 1.0, z: 1.5, w: 2.0))

        XCTAssertEqual(simd_double4(x: 0.0, y: 0.0, z: 0.0, w: 0.0), .zero)
        XCTAssertEqual(simd_double4(x: 1.0, y: 1.0, z: 1.0, w: 1.0), .one)

        XCTAssertEqual(a + 2.0, simd_double4(x: 3.0, y: 4.0, z: 5.0, w: 6.0))
        XCTAssertEqual(a - 2.0, simd_double4(x: -1.0, y: 0.0, z: 1.0, w: 2.0))
        XCTAssertEqual(a * 2.0, simd_double4(x: 2.0, y: 4.0, z: 6.0, w: 8.0))
        XCTAssertEqual(a / 2.0, simd_double4(x: 0.5, y: 1.0, z: 1.5, w: 2.0))

        XCTAssertEqual(2.0 + b, simd_double4(x: 4.0, y: 4.0, z: 4.0, w: 4.0))
        XCTAssertEqual(2.0 - b, simd_double4(x: 0.0, y: 0.0, z: 0.0, w: 0.0))
        XCTAssertEqual(2.0 * b, simd_double4(x: 4.0, y: 4.0, z: 4.0, w: 4.0))
        XCTAssertEqual(2.0 / b, simd_double4(x: 1.0, y: 1.0, z: 1.0, w: 1.0))
    }
}
