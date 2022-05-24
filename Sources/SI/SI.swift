//
//  SI.swift
//  Engineering
//
//  Created by Niklas Nickel on 23.06.20.
//  Copyright © 2020 Niklas Nickel. All rights reserved.
//

import Foundation

/// Datatype that supports calculation with dimensional SI-units
public struct SI: Comparable, CustomDebugStringConvertible, Hashable {
	
	/// String representation of the number
	public var debugDescription: String{
		"\(value)\(unit.debugDescription)"
	}
	
	/// Numerical value of the number
	public var value: Double
	
	// MARK: Unit
	/// Unit of the number
	public var unit: Unit
	
	/// Unit of an `SI` number
	public struct Unit: CustomDebugStringConvertible, Equatable, Hashable{
		
		/// Trivial name of the unit
		public var name: String?
		/// Conversion factor to standard `SI` numbers
		public var multiplier: Double
		
		
		// MARK: Dimension
		/// Dimension of the SI unit
		public var dimension: [Base: Int]
		
		/// Basic Physical Dimension of `SI.Unit`
		public struct Base: Equatable, Hashable{
			public var name: String
		}
		
		
		// MARK: Inits
		/**
		 Creates a new `Unit`
		 
		 - Parameter name: Trivial name of the unit
		 - Parameter multiplier: Factor for conversion to standard SI-numbers
		 - Parameter dimension: Dimension of the unit
		 - Precondition: `multiplier != 0`
		 - Returns: The specified `Unit`.
		 */
		public init(_ name: String?, _ multiplier: Double, _ dimension: [Base: Int]) {
			precondition(multiplier != 0)
			self.name = name
			self.multiplier = multiplier
			self.dimension = dimension
		}
		
		/**
		 Creates a new `Unit` from an existing `Unit`
		 
		 - Parameter name: Trivial name of the unit
		 - Parameter unit: Unit to derive the new unit from
		 - Precondition: `multiplier != 0`
		 - Returns: The specified `Unit`.
		 */
		public init(_ name: String?, _ unit: Unit) {
			self.name = name
			multiplier = unit.multiplier
			dimension = unit.dimension
		}
		
		/**
		 Creates a new `Unit` with `name = nil`
		 
		 - Parameter multiplier: Factor for conversion to standard SI-numbers
		 - Parameter dimension: Dimension of the unit
		 - Returns: The specified `Unit`.
		 */
		public init(multiplier: Double, dimension: [Base: Int]) {
			self.init(nil, multiplier, dimension)
		}
		
		// MARK: Equality
		
		/**
		 Determines whether the two units are equal.
		 
		 - Parameter lhs: Left hand argument
		 - Parameter rhs: Right hand argument
		 - Returns: `True` if  `lhs` is equal to `rhs`. Otherwise `False`
		 */
		public static func == (lhs: Self, rhs: Self) -> Bool {
			lhs.multiplier == rhs.multiplier && lhs.dimension == rhs.dimension
		}
	}
	
	// MARK: Inits
	/**
	 Creates a new `SI` number with specified value and unit
	 
	 - Parameter value: Numerical value of the number
	 - Parameter unit: Unit of the number
	 - Returns: An `SI` number with specified value and unit.
	 */
	public init(_ value: Double, _ unit: Unit) {
		self.value = value
		self.unit = unit
	}
	
	/**
	 Creates a new `SI` number with scalar dimension
	 
	 - Parameter value: Numerical value of the number
	 - Returns: An `SI` scalar with specified value.
	 */
	public init(_ value: Double) {
		self.init(value, Unit("", 1, [:]))
	}
	
}
