//
//  SI.swift
//  Engineering
//
//  Created by Niklas Nickel on 23.06.20.
//  Copyright © 2020 Niklas Nickel. All rights reserved.
//

import Foundation

/// Datatype that supports calculation with dimensional SI-units
struct SI: Comparable, CustomDebugStringConvertible, Hashable {
	
	/// String representation of the number
	var debugDescription: String{
		"\(value) \(unit.debugDescription)"
	}
	
	/// Numerical value of the number
	var value: Double
	
	// MARK: Unit
	/// Unit of the number
	var unit: Unit
	
	/// Unit of an `SI` number
	struct Unit: CustomDebugStringConvertible, Equatable, Hashable{
		
		/// String representation
		var debugDescription: String{
			if name != nil{
				return name!
			}
			else{
				var dimensionString = " "
				if multiplier != 1{
					dimensionString +=  "x \(multiplier) "
				}
				if dimension.kg != 0{
					dimensionString += "kg^\(dimension.kg)"
				}
				if dimension.m != 0{
					dimensionString += "m^\(dimension.m)"
				}
				if dimension.s != 0{
					dimensionString += "s^\(dimension.s)"
				}
				return dimensionString
			}
		}
		
		/// Trivial name of the unit
		var name: String?
		/// Conversion factor to standart `SI` numbers
		var multiplier: Double
		
		// MARK: Dimension
		/// Dimension of the SI unit
		var dimension: Dimension
		
		/// Physical Dimension of `SI.Unit`
		struct Dimension: Equatable, Hashable{
			/// Power of meters
			var m: Int
			/// Power of kilograms
			var kg: Int
			/// Power of seconds
			var s: Int
			
			// MARK: Presets
			
			/// Scalar number: Dimension == 1
			static let scalar = Dimension(m: 0, kg: 0, s: 0)
			/// Length
			static let length = Dimension(m: 1, kg: 0, s: 0)
			/// Area
			static let area = Dimension(m: 2, kg: 0, s: 0)
			/// Time
			static let time = Dimension(m: 0, kg: 0, s: 1)
			/// Force
			static let force = Dimension(m: 1, kg: 1, s: -2)
			
			// MARK: Operations
			
			/**
			 Adds two `SIdimensions`.
			 
			 - Parameter lhs: Left hand argument
			 - Parameter rhs: Rhight hand argument
			 - Returns: An `Dimension`where every basic dimension was the sum of `lhs` and `rhs`.
			 */
			static func + (lhs: Self, rhs: Self) -> Self {
				return Dimension(m: lhs.m + rhs.m, kg: lhs.kg + rhs.kg, s: lhs.s + rhs.s)
			}
			
			/**
			 Subtracts two `SIdimensions`.
			 
			 - Parameter lhs: Left hand argument
			 - Parameter rhs: Rhight hand argument
			 - Returns: An `Dimension`where every basic dimension was the difference of `lhs` and `rhs`.
			 */
			static func - (lhs: Self, rhs: Self) -> Self {
				return Dimension(m: lhs.m - rhs.m, kg: lhs.kg - rhs.kg, s: lhs.s - rhs.s)
			}
		}
		
		//MARK: Presets
		
		// Scalar
		static let scalar = Unit("", 1, .scalar)
		static let percentage = Unit("%", 0.01, .scalar)
		// Length
		static let m = Unit("m", 1, .length)
		static let mm = Unit("mm", 1e-3, .length)
		// Time
		static let s = Unit("s", 1, .time)
		static let min = Unit("min", 60, .time)
		static let h = Unit("h", 3600, .time)
		// Frequency
		static let Hz = Unit("Hz", 1, .scalar - .time)
		// Velocity
		static let m_s = Unit("m/s", 1, .length - .time)
		// Area
		static let m2 = Unit("m^2", 1, .area)
		// Presure
		static let MPa = Unit("MPa", 1e6, .force - .area)
		// Force
		static let N = Unit("N", 1, .force)
		static let kN = Unit("kN", 1e3, .force)
		// Spring Constant
		static let N_m = Unit("N/m", 1, .force - .length)
		static let N_mm = Unit("N/mm", 1e3, .force - .length)
		
		// MARK: Inits
		
		/**
		 Creates a new `Unit`
		 
		 - Parameter name: Trivial name of the unit
		 - Parameter multiplier: Factor for conversion to standart SI-numbers
		 - Parameter dimension: Dimesion of the unit
		 - Precondition: `multiplier != 0`
		 - Returns: The specified `Unit`.
		 */
		init(_ name: String?, _ multiplier: Double, _ dimension: Dimension) {
			precondition(multiplier != 0)
			self.name = name
			self.multiplier = multiplier
			self.dimension = dimension
		}
		
		/**
		 Creates a new `Unit` with `name = nil`
		 
		 - Parameter multiplier: Factor for conversion to standart SI-numbers
		 - Parameter dimension: Dimesion of the unit
		 - Returns: The specified `Unit`.
		 */
		init(multiplier: Double, dimension: Dimension) {
			self.init(nil, multiplier, dimension)
		}
		
		// MARK: Equality
		
		/**
		 Determines wether the two units are equal.
		 
		 - Parameter lhs: Left hand argument
		 - Parameter rhs: Rhight hand argument
		 - Returns: `True` if  `lhs` is equal to `rhs`. Otherwise `False`
		 */
		static func == (lhs: Self, rhs: Self) -> Bool {
			return lhs.multiplier == rhs.multiplier && lhs.dimension == rhs.dimension
		}
	}
	
	// MARK: Inits
	/**
	 Creates a new `SI` number with specified value and unit
	 
	 - Parameter value: Numerical value of the number
	 - Parameter unit: Unit of the number
	 - Returns: An `SI` number with specified value and unit.
	 */
	init(_ value: Double, _ unit: Unit) {
		self.value = value
		self.unit = unit
	}
	
	/**
	 Creates a new `SI` number with scalar dimension
	 
	 - Parameter value: Numerical value of the number
	 - Returns: An `SI` scalar with specified value.
	 */
	init(_ value: Double) {
		self.init(value, Unit("", 1, Unit.Dimension.scalar))
	}
	
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

// MARK: Double extension
/**
 SI initialization as a `Double` extension
 */
extension Double{
	/**
	 Creates an `SI` from a `Double` using subsripts
	 
	 Usage:
	 ```
	 let force = 150.3[.kN]
	 let area = 1[.m2]
	 let result = force / area // = 1.503[.MPa]
	 ```
	 */
	subscript(unit: SI.Unit) -> SI{
		SI(self, unit)
	}
	/**
	 Creates an `SI` scalar from a `Double` using an empty subsripts
	 
	 Usage:
	 ```
	 let poissonNumber = 0.3[] // = SI(0.3, Unit.scalar)
	 ```
	 */
	subscript() -> SI{
		SI(self)
	}
}
