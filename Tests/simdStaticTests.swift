//
//  simdStaticTests.swift
//  SimdSwiftTests
//
//  Created by Vincent LIEGEOIS on 16/06/2023.
//

import XCTest
//#if canImport(simd)
//import simd
//#else
@testable import SimdSwift
//#endif

class simdStaticTests: XCTestCase {
    func testSIMDStaticDot() throws {
        let a = simd_double3(4.0, 2, 3)
        let n = simd_double3(0.6, 0.8, 0)
        let z = dot(a, n)
        XCTAssertEqual(z, 4.0, accuracy: 1e-10)
    }
    func testSimdStaticProject() throws {
        let a = simd_double3(1.0, 2, 3)
        let n = simd_double3(6.0, 2, 0)
        let z = project(a, n)
        XCTAssertEqual(z, SIMD3(1.5, 0.5, 0.0), accuracy: 1e-10)
    }
    
    func testSimdStaticReflect() throws {
        let a = simd_double3(1.0, 2, 3)
        let n = simd_double3(-1.0, 0, 0)
        let z = reflect(a, n: n)
        XCTAssertEqual(z, SIMD3(-1.0, 2, 3), accuracy: 1e-10)
    }
    
    func testSimdStaticReflect2() throws {
        let a = simd_double3(4.0, 2, 3)
        let n = simd_double3(3.0, 4, 0)
        let z = reflect(a, n: n)
        XCTAssertEqual(z, SIMD3(-116.0, -158.0, 3.0), accuracy: 1e-10)
    }
    
}
