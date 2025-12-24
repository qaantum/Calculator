import Foundation

// Kinematic Calculator
class KinematicCalculator {
    func finalVelocity(initial: Double, acceleration: Double, time: Double) -> Double { initial + acceleration * time }
    func displacement(initial: Double, acceleration: Double, time: Double) -> Double { initial * time + 0.5 * acceleration * time * time }
    func finalVelocityFromDisplacement(initial: Double, acceleration: Double, displacement: Double) -> Double { sqrt(initial * initial + 2 * acceleration * displacement) }
}

// Force Calculator (F = ma)
class ForceCalculator {
    func forceFromMassAccel(mass: Double, acceleration: Double) -> Double { mass * acceleration }
    func massFromForceAccel(force: Double, acceleration: Double) -> Double { force / acceleration }
    func accelFromForceMass(force: Double, mass: Double) -> Double { force / mass }
}

// Momentum Calculator (p = mv)
class MomentumCalculator {
    func momentum(mass: Double, velocity: Double) -> Double { mass * velocity }
    func impulse(force: Double, time: Double) -> Double { force * time }
    func finalVelocity(mass: Double, initialV: Double, impulse: Double) -> Double { initialV + impulse / mass }
}

// Work Energy Calculator
class WorkEnergyCalculator {
    func work(force: Double, displacement: Double, angleRadians: Double = 0) -> Double { force * displacement * cos(angleRadians) }
    func kineticEnergy(mass: Double, velocity: Double) -> Double { 0.5 * mass * velocity * velocity }
    func potentialEnergy(mass: Double, height: Double, g: Double = 9.81) -> Double { mass * g * height }
}

// Molar Mass Calculator
class MolarMassCalculator {
    private let elements: [String: Double] = [
        "H": 1.008, "He": 4.003, "Li": 6.941, "Be": 9.012, "B": 10.81, "C": 12.01,
        "N": 14.01, "O": 16.00, "F": 19.00, "Ne": 20.18, "Na": 22.99, "Mg": 24.31,
        "Al": 26.98, "Si": 28.09, "P": 30.97, "S": 32.07, "Cl": 35.45, "Ar": 39.95,
        "K": 39.10, "Ca": 40.08, "Fe": 55.85, "Cu": 63.55, "Zn": 65.38, "Ag": 107.87,
        "Au": 196.97, "Pb": 207.2
    ]
    func getMass(_ symbol: String) -> Double? { elements[symbol] }
    func calculateH2O() -> Double { 2 * (elements["H"] ?? 0) + (elements["O"] ?? 0) }
    func calculateCO2() -> Double { (elements["C"] ?? 0) + 2 * (elements["O"] ?? 0) }
}

// pH Calculator
struct PHResult { let pH: Double; let pOH: Double; let hConc: Double; let ohConc: Double }
class PHCalculator {
    func fromHConcentration(_ hConc: Double) -> PHResult {
        let pH = -log10(hConc); let pOH = 14 - pH; let ohConc = pow(10, -pOH)
        return PHResult(pH: pH, pOH: pOH, hConc: hConc, ohConc: ohConc)
    }
    func fromPH(_ pH: Double) -> PHResult {
        let hConc = pow(10, -pH); let pOH = 14 - pH; let ohConc = pow(10, -pOH)
        return PHResult(pH: pH, pOH: pOH, hConc: hConc, ohConc: ohConc)
    }
}

// Standard Deviation Calculator
struct StatsResult { let mean: Double; let variance: Double; let stdDev: Double; let count: Int }
class StandardDeviationCalculator {
    func calculate(_ numbers: [Double]) -> StatsResult {
        let count = numbers.count; let mean = numbers.reduce(0, +) / Double(count)
        let variance = numbers.map { pow($0 - mean, 2) }.reduce(0, +) / Double(count)
        return StatsResult(mean: mean, variance: variance, stdDev: sqrt(variance), count: count)
    }
}
