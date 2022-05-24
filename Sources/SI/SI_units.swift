//
//  File.swift
//  
//
//  Created by Niklas Nickel on 20.05.22.
//

import Foundation

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
	/// Adds a Dimension to another dimension
	///
	/// Example: `Unit.m.addDimension(to: Unit.m) = ["m" : 2]`
	internal func addDimension(to other: SI.Unit) -> [Base : Int] {
		let output = dimension.merging(other.dimension, uniquingKeysWith: +)
		return output.filter {$0.value != 0}
	}
	
	/// Subtracts a Dimension from another dimension
	///
	/// Example: `Unit.m.subtractDimension(to: Unit.s) = ["m" : 1, "s" : -1]`
	internal func subtractDimension(from other: SI.Unit) -> [Base: Int]{
		let output = dimension.mapValues(-).merging(other.dimension, uniquingKeysWith: +)
		return output.filter {$0.value != 0}
	}
}

// MARK: Prefixes
public let Y = addPrefix("Y", conversion: 1e24)
public let Z = addPrefix("Z", conversion: 1e21)
public let E = addPrefix("E", conversion: 1e18)
public let P = addPrefix("P", conversion: 1e15)
public let T = addPrefix("T", conversion: 1e12)
public let G = addPrefix("G", conversion: 1e9)
public let M = addPrefix("M", conversion: 1e6)
public let k = addPrefix("k", conversion: 1e3)
public let h = addPrefix("h", conversion: 1e2)
public let da = addPrefix("da", conversion: 1e1)

public let d = addPrefix("c", conversion: 1e-1)
public let c = addPrefix("c", conversion: 1e-2)
public let m = addPrefix("m", conversion: 1e-3)
public let µ = addPrefix("µ", conversion: 1e-6)
public let n = addPrefix("c", conversion: 1e-9)
public let p = addPrefix("p", conversion: 1e-12)
public let f = addPrefix("f", conversion: 1e-15)
public let a = addPrefix("a", conversion: 1e-18)
public let z = addPrefix("c", conversion: 1e-21)
public let y = addPrefix("y", conversion: 1e-24)


internal func addPrefix(_ prefix: String, conversion: Double) -> (SI.Unit) -> SI.Unit {
	func out(_ unit: SI.Unit) -> SI.Unit{
		var name: String? = nil
		if let name_orig = unit.name {name = prefix + name_orig}
		return SI.Unit(name, unit.multiplier * conversion, unit.dimension)
	}
	return out
}
