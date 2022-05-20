import XCTest
@testable import SI

final class SITests: XCTestCase {
	// SI Handeling
	func testSIhandeling() throws {
		let meters = 1.5[.m]
		let millimeters = 400[.mm]
		let seconds = 10[.s]
		let squaremeters = 25[.m2]
		
		XCTAssertEqual(meters / seconds, 0.15[.m_s])
		XCTAssertEqual(meters / seconds + meters / seconds, 0.3[.m_s])
		XCTAssertEqual(meters + millimeters, 1.9[.m])
		XCTAssertEqual(squaremeters + meters * meters, 27.25[.m2])
		XCTAssertEqual(meters + millimeters, 1900[.mm])
		XCTAssertEqual(meters ^ 2, 2.25[.m2])
		XCTAssertEqual(meters * meters, 2.25[.m2])
		XCTAssertEqual(meters * millimeters, 0.6[.m2])
		XCTAssertEqual(SI.sqrt(meters * meters), meters)
		XCTAssertEqual(SI.sqrt(squaremeters), 5[.m])
		XCTAssertEqual(SI.sqrt(-meters ^ 2), meters)
		XCTAssertNil(SI.sqrt(-(meters ^ 2)))
		//        try XCTAssertThrowsError(SI.sqrt(meters))
		//        try XCTAssertThrowsError(meters.convert(to: Unit("")))
		XCTAssertEqual(5.0 * millimeters, 2[.m])
		XCTAssertEqual(meters * 2.0, 3[.m])
		XCTAssertEqual(1.0 / seconds, 0.1[.Hz])
		XCTAssertEqual(seconds / 2.0, 5[.s])
	}
	
	func testEquality() throws {
		// Various initialization methods
		XCTAssertEqual(0.15[.m_s], SI(0.15, .m_s))
		XCTAssertEqual(0[.N], SI(0, .N))
		XCTAssertEqual(-0[.N], SI(0, .N))
		XCTAssertEqual(0[.N], -SI(0, .N))
		XCTAssertEqual(1[.scalar], SI(1))
		XCTAssertEqual(1[], SI(1))
		XCTAssertEqual(1[], SI(1.0))
		
		// Equation fails due to wrong dimension
		assertPreconditionFailure(expectedMessage: "Cannot evaluate equality: Units don't match.") {
			let _ = 0[.m] == 0[.s]
		}
		assertPreconditionFailure(expectedMessage: "Cannot evaluate equality: Units don't match.") {
			let _ = 0[.m] == 0[.m2]
		}
		assertPreconditionFailure(expectedMessage: "Cannot evaluate approximate equality: Units don't match.") {
			let _ = 0[.mm].isApprox(0[.s])
		}
	}
	
	func testConversion() throws {
		// Multiplier conversions
		XCTAssertEqual(1[.m], 1.0[.m])
		XCTAssertEqual(1.0[.m], 1000[.mm])
		XCTAssertTrue(1.9[.m].isApprox(1900[.mm]))
		XCTAssertEqual(0[.m], 0[.mm])
		XCTAssertEqual(1e80[.m], 1e83[.mm])
		XCTAssertEqual(1e-80[.m], 1e-77[.mm])
	}
	
	func testAddition() throws {
		let l1 = 1[.m]
		let l2 = 500[.mm]
		
		XCTAssertEqual(l1 + l1, 2[.m])
		XCTAssertEqual(l1 - l1, 0[.m])
		XCTAssertEqual(l1 + l2, 1.5[.m])
		XCTAssertEqual(l2 - l1, -0.5[.m])
		XCTAssertEqual(l2 + l2, l1)
		
		
		XCTAssertEqual(1 + 1[], 2[])
		XCTAssertEqual(1[] + 1, 2[])
		
		// Addition fails due to wrong dimension
		assertPreconditionFailure(expectedMessage: "Cannot add SI values: Units don't match.") {
			let _ = 0[.m] + 0[.s]
		}
		assertPreconditionFailure(expectedMessage: "Cannot add SI values: Units don't match.") {
			let _ = 0 + 0[.s]
		}
		assertPreconditionFailure(expectedMessage: "Cannot add SI values: Units don't match.") {
			let _ = 0[.m] + 0
		}
	}
	
	func testScalarMultiplication() throws {
		let l1 = 1[.m]
		let l2 = 500[.mm]
		
		XCTAssertEqual(2 * l1, 2[.m])
		XCTAssertEqual(0 * l1, 0[.m])
		XCTAssertEqual(2 * l2, l1)
		XCTAssertEqual(l2 * 2, l1)
		XCTAssertEqual(-2 * l2, -l1)
	}
}
