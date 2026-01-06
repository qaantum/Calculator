package com.qaantum.calculatorhub.calculators

// NEW HEALTH CALCULATORS

// Blood Sugar Converter
data class BloodSugarResult(val mgdl: Double, val mmol: Double, val category: String, val categoryColor: String)
class BloodSugarConverter {
    private val conversionFactor = 18.0182
    
    fun fromMgdl(mgdl: Double): BloodSugarResult {
        val mmol = mgdl / conversionFactor
        return BloodSugarResult(mgdl, mmol, getCategory(mgdl), getCategoryColor(mgdl))
    }
    
    fun fromMmol(mmol: Double): BloodSugarResult {
        val mgdl = mmol * conversionFactor
        return BloodSugarResult(mgdl, mmol, getCategory(mgdl), getCategoryColor(mgdl))
    }
    
    private fun getCategory(mgdl: Double) = when {
        mgdl < 70 -> "Low (Hypoglycemia)"
        mgdl < 100 -> "Normal (Fasting)"
        mgdl < 126 -> "Prediabetes (Fasting)"
        else -> "Diabetes Range"
    }
    
    private fun getCategoryColor(mgdl: Double) = when {
        mgdl < 70 -> "orange"
        mgdl < 100 -> "green"
        mgdl < 126 -> "amber"
        else -> "red"
    }
}

// VO2 Max Calculator
data class VO2MaxResult(val vo2max: Double, val fitnessLevel: String)
class VO2MaxCalculator {
    fun cooperTest(distanceMeters: Double): VO2MaxResult {
        val vo2max = (distanceMeters - 504.9) / 44.73
        return VO2MaxResult(vo2max, getFitnessLevel(vo2max))
    }
    
    fun heartRateMethod(maxHR: Double, restingHR: Double): VO2MaxResult {
        val vo2max = 15.3 * (maxHR / restingHR)
        return VO2MaxResult(vo2max, getFitnessLevel(vo2max))
    }
    
    private fun getFitnessLevel(vo2max: Double) = when {
        vo2max >= 50 -> "Excellent"
        vo2max >= 40 -> "Good"
        vo2max >= 30 -> "Average"
        vo2max >= 20 -> "Below Average"
        else -> "Poor"
    }
}

// Medication Dosage Calculator
data class MedicationDosageResult(val singleDose: Double, val volumePerDose: Double?, val dailyDose: Double)
class MedicationDosageCalculator {
    fun calculate(weightKg: Double, dosePerKg: Double, concentration: Double? = null, dosesPerDay: Int = 1): MedicationDosageResult {
        val singleDose = weightKg * dosePerKg
        val volumePerDose = concentration?.let { singleDose / it }
        val dailyDose = singleDose * dosesPerDay
        return MedicationDosageResult(singleDose, volumePerDose, dailyDose)
    }
    
    fun convertLbToKg(weightLb: Double) = weightLb * 0.453592
}
