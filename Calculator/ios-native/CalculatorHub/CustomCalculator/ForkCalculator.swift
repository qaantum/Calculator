import Foundation

/**
 * Utility struct for forking existing calculators into custom calculators.
 *
 * Provides a way to take an existing built-in calculator and create a customizable
 * copy that the user can modify and save.
 */
struct ForkCalculator {
    
    /**
     * Check if a calculator route has a customizable template available.
     */
    static func isCustomizable(_ route: String) -> Bool {
        return CalculatorTemplates.getTemplateForRoute(route) != nil
    }
    
    /**
     * Get the template for a given route, if available.
     */
    static func getTemplate(_ route: String) -> CustomCalculator? {
        return CalculatorTemplates.getTemplateForRoute(route)
    }
    
    /**
     * Create a forked (copy) calculator from an existing template.
     * Returns a new CustomCalculator with a unique ID and a modified title.
     */
    static func createFork(_ route: String) -> CustomCalculator? {
        guard let template = getTemplate(route) else { return nil }
        
        return CustomCalculator(
            title: "\(template.title) (My Version)",
            iconName: template.iconName,
            inputs: template.inputs,
            formula: template.formula,
            sourceRoute: route
        )
    }
    
    /**
     * List of all customizable routes.
     */
    static let customizableRoutes = [
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
    ]
}
