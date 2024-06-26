//
//  simd_double3x3Tests.swift
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

class simd_double3x3Tests: XCTestCase {
    func testSimd_double3x3() throws {
        let a = simd_double3x3(2.0)
        let b = simd_double3x3(.init(x: 1.0, y: 2.0, z: 3.0),
                               .init(x: 4.0, y: 5.0, z: 6.0),
                               .init(x: 7.0, y: 8.0, z: 9.0))
        XCTAssertEqual(b[0, 1], 2.0, accuracy: 1e-10)
        XCTAssertEqual(b[1, 0], 4.0, accuracy: 1e-10)

        XCTAssertEqual(a + b, .init(.init(x: 3.0, y: 2.0, z: 3.0),
                                    .init(x: 4.0, y: 7.0, z: 6.0),
                                    .init(x: 7.0, y: 8.0, z: 11.0)),
                       accuracy: 1e-10)

        let invalid = simd_double3x3([.init(x: 3.0, y: 6.0, z: 9.0)])
        XCTAssertEqual(invalid, .init(.init(x: 3.0, y: 6.0, z: 9.0), .zero, .zero),
                       accuracy: 1e-10)
        let c = simd_double3x3([1.0, 2.0, 3.0, 4.0])
        XCTAssertEqual(c, .init(.init(x: 1.0, y: 2.0, z: 3.0),
                                .init(x: 4.0, y: 0.0, z: 0.0),
                                .zero),
                       accuracy: 1e-10)

        let d = simd_double3x3(.init(x: 1.0, y: 4.0, z: 7.0),
                               .init(x: 2.0, y: 5.0, z: 8.0),
                               .init(x: 3.0, y: 6.0, z: 9.0))
        XCTAssertEqual(a * d, .init(.init(x: 2.0, y: 8.0, z: 14.0),
                                    .init(x: 4.0, y: 10.0, z: 16.0),
                                    .init(x: 6.0, y: 12.0, z: 18.0)),
                       accuracy: 1e-10)
    }
    func testSimd_double3x3Det() throws {
        let b = simd_double3x3(.init(x: 1.0, y: 2.0, z: 3.0),
                               .init(x: 2.0, y: 5.0, z: 6.0),
                               .init(x: 4.0, y: 5.0, z: 9.0))
        XCTAssertEqual(b.determinant, -3.0, accuracy: 1e-10)
    }
    func testSimd_double3x3Inv() throws {
        let b = simd_double3x3(.init(x: 1.0, y: 2.0, z: 3.0),
                               .init(x: 2.0, y: 5.0, z: 6.0),
                               .init(x: 4.0, y: 5.0, z: 9.0))
        let binv = b.inverse
        XCTAssertEqual(b * binv, double3x3(diagonal: SIMD3(x: 1.0, y: 1.0, z: 1.0)), accuracy: 1e-10)
        XCTAssertEqual(binv * b, double3x3(diagonal: SIMD3(x: 1.0, y: 1.0, z: 1.0)), accuracy: 1e-10)
    }
}

public func XCTAssertEqual(_ expression1: double3x3, _ expression2: double3x3, accuracy: Double, _ message: @autoclosure () -> String = "", file: StaticString = #filePath, line: UInt = #line) {
    XCTAssertEqual(expression1.columns.0, expression2.columns.0, accuracy: accuracy)
    XCTAssertEqual(expression1.columns.1, expression2.columns.1, accuracy: accuracy)
    XCTAssertEqual(expression1.columns.2, expression2.columns.2, accuracy: accuracy)
}
