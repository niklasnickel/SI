/// Custom replacement for `precondition`.
///
/// This will call Swift's `precondition()` by default (and terminate the program).
/// At runtime while performing an XCTest, it will be changed to a different function in order to evaluate its output.
/// Adapted from Nikolaj Schumacher (@nschum)

import XCTest
import SI


extension XCTestCase {
	func assertPreconditionFailure(expectedMessage: String, block: () -> ()) {
		let expectation = expectation(description: "failing precondition")
		
		// Overwrite `preconditionClosure` so if doesn't terminate but verifies it happened.
		preconditionClosure = { condition, message, file, line in
			if !condition() {
				expectation.fulfill()
				XCTAssertEqual(message(), expectedMessage, "precondition message didn't match", file: file, line: line)
			}
		}
		block() // Call code.
		waitForExpectations(timeout: 0.0, handler: nil) // Verify precondition "failed".
		preconditionClosure = Swift.precondition // Reset precondition.
	}
}
