//
//  File.swift
//  
//
//  Created by Niklas Nickel on 20.05.22.
//

import Foundation

// MARK: Presets
extension SI.Unit.Dimension{
	
	/// Scalar number: Dimension == 1
	static let scalar = Self(m: 0, kg: 0, s: 0)
	/// Length
	static let length = Self(m: 1, kg: 0, s: 0)
	/// Area
	static let area = Self(m: 2, kg: 0, s: 0)
	/// Time
	static let time = Self(m: 0, kg: 0, s: 1)
	/// Force
	static let force = Self(m: 1, kg: 1, s: -2)
}


// MARK: Operations
extension SI.Unit.Dimension{
	
	/**
	 Adds two `SIdimensions`.
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Rhight hand argument
	 - Returns: An `Dimension`where every basic dimension was the sum of `lhs` and `rhs`.
	 */
	static func + (lhs: Self, rhs: Self) -> Self {
		return Self(m: lhs.m + rhs.m, kg: lhs.kg + rhs.kg, s: lhs.s + rhs.s)
	}
	
	/**
	 Subtracts two `SIdimensions`.
	 
	 - Parameter lhs: Left hand argument
	 - Parameter rhs: Rhight hand argument
	 - Returns: An `Dimension`where every basic dimension was the difference of `lhs` and `rhs`.
	 */
	static func - (lhs: Self, rhs: Self) -> Self {
		return Self(m: lhs.m - rhs.m, kg: lhs.kg - rhs.kg, s: lhs.s - rhs.s)
	}
}
