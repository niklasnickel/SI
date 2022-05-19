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
