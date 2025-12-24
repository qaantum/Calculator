import Foundation

// Geometry Calculators

// Circle Properties
struct CircleResult { let circumference: Double; let area: Double; let diameter: Double }
class CircleCalculator {
    func fromRadius(_ r: Double) -> CircleResult { CircleResult(circumference: 2 * .pi * r, area: .pi * r * r, diameter: 2 * r) }
    func fromDiameter(_ d: Double) -> CircleResult { CircleResult(circumference: .pi * d, area: .pi * pow(d/2, 2), diameter: d) }
}

// Slope Calculator
struct SlopeResult { let slope: Double; let yIntercept: Double; let equation: String; let distance: Double }
class SlopeCalculator {
    func calculate(x1: Double, y1: Double, x2: Double, y2: Double) -> SlopeResult {
        let slope = (y2 - y1) / (x2 - x1); let yInt = y1 - slope * x1
        let dist = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2))
        return SlopeResult(slope: slope, yIntercept: yInt, equation: "y = \(slope)x + \(yInt)", distance: dist)
    }
}

// Triangle Calculator
struct TriangleResult { let area: Double; let perimeter: Double; let hypotenuse: Double? }
class TriangleCalculator {
    func fromBaseHeight(base: Double, height: Double) -> TriangleResult { TriangleResult(area: 0.5 * base * height, perimeter: 0, hypotenuse: nil) }
    func fromSides(a: Double, b: Double, c: Double) -> TriangleResult {
        let s = (a + b + c) / 2; let area = sqrt(s * (s-a) * (s-b) * (s-c))
        return TriangleResult(area: area, perimeter: a + b + c, hypotenuse: nil)
    }
    func pythagorean(a: Double, b: Double) -> TriangleResult { TriangleResult(area: 0.5 * a * b, perimeter: a + b + sqrt(a*a + b*b), hypotenuse: sqrt(a*a + b*b)) }
}

// Volume Calculator
struct VolumeResult { let volume: Double; let surfaceArea: Double }
class VolumeCalculator {
    func cube(side: Double) -> VolumeResult { VolumeResult(volume: pow(side, 3), surfaceArea: 6 * pow(side, 2)) }
    func sphere(radius: Double) -> VolumeResult { VolumeResult(volume: (4.0/3.0) * .pi * pow(radius, 3), surfaceArea: 4 * .pi * pow(radius, 2)) }
    func cylinder(radius: Double, height: Double) -> VolumeResult { VolumeResult(volume: .pi * pow(radius, 2) * height, surfaceArea: 2 * .pi * radius * (radius + height)) }
    func cone(radius: Double, height: Double) -> VolumeResult { VolumeResult(volume: (1.0/3.0) * .pi * pow(radius, 2) * height, surfaceArea: .pi * radius * (radius + sqrt(pow(height, 2) + pow(radius, 2)))) }
    func box(l: Double, w: Double, h: Double) -> VolumeResult { VolumeResult(volume: l * w * h, surfaceArea: 2 * (l*w + w*h + h*l)) }
}

// Surface Area Calculator
class SurfaceAreaCalculator {
    func cubeSA(side: Double) -> Double { 6 * pow(side, 2) }
    func sphereSA(radius: Double) -> Double { 4 * .pi * pow(radius, 2) }
    func cylinderSA(radius: Double, height: Double) -> Double { 2 * .pi * radius * (radius + height) }
}

// Aspect Ratio Calculator
struct AspectRatioResult { let ratio: String; let width: Double; let height: Double }
class AspectRatioCalculator {
    private func gcd(_ a: Int, _ b: Int) -> Int { b == 0 ? a : gcd(b, a % b) }
    func calculate(width: Double, height: Double) -> AspectRatioResult {
        let g = gcd(Int(width), Int(height))
        return AspectRatioResult(ratio: "\(Int(width)/g):\(Int(height)/g)", width: width, height: height)
    }
}

// Fraction Calculator
struct FractionResult { let numerator: Int; let denominator: Int; let decimal: Double; let simplified: String }
class FractionCalculator {
    private func gcd(_ a: Int, _ b: Int) -> Int { b == 0 ? abs(a) : gcd(b, abs(a) % abs(b)) }
    func simplify(num: Int, den: Int) -> FractionResult {
        let g = gcd(num, den); let n = num / g; let d = den / g
        return FractionResult(numerator: n, denominator: d, decimal: Double(num) / Double(den), simplified: "\(n)/\(d)")
    }
    func add(n1: Int, d1: Int, n2: Int, d2: Int) -> FractionResult { simplify(num: n1 * d2 + n2 * d1, den: d1 * d2) }
    func multiply(n1: Int, d1: Int, n2: Int, d2: Int) -> FractionResult { simplify(num: n1 * n2, den: d1 * d2) }
}

// Permutation & Combination
class PermCombCalculator {
    private func factorial(_ n: Int) -> Double { (2...max(n, 1)).reduce(1.0) { $0 * Double($1) } }
    func permutation(_ n: Int, _ r: Int) -> Double { factorial(n) / factorial(n - r) }
    func combination(_ n: Int, _ r: Int) -> Double { factorial(n) / (factorial(r) * factorial(n - r)) }
}
