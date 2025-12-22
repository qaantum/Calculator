import SwiftUI

struct BMICalculatorView: View {
    @State private var isMetric = true
    @State private var height = ""
    @State private var weight = ""
    @State private var inches = ""
    @State private var bmiResult: BMIResult?
    
    private let calculator = BMICalculator()
    
    var body: some View {
        Form {
            Section {
                Picker("Unit System", selection: $isMetric) {
                    Text("Metric (kg/cm)").tag(true)
                    Text("Imperial (lbs/ft)").tag(false)
                }
                .pickerStyle(.segmented)
                .onChange(of: isMetric) { _ in
                    bmiResult = nil
                    height = ""
                    weight = ""
                    inches = ""
                }
            }
            
            Section {
                if isMetric {
                    TextField("Height (cm)", text: $height)
                        .keyboardType(.decimalPad)
                } else {
                    HStack {
                        TextField("Feet", text: $height)
                            .keyboardType(.decimalPad)
                        TextField("Inches", text: $inches)
                            .keyboardType(.decimalPad)
                    }
                }
                
                TextField(isMetric ? "Weight (kg)" : "Weight (lbs)", text: $weight)
                    .keyboardType(.decimalPad)
            }
            
            Section {
                Button("Calculate") {
                    calculate()
                }
            }
            
            if let result = bmiResult {
                Section {
                    VStack(alignment: .center, spacing: 8) {
                        Text(String(format: "%.1f", result.bmi))
                            .font(.system(size: 48, weight: .bold))
                        Text(result.category)
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
            }
        }
        .navigationTitle("BMI Calculator")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func calculate() {
        guard let weightValue = Double(weight),
              let heightValue = Double(height) else {
            return
        }
        
        let result: BMIResult
        
        if isMetric {
            result = calculator.calculate(height: heightValue, weight: weightValue, isMetric: true)
        } else {
            let inchesValue = Double(inches) ?? 0.0
            result = calculator.calculateImperial(feet: heightValue, inches: inchesValue, weight: weightValue)
        }
        
        bmiResult = result
    }
}

struct BMICalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BMICalculatorView()
        }
    }
}

