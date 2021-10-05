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
    }
}
