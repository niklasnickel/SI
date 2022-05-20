//
//  File.swift
//  
//
//  Created by Niklas Nickel on 20.05.22.
//

import Foundation

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


/**
 Takes the square root of an `SI` value.
 
 - Parameter variable: Left hand argument
 - Precondition:`value` has a dimension that supports a square root and positive magnetude.
 - Returns: Scientifically correct root of `value`
 */
func sqrt(_ value: SI) -> SI {
	let dim = value.unit.dimension
	precondition(value.value >= 0, "Cannot compute sqrt: Value is negative.")
	precondition(dim.m % 2 == 0 && dim.kg % 2 == 0 && dim.s % 2 == 0, "Cannot compute sqrt: Unit is no square.")
	
	let newValue = value.value.squareRoot()
	let newDimension = SI.Unit.Dimension(m: dim.m / 2, kg: dim.kg / 2, s: dim.s / 2)
	return SI(newValue, SI.Unit(multiplier: value.unit.multiplier, dimension: newDimension))
}