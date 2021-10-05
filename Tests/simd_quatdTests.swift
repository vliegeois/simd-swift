//
//  simd_quatdTests.swift
//  SimdSwiftTests
//
//  Created by Damien Noël Dubuisson on 05/10/2021.
//

import XCTest
//#if canImport(simd)
import simd
//#else
//@testable import SimdSwift
//#endif

class simd_quatdTests: XCTestCase {
    func testSimd_quatd() throws {
        let a = simd_quatd(vector: .init(4.0, 5.0, 9.0, 7.0))
        let aInverse = simd_quatd(real: 0.04093567251461988, imag: SIMD3<Double>(-0.023391812865497075, -0.029239766081871343, -0.05263157894736842))
        XCTAssertEqual(a.inverse, aInverse)

        let b = simd_quatd(vector: .init(1.0, 2.0, 3.0, 4.0))
        XCTAssertEqual(a + b, .init(ix: 5.0, iy: 7.0, iz: 12.0, r: 11.0))

        print(b.axis) // SIMD3<Double>(0,2672612419124244, 0,5345224838248488, 0,8017837257372732)
        print(b.angle) // 1.5040801783846713
    }
}
