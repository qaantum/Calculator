package com.qaantum.calculatorhub.customcalculator

import android.content.Context
import android.content.SharedPreferences
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken

class CustomCalculatorService(context: Context) {
    
    private val prefs: SharedPreferences = context.getSharedPreferences("custom_calculators", Context.MODE_PRIVATE)
    private val gson = Gson()
    
    companion object {
        private const val KEY_CALCULATORS = "calculators"
        private const val KEY_VALUES_PREFIX = "values_"
    }
    
    fun getCalculators(): List<CustomCalculator> {
        val json = prefs.getString(KEY_CALCULATORS, null) ?: return emptyList()
        return try {
            val type = object : TypeToken<List<CustomCalculator>>() {}.type
            gson.fromJson(json, type) ?: emptyList()
        } catch (e: Exception) {
            emptyList()
        }
    }
    
    fun getById(id: String): CustomCalculator? {
        return getCalculators().find { it.id == id }
    }
    
    fun saveCalculator(calculator: CustomCalculator) {
        val current = getCalculators().toMutableList()
        val index = current.indexOfFirst { it.id == calculator.id }
        
        if (index >= 0) {
            current[index] = calculator
        } else {
            current.add(calculator)
        }
        
        prefs.edit().putString(KEY_CALCULATORS, gson.toJson(current)).apply()
    }
    
    fun deleteCalculator(id: String) {
        val current = getCalculators().toMutableList()
        current.removeAll { it.id == id }
        prefs.edit().putString(KEY_CALCULATORS, gson.toJson(current)).apply()
        
        // Also remove saved values
        prefs.edit().remove("$KEY_VALUES_PREFIX$id").apply()
    }
    
    fun getLastValues(id: String): Map<String, Double> {
        val json = prefs.getString("$KEY_VALUES_PREFIX$id", null) ?: return emptyMap()
        return try {
            val type = object : TypeToken<Map<String, Double>>() {}.type
            gson.fromJson(json, type) ?: emptyMap()
        } catch (e: Exception) {
            emptyMap()
        }
    }
    
    fun saveLastValues(id: String, values: Map<String, Double>) {
        prefs.edit().putString("$KEY_VALUES_PREFIX$id", gson.toJson(values)).apply()
    }
}
