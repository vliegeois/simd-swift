//
//  simd_double3x3Tests.swift
//  Simd-SwiftTests
//
//  Created by Vincent LIEGEOIS on 16/06/2023.
//

import XCTest
//#if canImport(simd)
//import simd
//#else
@testable import SimdSwift
//#endif

class simd_double4x4Tests: XCTestCase {
    func testSimd_double4x4() throws {
        let a = simd_double4x4(2.0)
        let b = simd_double4x4(.init(x: 1.0, y: 2.0, z: 3.0, w: 4.0),
                               .init(x: 5.0, y: 6.0, z: 7.0, w: 8.0),
                               .init(x: 9.0, y: 10.0, z: 11.0, w: 12.0),
                               .init(x: 13.0, y: 14.0, z: 15.0, w: 16.0))
        
        XCTAssertEqual(b[0, 1], 2.0, accuracy: 1e-10)
        XCTAssertEqual(b[1, 0], 5.0, accuracy: 1e-10)

        XCTAssertEqual(a + b, .init(.init(x: 3.0, y: 2.0, z: 3.0, w: 4.0),
                                    .init(x: 5.0, y: 8.0, z: 7.0, w: 8.0),
                                    .init(x: 9.0, y: 10.0, z: 13.0, w: 12.0),
                                    .init(x: 13.0, y: 14.0, z: 15.0, w: 18.0)))

        let invalid = simd_double4x4([.init(x: 3.0, y: 6.0, z: 9.0, w: 12.0)])
        XCTAssertEqual(invalid, .init(.init(x: 3.0, y: 6.0, z: 9.0, w: 12.0), .zero, .zero, .zero))

        let c = simd_double4x4([1.0, 2.0, 3.0, 4.0, 5.0])
        XCTAssertEqual(c, .init(.init(x: 1.0, y: 2.0, z: 3.0, w: 4.0),
                                .init(x: 5.0, y: 0.0, z: 0.0, w: 0.0),
                                .zero,
                                .zero))

        let d = simd_double4x4(.init(x: 1.0, y: 5.0, z: 9.0, w: 13.0),
                               .init(x: 2.0, y: 6.0, z: 10.0, w: 14.0),
                               .init(x: 3.0, y: 7.0, z: 11.0, w: 15.0),
                               .init(x: 4.0, y: 8.0, z: 12.0, w: 16.0))
        XCTAssertEqual(a * d, .init(.init(x: 2.0, y: 10.0, z: 18.0, w: 26.0),
                                    .init(x: 4.0, y: 12.0, z: 20.0, w: 28.0),
                                    .init(x: 6.0, y: 14.0, z: 22.0, w: 30.0),
                                    .init(x: 8.0, y: 16.0, z: 24.0, w: 32.0)))
    }
}
