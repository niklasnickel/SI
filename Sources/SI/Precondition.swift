//
//  Precondition.swift
//  
//
//  Created by Niklas Nickel on 25.05.22.
//

import Foundation

public func precondition(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
	preconditionClosure(condition(), message(), file, line)
}

/// The actual function called by our custom `precondition`.
public var preconditionClosure = Swift.precondition
