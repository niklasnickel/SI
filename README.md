# Dimensional arithmetics in Swift

This package porovides an easy way of dealing with physical sizes. Performing complex arithmetics or unit conversion is as easy as dealing with ``Double`` values. Check out the code below, to get a glimps on what is posible using this package.

```swift
let area = 2.4[.m] * 5.86[.inch] // Area of a rectangle 2.4m x 5.86"
let force = 52.36[.lb] * SI.g // Force exceded by a mass of 52.36℔ under gravity
let preassure = force / area // Calculate the preassure.
print(preassure.convert(to: .Pa))
```

> **TLDR**  
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

Every ``SI`` number is comprised of a ``value`` and a ``unit``. When performing arithmetic operations, the unit of a number is considered to ensure physical accuracy and proper conversion. Adding e.g. *1 m* to *500 mm* will return *1.5 m*, while an addition with *1 s* will result in an error since the physical dimentions of the units mismatch.

### Construction

To constract an ``SI``number you have three options:

1. Using the ``SI`` initializer
   ```swift
   let myLength = SI(2.5, SI.Unit.m) // 2.5 meters
   let myVelocity = SI(2.5, .m / .s) // 2.5 meters per second
   let myScalar = SI(2.5) // 2.5 (scalar value)
   ```
2. Using the subscript shortcut. Whith this you can create an ``SI`` on the fly subscripting of a ``Double``
   ```swift
   let myLength = 2.5[SI.Unit.m] // 2.5 meters
   let myVelocity = 2.5[.m / .s] // 2.5 meters per second
   let myScalar = 2.5[] // 2.5 (empty subscript for scalar value)
   ```

### Calculation

You can use ``SI`` like a ``Double`` without the struggle of keepng track of unit conversions. Here are some examples

```swift
let l1 = 2[.m] // 2 meters
let l2 = 500[.mm] // 500 millimeters = 0.5 meters

l1 + l2 // 2.5m (2.5[.m])
l1 - l2 // 1.5m (1.5[.m])
l1 * l2 // 1m² (1[.m ** 2])
l1 / l2 // 4 (4[])
2 * l1 // 4m (4[.m])
l1 ** 2 // 4m² (4[.m ** 2])
sqrt(l1 * l2) // 1m (1[.m])
```

> **Caution** Be careful when adding two ``SI`` numbers with mismathing physical dimensions e.g. ``1[.m] + 2[.s]`` since this will result in a precondition failure.

### Conversion

To convert an ``SI`` number to a desired unit use ``convert()`` or ``convertToSI()`` to convert to an SI unit.

```swift
let myLength = 2.5[.inch].convertToSI() // 0.063 m
let myTime = 24[.hour].convert(to: .day) // 1.0 day
```



