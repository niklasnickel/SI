//
//  File.swift
//  
//
//  Created by Niklas Nickel on 20.05.22.
//

import Foundation


//MARK: Presets
extension SI.Unit{
	// Scalar
	public static let scalar = Self("", 1, [:])
	public static let percentage = Self("%", 0.01 * scalar)
	
	// Length
	public static let m = Self("m", 1, [Base.length: 1])
	public static let mm = Self("mm", 1e-3 * m)
	
	// Weight
	public static let kg = Self("kg", 1, [Base.weight: 1])
	
	// Time
	public static let s = Self("s", 1, [Base.time: 1])
	public static let min = Self("min", 60 * s)
	public static let h = Self("h", 60 * min)
	
	// Frequency
	public static let Hz = Self("Hz", scalar / s)
	
	// Velocity
	public static let m_s = Self("m/s", m / s)
	
	// Area
	public static let m2 = Self("m²", m ** 2)
	
	// Force
	public static let N = Self("N", kg * m / (s ** 2))
	public static let kN = Self("kN", 1e3 * N)
	
	// Presure
	public static let Pa = Self("Pa", N / m2)
	public static let MPa = Self("MPa", 1e6 * Pa)
	
	// Spring Constant
	public static let N_m = Self("N/m", N / m)
	public static let N_mm = Self("N/mm", N / mm)
}


// MARK: String representation
extension SI.Unit{
	public var debugDescription: String{
		if let name = name { return " " + name }
		else{
			var dimensionString = ""
			if multiplier != 1{
				dimensionString +=  " x \(multiplier)"
			}
			return dimension.reduce(into: dimensionString) {
				$0 += " \($1.key.name)^\($1.value)"
			}
		}
	}
}


//MARK: Operations
extension SI.Unit{
	
	public static func * (lhs: Self, rhs: Self) -> Self {
		let multiplier = lhs.multiplier * rhs.multiplier
		let dimension = lhs.addDimension(to: rhs)
		return SI.Unit(multiplier: multiplier, dimension: dimension)
	}
	
	public static func * (lhs: Double, rhs: Self) -> Self {
		let multiplier = lhs * rhs.multiplier
		return SI.Unit(multiplier: multiplier, dimension: rhs.dimension)
	}
	
	public static func ** (lhs: Self, rhs: Int) -> Self {
		var dimension = lhs.dimension
		for _ in 1...rhs-1 {
			dimension = dimension.merging(dimension, uniquingKeysWith: +)
		}
		return SI.Unit(multiplier: pow(lhs.multiplier, Double(rhs)), dimension: dimension)
	}
	
	public static func / (lhs: Self, rhs: Self) -> Self {
		let multiplier = lhs.multiplier / rhs.multiplier
		let dimension = rhs.subtractDimension(from: lhs)
		return SI.Unit(multiplier: multiplier, dimension: dimension)
	}
}

// MARK: Dimension
extension SI.Unit{
	/// Adds a Dimention to another dimension
	///
	/// Example: `Unit.m.addDimension(to: Unit.m) = ["m" : 2]`
	internal func addDimension(to other: SI.Unit) -> [Base : Int] {
		let output = self.dimension.merging(other.dimension, uniquingKeysWith: +)
		return output.filter {$0.value != 0}
	}
	
	/// Subtracts a Dimention from another dimension
	///
	/// Example: `Unit.m.subtractDimension(to: Unit.s) = ["m" : 1, "s" : -1]`
	internal func subtractDimension(from other: SI.Unit) -> [Base: Int]{
		let output = self.dimension.mapValues(-).merging(other.dimension, uniquingKeysWith: +)
		return output.filter {$0.value != 0}
	}
}
