//
//  File.swift
//  
//
//  Created by Niklas Nickel on 20.05.22.
//

import Foundation

// MARK: Constructors from a Double
/**
 SI initialization as a `Double` extension
 */
extension Double {
/**
	 Creates an `SI` from a `Double` using subscripts
	 
	 Usage:
	 ```
	 let force = 150.3[.kN]
	 let area = 1[.m2]
	 let result = force / area // = 1.503[.MPa]
	 ```
	 */
	public subscript(unit: SI.Unit) -> SI {
		SI(self, unit)
	}
/**
	 Creates an `SI` scalar from a `Double` using an empty subscripts
	 
	 Usage:
	 ```
	 let poissonNumber = 0.3[] // = SI(0.3, Unit.scalar)
	 ```
	 */
	public subscript() -> SI {
		SI(self)
	}
}


// MARK: Conversion to real numbers
extension Double{
	/**
	 Creates a ``Double`` from an ``SI`` value.
	 - Precondition: Dimension of unit is scalar (``[:]``)
	*/
	init(_ si: SI){
		precondition(si.unit.dimension == [:], "Cannot convert SI to Double, since the dimension of its unit is not scalar.")
		self.init(si.value * si.unit.multiplier)
	}
}

extension Int{
	/**
	 Creates an ``Int`` from an ``SI`` value.
	 - Precondition: Dimension of unit is scalar (``[:]``)
	*/
	init(_ si: SI){
		precondition(si.unit.dimension == [:], "Cannot convert SI to Int, since the dimension of its unit is not scalar.")
		self.init(si.value * si.unit.multiplier)
	}
}

// MARK: Functions
/**
 Takes the square root of an `SI` value.
 
 - Parameter value: Value to take the root of.
 - Precondition:`value` has a dimension that supports a square root and positive magnitude.
 - Returns: Scientifically correct root of `value`
 */
public func sqrt(_ value: SI) -> SI {
	let dim = value.unit.dimension
	precondition(value.value >= 0, "Cannot compute sqrt: Value is negative.")
	precondition(0 == dim.reduce(0) { $0 + $1.value % 2 }, "Cannot compute sqrt: Unit is no square.")
	
	let newValue = value.value.squareRoot()
	let newDimension = dim.mapValues { $0 / 2 }
	return SI(newValue, SI.Unit(multiplier: value.unit.multiplier, dimension: newDimension))
}

/**
Alias for SI potentiation
 */
public func pow(_ value: SI, _ exponent: Int) -> SI{
	value ** exponent
}
