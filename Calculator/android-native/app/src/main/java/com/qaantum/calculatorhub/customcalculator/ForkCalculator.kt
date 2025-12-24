package com.qaantum.calculatorhub.customcalculator

import android.content.Context
import android.content.Intent
import com.qaantum.calculatorhub.customcalculator.CalculatorTemplates

/**
 * Utility object for forking existing calculators into custom calculators.
 * 
 * Provides a way to take an existing built-in calculator and create a customizable
 * copy that the user can modify and save.
 */
object ForkCalculator {
    
    /**
     * Check if a calculator route has a customizable template available.
     */
    fun isCustomizable(route: String): Boolean {
        return CalculatorTemplates.getTemplateForRoute(route) != null
    }
    
    /**
     * Get the template for a given route, if available.
     */
    fun getTemplate(route: String): CustomCalculator? {
        return CalculatorTemplates.getTemplateForRoute(route)
    }
    
    /**
     * Create a forked (copy) calculator from an existing template.
     * Returns a new CustomCalculator with a unique ID and a modified title.
     */
    fun createFork(route: String): CustomCalculator? {
        val template = getTemplate(route) ?: return null
        
        return CustomCalculator(
            title = "${template.title} (My Version)",
            iconName = template.iconName,
            inputs = template.inputs.map { it.copy() },
            formula = template.formula,
            sourceRoute = route
        )
    }
    
    /**
     * List of all customizable routes.
     */
    val customizableRoutes = listOf(
        "/health/bmi",
        "/finance/interest/compound",
        "/finance/mortgage",
        "/finance/tip",
        "/finance/roi",
        "/electronics/ohms-law",
        "/math/quadratic",
        "/health/bmr",
        "/health/heart-rate",
        "/other/age"
    )
}
