/// Our custom drop-in replacement `precondition`.
///
/// This will call Swift's `precondition` by default (and terminate the program).
/// But it can be changed at runtime to be tested instead of terminating.

import XCTest

func precondition(_ condition: @autoclosure () -> Bool,  _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
	preconditionClosure(condition(), message(), file, line)
}

/// The actual function called by our custom `precondition`.
var preconditionClosure = defaultPreconditionClosure
let defaultPreconditionClosure = {Swift.precondition($0, $1, file: $2, line: $3)}

extension XCTestCase {
	func assertPreconditionFailure(expectedMessage: String, block: () -> ()) {
		let expectation = expectation(description: "failing precondition")
		
		// Overwrite `precondition` with something that doesn't terminate but verifies it happened.
		preconditionClosure = { condition, message, file, line in
			if !condition {
				expectation.fulfill()
				XCTAssertEqual(message, expectedMessage, "precondition message didn't match", file: file, line: line)
			}
		}
		block() // Call code.
		waitForExpectations(timeout: 0.0, handler: nil) // Verify precondition "failed".
		preconditionClosure = defaultPreconditionClosure // Reset precondition.
	}
}


