import Foundation

// Unit Converter
class UnitConverter {
    // Length
    func metersToFeet(_ m: Double) -> Double { m * 3.28084 }
    func feetToMeters(_ ft: Double) -> Double { ft / 3.28084 }
    func kmToMiles(_ km: Double) -> Double { km * 0.621371 }
    func milesToKm(_ mi: Double) -> Double { mi / 0.621371 }
    func cmToInches(_ cm: Double) -> Double { cm / 2.54 }
    func inchesToCm(_ inches: Double) -> Double { inches * 2.54 }

    // Weight
    func kgToLbs(_ kg: Double) -> Double { kg * 2.20462 }
    func lbsToKg(_ lbs: Double) -> Double { lbs / 2.20462 }

    // Temperature
    func celsiusToFahrenheit(_ c: Double) -> Double { c * 9 / 5 + 32 }
    func fahrenheitToCelsius(_ f: Double) -> Double { (f - 32) * 5 / 9 }
    func celsiusToKelvin(_ c: Double) -> Double { c + 273.15 }

    // Volume
    func litersToGallons(_ l: Double) -> Double { l * 0.264172 }
    func gallonsToLiters(_ gal: Double) -> Double { gal / 0.264172 }

    // Area
    func sqMetersToSqFeet(_ m2: Double) -> Double { m2 * 10.7639 }
    func acresToHectares(_ acres: Double) -> Double { acres * 0.404686 }

    // Speed
    func kphToMph(_ kph: Double) -> Double { kph * 0.621371 }
    func mphToKph(_ mph: Double) -> Double { mph / 0.621371 }

    // Data
    func bytesToKB(_ bytes: Double) -> Double { bytes / 1024 }
    func mbToGB(_ mb: Double) -> Double { mb / 1024 }
}

// Pressure Converter
class PressureConverter {
    func psiToBar(_ psi: Double) -> Double { psi * 0.0689476 }
    func barToPsi(_ bar: Double) -> Double { bar / 0.0689476 }
    func atmToPa(_ atm: Double) -> Double { atm * 101325 }
}

// Power Converter
class PowerConverter {
    func wattsToHP(_ w: Double) -> Double { w / 745.7 }
    func hpToWatts(_ hp: Double) -> Double { hp * 745.7 }
    func kwToBTU(_ kw: Double) -> Double { kw * 3412.14 }
}

// Angle Converter
class AngleConverter {
    func degreesToRadians(_ deg: Double) -> Double { deg * .pi / 180 }
    func radiansToDegrees(_ rad: Double) -> Double { rad * 180 / .pi }
}

// Torque Converter
class TorqueConverter {
    func nmToLbFt(_ nm: Double) -> Double { nm * 0.737562 }
    func lbFtToNm(_ lbft: Double) -> Double { lbft / 0.737562 }
}

// Fuel Consumption Converter
class FuelConverter {
    func mpgToLper100km(_ mpg: Double) -> Double { 235.215 / mpg }
    func lper100kmToMpg(_ l100km: Double) -> Double { 235.215 / l100km }
}

// Shoe Size Converter
class ShoeSizeConverter {
    func usToEU(_ usSize: Double, isMale: Bool) -> Double { isMale ? usSize + 33 : usSize + 31 }
    func euToUS(_ euSize: Double, isMale: Bool) -> Double { isMale ? euSize - 33 : euSize - 31 }
}

// Cooking Converter
class CookingConverter {
    func cupsToMl(_ cups: Double) -> Double { cups * 236.588 }
    func mlToCups(_ ml: Double) -> Double { ml / 236.588 }
    func tbspToMl(_ tbsp: Double) -> Double { tbsp * 14.787 }
    func tspToMl(_ tsp: Double) -> Double { tsp * 4.929 }
}
