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
}
