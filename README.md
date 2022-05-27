# Dimensional arithmetics in Swift

This package provides an easy and natural way of dealing with physical sizes. Performing complex arithmetics or unit conversion is as easy as using ``Double`` values. Check out the code below, to get a glimpse on what is possible with this package.

```swift
let area = 2.4[.m] * 5.86[.inch] // Area of a rectangle 2.4m x 5.86"
let force = 52.36[.lb] * SI.g // Force exceeded by a mass of 52.36℔ under gravity
let pressure = force / area // Calculate the pressure.
print(pressure.convert(to: .Pa))
```

> **TLDR**  
> - Install this package like any other Swift package using the Swift package manager.
> - Construct an ``SI`` number using ``SI(_ value: Double, _ unit: SI.Unit)`` or the subscript notation
>   ```swift
>   let v1 = SI(2.5, .m / .s)
>   let v2 = 2.5[.m / .s]
>   ```
> - Perform any calculations you would do with a double, ``SI`` will take care of the rest.
> - To convert an ``SI`` number to a desired unit use ``convert(to: SI.Unit)``
> - Define custom units by natural calculation e.g.
>   ```swift
>   let N = .kg * .m / .s ** 2
>   let lb = SI.Unit("℔", 0.45359237 * kg) 
>   ```
> - You can use physical constants provided under ``SI``


## Basic usage

Every ``SI`` number consists of a ``value`` and a ``unit``. When performing arithmetic operations, the unit of a number is considered to ensure physical accuracy and proper conversion. Adding e.g. *1 m* to *500 mm* will return *1.5 m*, while an addition with *1 s* will result in an error since the physical dimensions of the units mismatch.

### Construction

To construct an ``SI``number you have three options:

1. Using the ``SI`` initializer
   ```swift
   let myLength = SI(2.5, SI.Unit.m) // 2.5 meters
   let myVelocity = SI(2.5, .m / .s) // 2.5 meters per second
   let myScalar = SI(2.5) // 2.5 (scalar value)
   ```
2. Using the subscript shortcut. With this you can create an ``SI`` on the fly subscripting of a ``Double``
   ```swift
   let myLength = 2.5[SI.Unit.m] // 2.5 meters
   let myVelocity = 2.5[.m / .s] // 2.5 meters per second
   let myScalar = 2.5[] // 2.5 (empty subscript for scalar value)
   ```

### Initialization

You can use ``SI`` like a ``Double`` without the struggle of keeping track of unit conversions. Here are some examples

```swift
let l1 = 2[.m] // 2 meters
let l2 = 500[.mm] // 500 millimeters = 0.5 meters

l1 + l2 // 2.5m (2.5[.m])
l1 - l2 // 1.5m (1.5[.m])
l1 * l2 // 1m² (1[.m ** 2])
l1 / l2 // 4 (4[])
2 * l1 // 4m (4[.m])
l1 ** 2 // 4m² (4[.m ** 2])
pow(l1, 2) // 4m² (4[.m ** 2])
sqrt(l1 * l2) // 1m (1[.m])
```

> **Caution** Be careful when adding two ``SI`` numbers with mismatching physical dimensions e.g. ``1[.m] + 2[.s]`` since this will result in a precondition failure.

### Conversion

To convert an ``SI`` number to a desired unit use ``convert()`` or ``convertToSI()`` to convert to an SI unit.

```swift
let myLength = 2.5[.inch].convertToSI() // 0.063 m
let myTime = 24[.hour].convert(to: .day) // 1.0 day
```

> **Caution** Be careful when converting an ``SI`` number to a unit with mismatching physical dimensions e.g. ``1[.m].convert(to: .s)`` since this will result in a precondition failure.

To typecast an ``SI`` to an ``Int`` or ``Double`` just use the initializer.

```swift
let double = Double(2[.m] / 2[.mm]) // 1000.0
let int = Double(2[.mm] / 2[.m]) // 1000
```

> **Caution** Be careful when typecasting an ``SI`` with a non-scalar physical dimensions e.g. ``Double(1.2[.m])`` since this will result in a precondition failure.

## Custom Units

If you find your unit missing in the library of ``SI.Unit``, you can easily create one.

### Creating units on the fly

``SI.Unit`` supports multiplication, division and exponentiation so creating a new unit in place is really easy. 

```swift
let N = .kg * .m / .s ** 2 // Newton
let lb = 0.45359237 * .kg // Pound
```

### Prefixes

To add a prefix to a unit (e.g. N → kN, m → μ), you can use the inbuilt methods.
```swift
let μm = μ(.m) // Micrometer: 1 μm = 10⁻⁶ m
let kN = k(.N) // Kilonewton: 1 kN = 10³ N
```

### Define a named unit

To define a named ``SI.Unit`` you must use the initializer. You can create a new ``SI.Unit`` based of an existing one or one created on the fly. The name is used in the ``customDebugString``.

> **Tip** Add your named units as an extension of ``SI.Unit`` to make them easily available.

```swift
extension SI.Unit {
   public static let N = Self("N", kg * m / (s ** 2)) // Force in Newton
}
let Hz = SI.Unit("Hz", .scalar / .s) // Frequency in Hertz
```

### Unit dimension

An ``SI.Unit`` consists of a ``dimension`` and a ``multiplicator``. The ``dimension`` is a dictionary of type ``[SI.Unit.Base : Int]`` where the key stands for the respective Base dimension and the value for its power. For example
```swift
SI.Unit("m/s", .m / .s).dimension = [SI.Unit.Base.m: 1, SI.Unit.Base.s: -1]
```
The ``multiplicator`` is used to convert the unit to the SI system.

All standard base units are provided in the ``SI`` package. To define a new base unit (e.g. €, happiness,...) extend of ``SI.Unit.Base`` and use the default initializer and provide the standard symbol. Then define the standard unit of the new dimension providing the new ``dimension``, the ``multiplicator`` and a ``name``.
```swift
extension SI.Unit.Base{
   public static let currency = Self(name: "€")
}
extension SI.Unit {
   public static let euro = Self("€", 1, [Base.currency: 1])
}
```


## Contribution

You have found a bug 🐞 or have a question 🤔? Just send me a message or create an issue, and I will try to get back to you as soon as possible. 

You want to develop this package further? Just create a merge request or send me a message. Please add exhaustive test to your new functionality in order to keep this package as stable and reliable as possible. Also, please make sure to document your code to make it legible for other devs. If you have any questions just write me. Thank you very much for your contribution! ✌️
