//
//  File.swift
//  
//
//  Created by Niklas Nickel on 20.05.22.
//

import Foundation


// MARK: Operations
extension SI.Unit.Base{
	/// Length with standard unit Meter (m)
	public static let length = Self(name: "m")
	
	/// Weight with standard unit Kilogram (kg)
	public static let weight = Self(name: "kg")
	
	/// Seconds with standard unit Seconds (s)
	public static let time = Self(name: "s")
}
