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
		XCTAssertEqual(meters ** 2, 2.25[.m2])
		XCTAssertEqual(meters * meters, 2.25[.m2])
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
		
		// Text approximate equality
		XCTAssertTrue(1900[.mm].isApprox(1.9[.m]))
		XCTAssertTrue(1.000_000_000_1[.mm].isApprox(1[.mm]))
		XCTAssertFalse(1.000_000_001[.mm].isApprox(1[.mm]))
		XCTAssertTrue(1.000_000_000_01[.mm].isApprox(1[.mm], precision: 1e-10))
		XCTAssertFalse(1.000_000_000_1[.mm].isApprox(1[.mm], precision: 1e-10))
		
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
	
	func testExponentiationSqrt() throws {
		let l1 = 2[.m]
		let l2 = 2[.mm]
		let a1 = 4[.m2]
		
		// Potentiation
		XCTAssertEqual(l1 ** 1, l1)
		XCTAssertEqual(l1 ** 2, l1 * l1)
		XCTAssertEqual(l2 ** 2, l2 * l2)
		XCTAssertEqual(l2 ** 2, 4[.mm * .mm])
		XCTAssertEqual(l1 ** 3, l1 * l1 * l1)
		XCTAssertEqual(l1 ** 0, 1[])
		XCTAssertEqual(l1 ** -1, 1 / l1)
		XCTAssertEqual(l1 ** -2, 1 / (l1 ** 2))
		
		// Square Root
		XCTAssertEqual(sqrt(l1 * l1), l1)
		XCTAssertEqual(sqrt(-l1 * -l1), l1)
		XCTAssertEqual(sqrt(l1 ** 2), l1)
		XCTAssertEqual(sqrt(-l1 ** 2), l1)
		XCTAssertEqual(sqrt(a1), l1)
		XCTAssertEqual(sqrt(1 / a1), 1 / l1)
		XCTAssertEqual(sqrt(1[]), 1[])
		
		assertPreconditionFailure(expectedMessage: "Cannot compute sqrt: Unit is no square.") {
			let _ = sqrt(l1)
		}
		assertPreconditionFailure(expectedMessage: "Cannot compute sqrt: Value is negative.") {
			let _ = sqrt(-a1)
		}
	}
	
	func testMultiplicationDivision() throws {
		// Multiplication
		XCTAssertEqual(2[.m] * 2[.m], 4[.m2])
		XCTAssertEqual(2.5 * 2[.mm], 5[.mm])
		XCTAssertEqual(2[.mm] * 2.5, 5[.mm])
		
		XCTAssertEqual(2[.m] * 2[.mm], 0.004[.m2])
		
		// Division
		XCTAssertEqual(4[.m2] / 2[.m], 2[.m])
		XCTAssertEqual(4 / 2[.mm], 2[.scalar / .mm])
		XCTAssertEqual(2[.mm] / 2, 1[.mm])
	}
	
	func testDebugDescription() throws {
		XCTAssertEqual(2[.m].debugDescription, "2.0 m")
		XCTAssertEqual(2.4[.Pa].debugDescription, "2.4 Pa")
		XCTAssertEqual(2e19[.Pa].debugDescription, "2e+19 Pa")
		XCTAssertEqual(2[0.001 * .m].debugDescription, "2.0 x 0.001 m^1")
		let string = 2[.m / .s ** 2].debugDescription // TODO: Fix sorting of units in debug description
		XCTAssertTrue(string == "2.0 m^1 s^-2" || string == "2.0 s^-2 m^1")
		XCTAssertEqual(2[.m_s].debugDescription, "2.0 m/s")
	}
	
	func testPrefix() throws {
		XCTAssertEqual(2[µ(.m)], 2e-6[.m])
		XCTAssertEqual(SI(2, µ(.m)), SI(2e-6, .m))
		XCTAssertEqual(2000[m(.m)], 2[.m])
	}
}
