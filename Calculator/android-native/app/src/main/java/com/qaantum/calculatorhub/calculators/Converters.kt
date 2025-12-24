package com.qaantum.calculatorhub.calculators

// Unit Converter - Multiple types
class UnitConverter {
    // Length
    fun metersToFeet(m: Double) = m * 3.28084
    fun feetToMeters(ft: Double) = ft / 3.28084
    fun kmToMiles(km: Double) = km * 0.621371
    fun milesToKm(mi: Double) = mi / 0.621371
    fun cmToInches(cm: Double) = cm / 2.54
    fun inchesToCm(inches: Double) = inches * 2.54

    // Weight
    fun kgToLbs(kg: Double) = kg * 2.20462
    fun lbsToKg(lbs: Double) = lbs / 2.20462
    fun gramsToOz(g: Double) = g * 0.035274
    fun ozToGrams(oz: Double) = oz / 0.035274

    // Temperature
    fun celsiusToFahrenheit(c: Double) = c * 9 / 5 + 32
    fun fahrenheitToCelsius(f: Double) = (f - 32) * 5 / 9
    fun celsiusToKelvin(c: Double) = c + 273.15
    fun kelvinToCelsius(k: Double) = k - 273.15

    // Volume
    fun litersToGallons(l: Double) = l * 0.264172
    fun gallonsToLiters(gal: Double) = gal / 0.264172
    fun mlToFlOz(ml: Double) = ml * 0.033814
    fun flOzToMl(oz: Double) = oz / 0.033814

    // Area
    fun sqMetersToSqFeet(m2: Double) = m2 * 10.7639
    fun sqFeetToSqMeters(ft2: Double) = ft2 / 10.7639
    fun acresToHectares(acres: Double) = acres * 0.404686
    fun hectaresToAcres(ha: Double) = ha / 0.404686

    // Speed
    fun kphToMph(kph: Double) = kph * 0.621371
    fun mphToKph(mph: Double) = mph / 0.621371
    fun msToKph(ms: Double) = ms * 3.6
    fun kphToMs(kph: Double) = kph / 3.6

    // Data Storage
    fun bytesToKB(bytes: Double) = bytes / 1024
    fun kbToMB(kb: Double) = kb / 1024
    fun mbToGB(mb: Double) = mb / 1024
    fun gbToTB(gb: Double) = gb / 1024
}

// Pressure Converter
class PressureConverter {
    fun psiToBar(psi: Double) = psi * 0.0689476
    fun barToPsi(bar: Double) = bar / 0.0689476
    fun atmToPa(atm: Double) = atm * 101325
    fun paToAtm(pa: Double) = pa / 101325
    fun mmHgToAtm(mmHg: Double) = mmHg / 760
}

// Power Converter
class PowerConverter {
    fun wattsToHP(w: Double) = w / 745.7
    fun hpToWatts(hp: Double) = hp * 745.7
    fun wattsToKw(w: Double) = w / 1000
    fun kwToBTU(kw: Double) = kw * 3412.14
}

// Angle Converter
class AngleConverter {
    fun degreesToRadians(deg: Double) = deg * Math.PI / 180
    fun radiansToDegrees(rad: Double) = rad * 180 / Math.PI
    fun degreesToGradians(deg: Double) = deg * 10 / 9
    fun gradiansToDegrees(grad: Double) = grad * 9 / 10
}

// Torque Converter
class TorqueConverter {
    fun nmToLbFt(nm: Double) = nm * 0.737562
    fun lbFtToNm(lbft: Double) = lbft / 0.737562
    fun nmToKgCm(nm: Double) = nm * 10.1972
}

// Fuel Consumption Converter
class FuelConverter {
    fun mpgToLper100km(mpg: Double) = 235.215 / mpg
    fun lper100kmToMpg(l100km: Double) = 235.215 / l100km
    fun mpgUKToMpgUS(mpgUK: Double) = mpgUK * 0.832674
}

// Shoe Size Converter
class ShoeSizeConverter {
    fun usToEU(usSize: Double, isMale: Boolean): Double = if (isMale) usSize + 33 else usSize + 31
    fun euToUS(euSize: Double, isMale: Boolean): Double = if (isMale) euSize - 33 else euSize - 31
    fun usToUK(usSize: Double, isMale: Boolean): Double = if (isMale) usSize - 0.5 else usSize - 2
}

// Cooking Converter
class CookingConverter {
    fun cupsToMl(cups: Double) = cups * 236.588
    fun mlToCups(ml: Double) = ml / 236.588
    fun tbspToMl(tbsp: Double) = tbsp * 14.787
    fun tspToMl(tsp: Double) = tsp * 4.929
    fun ozToGrams(oz: Double) = oz * 28.3495
}
