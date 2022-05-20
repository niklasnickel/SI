//
//  File.swift
//  
//
//  Created by Niklas Nickel on 19.05.22.
//

import Foundation

extension SI {
	
	// MARK: Comparison
	/**
	 Determines wether `lhs` is approximately equal to `rhs` with a precision of `precision`
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Rhight hand argument
	 - Returns: `True` if  `lhs` is approximately equal to `rhs` with a precision of `precision`. Otherwise `False`
	 */
	static func == (lhs: Self, rhs: Self) -> Bool{
		let precision = 1e-9
		var valueEquals: Bool
		if rhs.unit == lhs.unit{
			valueEquals = fabs(lhs.value.distance(to: rhs.value)) <= precision
		}
		else{
			valueEquals = fabs(lhs.convertToSI().value.distance(to: rhs.convertToSI().value)) <= precision
		}
		let dimensionEquals = lhs.unit.dimension == rhs.unit.dimension
		return valueEquals && dimensionEquals
	}
	
	/**
	 Determines wether `lhs` is approximately less than `rhs`
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Rhight hand argument
	 - Returns: `True` if  `lhs` is scientifically less than `rhs`. Otherwise `False`
	 */
	static func < (lhs: SI, rhs: SI) -> Bool {
		let dimensionEquals = lhs.unit.dimension == rhs.unit.dimension
		let valueCompare = lhs.convertToSI().value < rhs.convertToSI().value
		return valueCompare && dimensionEquals
	}
	
	//MARK: Multiplication
	/**
	 Multiplies two `SI` values.
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Rhight hand argument
	 - Returns: Scientifically correct product of `lhs` and `rhs`.
	 */
	static func * (lhs: Self, rhs: Self) -> Self{
		let value = lhs.convertToSI().value * rhs.convertToSI().value
		let unit = Unit(multiplier: 1, dimension: lhs.unit.dimension + rhs.unit.dimension)
		return SI(value, unit)
	}
	/**
	 Multiplies a scalar `Double`with an `SI` value.
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Rhight hand argument
	 - Returns: Scientifically correct product of `lhs` and `rhs`.
	 */
	static func * (lhs: Double, rhs: Self) -> Self{
		let value = lhs * rhs.value
		return SI(value, rhs.unit)
	}
	/**
	 Multiplies an `SI` value with a scalar `Double`.
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Rhight hand argument
	 - Returns: Scientifically correct product of `lhs` and `rhs`.
	 */
	static func * (lhs: Self, rhs: Double) -> Self{
		return rhs * lhs
	}
	
	//MARK: Division
	/**
	 Divides two `SI` values.
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Rhight hand argument
	 - Returns: Scientifically correct fraction of `lhs` and `rhs`.
	 */
	static func / (lhs: Self, rhs: Self) -> Self{
		let value = lhs.convertToSI().value / rhs.convertToSI().value
		let unit = Unit(multiplier: 1, dimension: lhs.unit.dimension - rhs.unit.dimension)
		return SI(value, unit)
	}
	/**
	 Divides a scalar `Double` by an `SI` value.
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Rhight hand argument
	 - Returns: Scientifically correct fraction of `lhs` and `rhs`.
	 */
	static func / (lhs: Double, rhs: Self) -> Self{
		let value = lhs / rhs.value
		let unit = Unit(multiplier: rhs.unit.multiplier, dimension: Unit.Dimension(m: 0, kg: 0, s: 0)-rhs.unit.dimension)
		return SI(value, unit)
	}
	/**
	 Divides an `SI` value by a scalar `Double`.
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Rhight hand argument
	 - Returns: Scientifically correct fraction of `lhs` and `rhs`.
	 */
	static func / (lhs: Self, rhs: Double) -> Self{
		let value = lhs.value / rhs
		return SI(value, lhs.unit)
	}
	
	//MARK: Addition
	/**
	 Adds two `SI` values if they share the same dimension.
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Rhight hand argument
	 - Precondition: Dimension of `rhs` and dimesion of `lhs` are equal
	 - Returns: Scientifically correct sum of `lhs` and `rhs`.
	 */
	static func + (lhs: Self, rhs: Self) -> Self {
		precondition(lhs.unit.dimension == rhs.unit.dimension)
		// Convert to common unit
		let value = lhs.convertToSI().value + rhs.convertToSI().value
		return SI(value, Unit(multiplier: 1, dimension: lhs.unit.dimension))
	}
	/**
	 Adds a `Double` to an `SI` value.
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Rhight hand argument
	 - Returns: Sum of `lhs` and `rhs` as an `SI`number.
	 */
	static func + (lhs: Double, rhs: Self) -> SI {
		return SI(lhs) + rhs
	}
	/**
	 Adds an `SI` value to a `Double`.
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Rhight hand argument
	 - Returns: Sum of `lhs` and `rhs` as an `SI`number.
	 */
	static func + (lhs: Self, rhs: Double) -> SI {
		return lhs + SI(rhs)
	}
	
	//MARK: Subtraction
	/**
	 Subtracts two `SI` values if they share the same dimension.
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Rhight hand argument
	 - Precondition: Dimension of `rhs` and dimesion of `lhs` are equal
	 - Returns: Scientifically correct difference of `lhs` and `rhs`.
	 */
	static func - (lhs: Self, rhs: Self) -> Self {
		precondition(lhs.unit.dimension == rhs.unit.dimension)
		// Convert to common unit
		let value = lhs.convertToSI().value - rhs.convertToSI().value
		return SI(value, Unit(multiplier: 1, dimension: lhs.unit.dimension))
	}
	/**
	 Subtracts a `Double` from an `SI` value.
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Rhight hand argument
	 - Returns: Difference of `lhs` and `rhs` as an `SI`number.
	 */
	static func - (lhs: Double, rhs: Self) -> Self {
		return SI(lhs) - rhs
	}
	/**
	 Subtracts an `SI` value from a `Double`.
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Rhight hand argument
	 - Returns: Difference of `lhs` and `rhs` as an `SI`number.
	 */
	static func - (lhs: Self, rhs: Double) -> Self {
		return lhs - SI(rhs)
	}
	
	// MARK: Other operators
	/**
	 Negates the `SI` value.
	 
	 - Parameter lhs: Left hand argument
	 - Returns: Scientifically correct negation of `lhs`.
	 */
	static prefix func - (lhs: Self) -> Self {
		return SI(-lhs.value, Unit(multiplier: 1, dimension: lhs.unit.dimension))
	}
	
	/**
	 Takes the square root of an `SI` value.
	 
	 - Parameter variable: Left hand argument
	 - Precondition:`value` has a dimension that supports a square root.
	 - Returns: Scientifically correct root of `value` or `nil` if `value` is negative.
	 */
	static func sqrt(_ value: Self) -> Self? {
		let dim = value.unit.dimension
		let valueValid = value.value >= 0
		let dimValid = dim.m % 2 == 0 && dim.kg % 2 == 0 && dim.s % 2 == 0
		precondition(dimValid)
		if valueValid{
			let newValue = value.value.squareRoot()
			let newDimension = Unit.Dimension(m: dim.m / 2, kg: dim.kg / 2, s: dim.s / 2)
			return SI(newValue, Unit(multiplier: value.unit.multiplier, dimension: newDimension))
		}
		else{
			return nil
		}
	}
	
	/**
	 Potentiates an `SI` by a natural number.
	 
	 - Parameter lhs: Base
	 - Parameter rhs: Exponent
	 - Returns: Scientifically correct potentation of `lhs` to the power of `rhs`.
	 */
	static func ^ (lhs: Self, rhs: Int) -> Self{
		var returnValue = lhs
		if rhs == 0{
			return SI(1)
		} else if rhs < 0{
			for _ in 1 ..< -rhs{
				returnValue = returnValue * lhs
			}
			returnValue = SI(1) / returnValue
		} else{
			for _ in 1 ..< rhs{
				returnValue = returnValue * lhs
			}
		}
		return returnValue
	}
	
	// MARK: Methods
	/**
	 Converts `SI` value to standart SI-units.
	 
	 - Returns: `self` converted to standart SI-units so that `self.unit.mulipiler == 1`
	 */
	func convertToSI() -> Self{
		let value = self.value * self.unit.multiplier
		let unit = Unit(multiplier: 1, dimension: self.unit.dimension)
		return SI(value, unit)
	}
	
	/**
	 Converts `SI` value to specified `unit`.
	 
	 - Parameter unit: Desired unit
	 - Precondition: Desired dimension and dimesion of `self` are equal
	 - Returns: `self` converted to standart unit
	 */
	func convert(to unit: Unit) -> Self {
		precondition(unit.dimension == self.unit.dimension, "\(unit.dimension) is not equal to \(self.unit.dimension)")
		let value = (self.value * self.unit.multiplier) / unit.multiplier
		return SI(value, unit)
	}
}