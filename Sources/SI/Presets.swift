//
//  File.swift
//  
//
//  Created by Niklas Nickel on 20.05.22.
//

import Foundation

// MARK: Base Units
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

//MARK: Units
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

