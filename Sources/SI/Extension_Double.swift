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
