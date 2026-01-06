import SwiftUI

struct HomeView: View {
    @State private var showCustomCalculator = false
    
    var body: some View {
        List {
            // Custom Calculator (Signature Feature) - Prominent at top
            Section {
                Button {
                    showCustomCalculator = true
                } label: {
                    HStack(spacing: 16) {
                        Image(systemName: "function")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.accentColor)
                            .cornerRadius(10)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Custom Calculator")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text("Build your own formulas")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
            } header: {
                Text("Signature Feature")
            }
            
            ForEach(CalculatorData.categories, id: \.self) { category in
                Section(header: Text(category)) {
                    ForEach(CalculatorData.getCalculatorsByCategory(category: category)) { calculator in
                        NavigationLink(destination: calculatorDestination(for: calculator)) {
                            Text(calculator.title)
                        }
                    }
                }
            }
        }
        .navigationTitle("Calculator Hub")
        .sheet(isPresented: $showCustomCalculator) {
            CustomCalculatorListView()
        }
    }
    
    @ViewBuilder
    func calculatorDestination(for calculator: CalculatorItem) -> some View {
        switch calculator.route {
        // Math
        case "/standard": StandardCalculatorView()
        case "/scientific": ScientificCalculatorView()
        case "/math/percentage": PercentageCalculatorView()
        case "/math/quadratic": QuadraticSolverView()
        case "/math/gcd-lcm": GcdLcmCalculatorView()
        case "/math/factorial": FactorialCalculatorView()
        case "/math/random": RandomNumberView()
        case "/math/statistics": StatisticsCalculatorView()
        
        // Finance - Core
        case "/finance/interest/compound": CompoundInterestCalculatorView()
        case "/finance/interest/simple": SimpleInterestCalculatorView()
        case "/finance/loan": LoanCalculatorView()
        case "/finance/mortgage": MortgageCalculatorView()
        case "/finance/tip": TipCalculatorView()
        case "/finance/discount": DiscountCalculatorView()
        case "/finance/investment": InvestmentGrowthCalculatorView()
        case "/finance/savings": SavingsGoalCalculatorView()
        case "/finance/roi": ROICalculatorView()
        case "/finance/cagr": CAGRCalculatorView()
        case "/finance/retirement": RetirementCalculatorView()
        
        // Finance - Additional
        case "/finance/auto-loan": AutoLoanCalculatorView()
        case "/finance/commission": CommissionCalculatorView()
        case "/finance/sales-tax": SalesTaxCalculatorView()
        case "/finance/salary": SalaryCalculatorView()
        
        // Health
        case "/health/bmi": BMICalculatorView()
        case "/health/bmr": BMRCalculatorView()
        case "/health/calories": CaloriesCalculatorView()
        case "/health/body-fat": BodyFatCalculatorView()
        case "/health/ideal-weight": IdealWeightCalculatorView()
        case "/health/macro": MacroCalculatorView()
        case "/health/water": WaterIntakeCalculatorView()
        case "/health/heart-rate": TargetHeartRateView()
        case "/health/sleep": SleepCalculatorView()
        case "/health/pace": PaceCalculatorView()
        
        // Utility
        case "/other/age": AgeCalculatorView()
        case "/other/work-hours": WorkHoursCalculatorView()
        case "/other/fuel": FuelCostCalculatorView()
        case "/other/password": PasswordGeneratorView()
        
        // Electronics
        case "/electronics/ohms-law": OhmsLawCalculatorView()
        case "/electronics/led-resistor": LEDResistorCalculatorView()
        
        // Text
        case "/text/word-count": WordCountCalculatorView()
        case "/text/base64": Base64ConverterView()
        
        // Converters & Science
        case "/converter/unit": UnitConverterView()
        case "/science/kinematic": KinematicCalculatorView()
        case "/science/force": ForceCalculatorView()
        case "/science/ph": PHCalculatorView()
        
        // Specialty
        case "/math/binary": BinaryConverterView()
        case "/math/roman": RomanNumeralConverterView()
        case "/other/grade": GradeCalculatorView()
        case "/health/one-rep-max": OneRepMaxCalculatorView()
        
        // Final
        case "/math/matrix": MatrixDeterminantView()
        case "/other/color": ColorConverterView()
        case "/finance/loan-affordability": LoanAffordabilityView()
        case "/finance/refinance": RefinanceCalculatorView()
        case "/finance/rental": RentalPropertyView()
        
        // Remaining 4
        case "/converter/currency": CurrencyConverterView()
        case "/health/ovulation": OvulationCalculatorView()
        case "/health/child-height": ChildHeightPredictorView()
        case "/health/smoking-cost": SmokingCostCalculatorView()
        
        // NEW CALCULATORS
        // Finance
        case "/finance/npv": NPVCalculatorView()
        case "/finance/irr": IRRCalculatorView()
        case "/finance/down-payment": DownPaymentCalculatorView()
        case "/finance/paycheck": PaycheckCalculatorView()
        case "/finance/cd": CDCalculatorView()
        case "/finance/tip-split": TipSplitCalculatorView()
        
        // Math
        case "/math/logarithm": LogarithmCalculatorView()
        case "/math/stats": StatisticsCalculatorView()
        case "/math/summation": SummationCalculatorView()
        
        // Health
        case "/health/blood-sugar": BloodSugarConverterView()
        case "/health/vo2-max": VO2MaxCalculatorView()
        case "/health/medication-dosage": MedicationDosageCalculatorView()
        
        // Converters
        case "/converter/temperature": TemperatureConverterView()
        case "/converter/length": LengthConverterView()
        case "/converter/weight": WeightConverterView()
        case "/converter/volume": VolumeConverterView()
        
        // Other
        case "/other/moon-phase": MoonPhaseCalculatorView()
        case "/other/dice": DiceRollerView()
        case "/other/hash": HashGeneratorView()
        
        default: Text("Coming soon: \(calculator.title)")
        }

    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
    }
}
