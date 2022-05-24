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
	static let scalar = Self("", 1, [:])
	static let percentage = Self("%", 0.01 * scalar)
	
	// Length
	static let m = Self("m", 1, [Base.length: 1])
	static let mm = Self("mm", 1e-3 * m)
	
	// Weight
	static let kg = Self("kg", 1, [Base.weight: 1])
	
	// Time
	static let s = Self("s", 1, [Base.time: 1])
	static let min = Self("min", 60 * s)
	static let h = Self("h", 60 * min)
	
	// Frequency
	static let Hz = Self("Hz", scalar / s)
	
	// Velocity
	static let m_s = Self("m/s", m / s)
	
	// Area
	static let m2 = Self("m^2", m ^ 2)
	
	// Force
	static let N = Self("N", kg * m / (s ^ 2))
	static let kN = Self("kN", 1e3 * N)
	
	// Presure
	static let Pa = Self("Pa", N / m2)
	static let MPa = Self("MPa", 1e6 * Pa)
	
	// Spring Constant
	static let N_m = Self("N/m", N / m)
	static let N_mm = Self("N/mm", N / mm)
}


// MARK: String representation
extension SI.Unit{
	var debugDescription: String{
		if let name = name { return name }
		else{
			var dimensionString = " "
			if multiplier != 1{
				dimensionString +=  "x \(multiplier) "
			}
			return dimension.reduce(into: dimensionString) {
				$0 += $1.key.name
			}
		}
	}
}


//MARK: Operations
extension SI.Unit{
	
	static func * (lhs: Self, rhs: Self) -> Self {
		let multiplier = lhs.multiplier * rhs.multiplier
		let dimension = lhs.combineDimension(with: rhs, using: +)
		return SI.Unit(multiplier: multiplier, dimension: dimension)
	}
	
	static func * (lhs: Double, rhs: Self) -> Self {
		let multiplier = lhs * rhs.multiplier
		return SI.Unit(multiplier: multiplier, dimension: rhs.dimension)
	}
	
	static func ^ (lhs: Self, rhs: Int) -> Self {
		var dimension = lhs.dimension
		for _ in 1...rhs-1 {
			dimension = dimension.merging(dimension, uniquingKeysWith: +)
		}
		return SI.Unit(multiplier: pow(lhs.multiplier, Double(rhs)), dimension: dimension)
	}
	
	static func / (lhs: Self, rhs: Self) -> Self {
		let multiplier = lhs.multiplier / rhs.multiplier
		let dimension = lhs.combineDimension(with: rhs, using: -)
		return SI.Unit(multiplier: multiplier, dimension: dimension)
	}
}

// MARK: Dimension
extension SI.Unit{
	func combineDimension(with other: SI.Unit, using method: (Int, Int) -> Int) -> [Base: Int]{
		let output = self.dimension.merging(other.dimension, uniquingKeysWith: method)
		return output.filter {$0.value != 0}
	}
}
