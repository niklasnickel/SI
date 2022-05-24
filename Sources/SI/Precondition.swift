/// Custom replacement for `precondition`.
///
/// This will call Swift's `precondition()` by default (and terminate the program).
/// At runtime while performing an XCTest, it will be changed to a different function in order to evaluate its output.
/// Adapted from Nikolaj Schumacher (@nschum)

import XCTest

#if DEBUG
func precondition(_ condition: @autoclosure () -> Bool,  _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
	preconditionClosure(condition(), message(), file, line)
}

/// The actual function called by our custom `precondition`.
var preconditionClosure = Swift.precondition


// MARK: Extention: XCTestCase

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

#endif



