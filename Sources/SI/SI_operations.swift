//
//  SI_operations.swift
//  
//
//  Created by Niklas Nickel on 19.05.22.
//

import Foundation

extension SI {
	
	// MARK: Equality
	/**
	 Determines whether `lhs` is approximately equal to `rhs` with a precision of `precision`
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Right hand argument
	 - Returns: `True` if  `lhs` is  equal to `rhs`. Otherwise `False`
	 */
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		precondition(lhs.unit.dimension == rhs.unit.dimension, "Cannot evaluate equality: Units don't match.")
		if rhs.unit == lhs.unit { // No unit conversion necessary
			return lhs.value == rhs.value
		} else { // Unit conversion necessary
			return lhs.convertToSI().value == rhs.convertToSI().value
		}
	}
	
	/**
	 Determines whether `lhs` is approximately equal to `rhs` with a precision of `precision`
	 
	 - Parameter comparator: Value to compare to
	 - Parameter precision: Precision (Default: 1e-9)
	 - Returns: `True` if  `lhs` is approximately equal to `rhs` with a precision of `precision`. Otherwise `False`
	 */
	public func isApprox(_ comparator: Self, precision: Double = 1e-9) -> Bool {
		precondition(comparator.unit.dimension == unit.dimension, "Cannot evaluate approximate equality: Units don't match.")
		if unit == comparator.unit { // No unit conversion necessary
			return fabs(value.distance(to: comparator.value)) <= precision
		} else { // Unit conversion necessary
			return fabs(convertToSI().value.distance(to: comparator.convertToSI().value)) <= precision
		}
	}
	
	
	//  MARK: Inequality
	
	/**
	 Determines whether `lhs` is  less than `rhs`
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Right hand argument
	 - Returns: `True` if  `lhs` is scientifically less than `rhs`. Otherwise `False`
	 */
	public static func <(lhs: SI, rhs: SI) -> Bool {
		precondition(lhs.unit.dimension == rhs.unit.dimension, "Cannot evaluate inequality: Units don't match.")
		return lhs.convertToSI().value < rhs.convertToSI().value
	}
	
	/**
	 Determines whether `lhs` is  greater than `rhs`
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Right hand argument
	 - Returns: `True` if  `lhs` is scientifically greater than `rhs`. Otherwise `False`
	 */
	public static func >(lhs: SI, rhs: SI) -> Bool {
		precondition(lhs.unit.dimension == rhs.unit.dimension, "Cannot evaluate inequality: Units don't match.")
		return lhs.convertToSI().value > rhs.convertToSI().value
	}
	
	//MARK: Multiplication
	/**
	 Multiplies two `SI` values.
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Right hand argument
	 - Returns: Scientifically correct product of `lhs` and `rhs`.
	 */
	public static func *(lhs: Self, rhs: Self) -> Self {
		let value = lhs.convertToSI().value * rhs.convertToSI().value
		let unit = Unit(multiplier: 1, dimension: lhs.unit.addDimension(to: rhs.unit))
		return SI(value, unit)
	}
	
	/**
	 Multiplies a scalar `Double`with an `SI` value.
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Right hand argument
	 - Returns: Scientifically correct product of `lhs` and `rhs`.
	 */
	public static func *(lhs: Double, rhs: Self) -> Self {
		let value = lhs * rhs.value
		return SI(value, rhs.unit)
	}
	
	/**
	 Multiplies an `SI` value with a scalar `Double`.
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Right hand argument
	 - Returns: Scientifically correct product of `lhs` and `rhs`.
	 */
	public static func *(lhs: Self, rhs: Double) -> Self {
		rhs * lhs
	}
	
	//MARK: Division
	/**
	 Divides two `SI` values.
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Right hand argument
	 - Returns: Scientifically correct fraction of `lhs` and `rhs`.
	 */
	public static func /(lhs: Self, rhs: Self) -> Self {
		let value = lhs.convertToSI().value / rhs.convertToSI().value
		let unit = Unit(multiplier: 1, dimension: rhs.unit.subtractDimension(from: lhs.unit))
		return SI(value, unit)
	}
	
	/**
	 Divides a scalar `Double` by an `SI` value.
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Right hand argument
	 - Returns: Scientifically correct fraction of `lhs` and `rhs`.
	 */
	public static func /(lhs: Double, rhs: Self) -> Self {
		let value = lhs / rhs.value
		let unit = Unit(multiplier: 1 / rhs.unit.multiplier, dimension: rhs.unit.subtractDimension(from: Unit.scalar))
		return SI(value, unit)
	}
	
	/**
	 Divides an `SI` value by a scalar `Double`.
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Right hand argument
	 - Returns: Scientifically correct fraction of `lhs` and `rhs`.
	 */
	public static func /(lhs: Self, rhs: Double) -> Self {
		let value = lhs.value / rhs
		return SI(value, lhs.unit)
	}
	
	//MARK: Addition
	/**
	 Adds two `SI` values if they share the same dimension.
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Right hand argument
	 - Precondition: Dimension of `rhs` and dimension of `lhs` are equal
	 - Returns: Scientifically correct sum of `lhs` and `rhs`.
	 */
	public static func +(lhs: Self, rhs: Self) -> Self {
		precondition(lhs.unit.dimension == rhs.unit.dimension, "Cannot add SI values: Units don't match.")
		// Convert to common unit
		let value = lhs.convertToSI().value + rhs.convertToSI().value
		return SI(value, Unit(multiplier: 1, dimension: lhs.unit.dimension))
	}
	
	/**
	 Adds a `Double` to an `SI` value.
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Right hand argument
	 - Returns: Sum of `lhs` and `rhs` as an `SI`number.
	 */
	public static func +(lhs: Double, rhs: Self) -> SI {
		SI(lhs) + rhs
	}
	
	/**
	 Adds an `SI` value to a `Double`.
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Right hand argument
	 - Returns: Sum of `lhs` and `rhs` as an `SI`number.
	 */
	public static func +(lhs: Self, rhs: Double) -> SI {
		lhs + SI(rhs)
	}
	
	//MARK: Subtraction
	/**
	 Subtracts two `SI` values if they share the same dimension.
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Right hand argument
	 - Precondition: Dimension of `rhs` and dimension of `lhs` are equal
	 - Returns: Scientifically correct difference of `lhs` and `rhs`.
	 */
	public static func -(lhs: Self, rhs: Self) -> Self {
		precondition(lhs.unit.dimension == rhs.unit.dimension)
		// Convert to common unit
		let value = lhs.convertToSI().value - rhs.convertToSI().value
		return SI(value, Unit(multiplier: 1, dimension: lhs.unit.dimension))
	}
	
	/**
	 Subtracts a `Double` from an `SI` value.
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Right hand argument
	 - Returns: Difference of `lhs` and `rhs` as an `SI`number.
	 */
	public static func -(lhs: Double, rhs: Self) -> Self {
		SI(lhs) - rhs
	}
	
	/**
	 Subtracts an `SI` value from a `Double`.
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Right hand argument
	 - Returns: Difference of `lhs` and `rhs` as an `SI`number.
	 */
	public static func -(lhs: Self, rhs: Double) -> Self {
		lhs - SI(rhs)
	}
	
	// MARK: Other operators
	/**
	 Negates the `SI` value.
	 
	 - Parameter lhs: Left hand argument
	 - Returns: Scientifically correct negation of `lhs`.
	 */
	public static prefix func -(lhs: Self) -> Self {
		SI(-lhs.value, Unit(multiplier: 1, dimension: lhs.unit.dimension))
	}
	
	/**
	 Potentiates an `SI` by a natural number.
	 
	 - Parameter lhs: Base
	 - Parameter rhs: Exponent
	 - Returns: Scientifically correct exponentiation of `lhs` to the power of `rhs`.
	 */
	public static func **(lhs: Self, rhs: Int) -> Self {
		var returnValue = lhs
		if rhs == 0 {
			return SI(1)
		} else if rhs < 0 {
			for _ in 1 ..< -rhs {
				returnValue = returnValue * lhs
			}
			returnValue = SI(1) / returnValue
		} else {
			for _ in 1..<rhs {
				returnValue = returnValue * lhs
			}
		}
		return returnValue
	}
	
	// MARK: Methods
	/**
	 Converts `SI` value to standard SI-units.
	 
	 - Returns: `self` converted to standard SI-units so that `self.unit.multiplier == 1`
	 */
	public func convertToSI() -> Self {
		let value = value * unit.multiplier
		let unit = Unit(multiplier: 1, dimension: unit.dimension)
		return SI(value, unit)
	}
	
	/**
	 Converts `SI` value to specified `unit`.
	 
	 - Parameter unit: Desired unit
	 - Precondition: Desired dimension and dimension of `self` are equal
	 - Returns: `self` converted to standard unit
	 */
	public func convert(to unit: Unit) -> Self {
		precondition(unit.dimension == self.unit.dimension, "\(unit.dimension) is not equal to \(self.unit.dimension)")
		let value = (value * self.unit.multiplier) / unit.multiplier
		return SI(value, unit)
	}
}

// MARK: Precedence of Exponentiation
precedencegroup ExponentiationPrecedence {
	associativity: left
	higherThan: MultiplicationPrecedence
}
infix operator **: ExponentiationPrecedence
