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
	static let scalar = Self("", 1, .scalar)
	static let percentage = Self("%", 0.01, .scalar)
	// Length
	static let m = Self("m", 1, .length)
	static let mm = Self("mm", 1e-3, .length)
	// Time
	static let s = Self("s", 1, .time)
	static let min = Self("min", 60, .time)
	static let h = Self("h", 3600, .time)
	// Frequency
	static let Hz = Self("Hz", 1, .scalar - .time)
	// Velocity
	static let m_s = Self("m/s", 1, .length - .time)
	// Area
	static let m2 = Self("m^2", 1, .area)
	// Presure
	static let MPa = Self("MPa", 1e6, .force - .area)
	// Force
	static let N = Self("N", 1, .force)
	static let kN = Self("kN", 1e3, .force)
	// Spring Constant
	static let N_m = Self("N/m", 1, .force - .length)
	static let N_mm = Self("N/mm", 1e3, .force - .length)
}

// MARK: String representation
extension SI.Unit{
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
}