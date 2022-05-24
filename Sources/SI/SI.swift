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
		
		/// Trivial name of the unit
		var name: String?
		/// Conversion factor to standart `SI` numbers
		var multiplier: Double
		
		// MARK: Dimension
		/// Dimension of the SI unit
		var dimension: [Base: Int]
		
		/// Basic Physical Dimension of `SI.Unit`
		struct Base: Equatable, Hashable{
			var name: String
		}
		
		// MARK: Inits
		
		/**
		 Creates a new `Unit`
		 
		 - Parameter name: Trivial name of the unit
		 - Parameter multiplier: Factor for conversion to standart SI-numbers
		 - Parameter dimension: Dimesion of the unit
		 - Precondition: `multiplier != 0`
		 - Returns: The specified `Unit`.
		 */
		init(_ name: String?, _ multiplier: Double, _ dimension: [Base: Int]) {
			precondition(multiplier != 0)
			self.name = name
			self.multiplier = multiplier
			self.dimension = dimension
		}
		
		/**
		 Creates a new `Unit` from an existing `Unit`
		 
		 - Parameter name: Trivial name of the unit
		 - Parameter multiplier: Factor for conversion to standart SI-numbers
		 - Parameter dimension: Dimesion of the unit
		 - Precondition: `multiplier != 0`
		 - Returns: The specified `Unit`.
		 */
		init(_ name: String?, _ unit: Unit) {
			self.name = name
			self.multiplier = unit.multiplier
			self.dimension = unit.dimension
		}
		
		/**
		 Creates a new `Unit` with `name = nil`
		 
		 - Parameter multiplier: Factor for conversion to standart SI-numbers
		 - Parameter dimension: Dimesion of the unit
		 - Returns: The specified `Unit`.
		 */
		init(multiplier: Double, dimension: [Base: Int]) {
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
		self.init(value, Unit("", 1, [:]))
	}
	
}
