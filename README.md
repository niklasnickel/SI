# Dimensional arithmetics in Swift

This package porovides an easy way of dealing with physical sizes. Performing complex arithmetics or unit conversion is as easy as dealing with ``Double`` values. Check out the code below, to get a glimps on what is posible using this package.

```swift
let area = 2.4[.m] * 5.86[.inch] // Area of a rectangle 2.4m x 5.86"
let force = 52.36[.lb] * SI.g // Force exceded by a mass of 52.36℔ under gravity
let preassure = force / area // Calculate the preassure.
print(preassure.convert(to: .Pa))
```

> **TLDR**  
> - Construct an ``SI`` number using ``SI(value: Double, unit: SI.Unit)`` or the subscript notation
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

