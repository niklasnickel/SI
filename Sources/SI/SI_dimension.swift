//
//  File.swift
//  
//
//  Created by Niklas Nickel on 20.05.22.
//

import Foundation


extension SI.Unit.Base{
	/// Length with standard unit Meter (m)
	public static let length = Self(name: "m")
	
	/// Weight with standard unit Kilogram (kg)
	public static let weight = Self(name: "kg")
	
	/// Seconds with standard unit Seconds (s)
	public static let time = Self(name: "s")
	
	/// Current with standard unit Ampere (A)
	public static let current = Self(name: "A")
	
	/// Temperature with standard unit Kelvin (K)
	public static let temperature = Self(name: "K")
	
	/// Amount of substance with standard unit Mole (mol)
	public static let substance_smmount = Self(name: "mol")
	
	/// Luminous intensity with standard unit Candela (cd)
	public static let luminosity = Self(name: "cd")
}
