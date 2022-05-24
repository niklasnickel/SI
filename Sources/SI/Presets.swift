//
//  Presets.swift
//  
//
//  Created by Niklas Nickel on 20.05.22.
//

import Foundation

// MARK: Base Units
extension SI.Unit.Base {
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
	public static let substance_amount = Self(name: "mol")
	
	/// Luminous intensity with standard unit Candela (cd)
	public static let luminosity = Self(name: "cd")
}


//MARK: Base Units → Scalar
extension SI.Unit {
	/// Dimensionless number
	public static let scalar = Self("", 1, [:])
	
	/// Percent 1% = 0.01 ``scalar``
	public static let percentage = Self("%", 0.01 * scalar)
	
	/// Permille 1‰ = 0.001 ``scalar``
	public static let permille = Self("‰", 0.001 * scalar)
}


//MARK: Base Units → Length
extension SI.Unit {
	/// Meter (Standard unit for ``Base.length``
	public static let m = Self("m", 1, [Base.length: 1])
	
	/// Millimetre 1mm = 0.001 ``m``
	public static let mm = Self("mm", 1e-3 * m)
}


//MARK: Base Units → Weight
extension SI.Unit {
	/// Kilogram (Standard unit for ``Base.weight``
	public static let kg = Self("kg", 1, [Base.weight: 1])
}


//MARK: Base Units → Time
extension SI.Unit {
	/// Second (Standard unit for ``Base.time``
	public static let s = Self("s", 1, [Base.time: 1])
	
	/// Minute 1 min = 60 ``s``
	public static let min = Self("min", 60 * s)
	
	/// Hour 1 h = 60 ``min``
	public static let h = Self("h", 60 * min)
	
	/// Day 1 d = 24 ``h``
	public static let d = Self("d", 24 * h)
	
	/// Week 1 week = 7 ``d``
	public static let week = Self("week", 7 * d)
	
	/// Month 1 month = 30.5 ``d``
	public static let month = Self("month", 30.5 * d)
	
	/// Year 1 a = 356 ``d``
	public static let a = Self("a", 356 * d)
}


//MARK: Combined Units
extension SI.Unit {
	// Frequency
	public static let Hz = Self("Hz", scalar / s)
	
	// Velocity
	public static let m_s = Self("m/s", m / s)
	
	// Area
	public static let m2 = Self("m²", m ** 2)
	
	// Force
	public static let N = Self("N", kg * m / (s ** 2))
	public static let kN = Self("kN", 1e3 * N)
	
	// Pressure
	public static let Pa = Self("Pa", N / m2)
	public static let MPa = Self("MPa", 1e6 * Pa)
	
	// Spring Constant
	public static let N_m = Self("N/m", N / m)
	public static let N_mm = Self("N/mm", N / mm)
}

