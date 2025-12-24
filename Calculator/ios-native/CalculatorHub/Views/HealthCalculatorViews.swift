import SwiftUI

struct BMRCalculatorView: View {
    @State private var age = ""
    @State private var height = ""
    @State private var weight = ""
    @State private var gender = "Male"
    @State private var bmr: Double?
    private let calculator = BMRCalculator()
    
    var body: some View {
        Form {
            Picker("Gender", selection: $gender) { Text("Male").tag("Male"); Text("Female").tag("Female") }.pickerStyle(.segmented)
            TextField("Age", text: $age).keyboardType(.numberPad)
            TextField("Height (cm)", text: $height).keyboardType(.decimalPad)
            TextField("Weight (kg)", text: $weight).keyboardType(.decimalPad)
            Button("Calculate BMR") { calculate() }
            if let b = bmr {
                Section { VStack { Text("Basal Metabolic Rate").font(.subheadline); Text("\(Int(b)) kcal/day").font(.largeTitle).bold(); Text("Calories burned at rest").font(.caption) }.frame(maxWidth: .infinity) }
            }
        }.navigationTitle("BMR Calculator").navigationBarTitleDisplayMode(.inline)
    }
    private func calculate() { guard let a = Int(age), let h = Double(height), let w = Double(weight) else { return }; bmr = calculator.calculate(gender: gender, age: a, heightCm: h, weightKg: w).bmr }
}

struct CaloriesCalculatorView: View {
    @State private var age = ""
    @State private var height = ""
    @State private var weight = ""
    @State private var gender = "Male"
    @State private var activityLevel = 1.2
    @State private var tdee: Double?
    private let calculator = CaloriesCalculator()
    let activities: [(Double, String)] = [(1.2, "Sedentary"), (1.375, "Lightly active"), (1.55, "Moderately active"), (1.725, "Very active"), (1.9, "Super active")]
    
    var body: some View {
        Form {
            Picker("Gender", selection: $gender) { Text("Male").tag("Male"); Text("Female").tag("Female") }.pickerStyle(.segmented)
            TextField("Age", text: $age).keyboardType(.numberPad)
            TextField("Height (cm)", text: $height).keyboardType(.decimalPad)
            TextField("Weight (kg)", text: $weight).keyboardType(.decimalPad)
            Picker("Activity Level", selection: $activityLevel) { ForEach(activities, id: \.0) { Text($0.1).tag($0.0) } }
            Button("Calculate Calories") { calculate() }
            if let t = tdee { Section { VStack { Text("Daily Calorie Needs").font(.subheadline); Text("\(Int(t)) kcal").font(.largeTitle).bold() }.frame(maxWidth: .infinity) } }
        }.navigationTitle("Calorie Calculator").navigationBarTitleDisplayMode(.inline)
    }
    private func calculate() { guard let a = Int(age), let h = Double(height), let w = Double(weight) else { return }; tdee = calculator.calculate(gender: gender, age: a, heightCm: h, weightKg: w, activityLevel: activityLevel).tdee }
}

struct BodyFatCalculatorView: View {
    @State private var height = ""
    @State private var waist = ""
    @State private var neck = ""
    @State private var hip = ""
    @State private var gender = "Male"
    @State private var bodyFat: Double?
    private let calculator = BodyFatCalculator()
    
    var body: some View {
        Form {
            Picker("Gender", selection: $gender) { Text("Male").tag("Male"); Text("Female").tag("Female") }.pickerStyle(.segmented).onChange(of: gender) { _ in hip = "" }
            TextField("Height (cm)", text: $height).keyboardType(.decimalPad)
            TextField("Neck (cm)", text: $neck).keyboardType(.decimalPad)
            TextField("Waist (cm)", text: $waist).keyboardType(.decimalPad)
            if gender == "Female" { TextField("Hip (cm)", text: $hip).keyboardType(.decimalPad) }
            Button("Calculate Body Fat") { calculate() }
            if let bf = bodyFat { Section { VStack { Text("Body Fat").font(.subheadline); Text(String(format: "%.1f%%", bf)).font(.largeTitle).bold() }.frame(maxWidth: .infinity) } }
        }.navigationTitle("Body Fat Calculator").navigationBarTitleDisplayMode(.inline)
    }
    private func calculate() { guard let h = Double(height), let w = Double(waist), let n = Double(neck), (gender == "Male" || Double(hip) != nil) else { return }; let hp = Double(hip) ?? 0; bodyFat = calculator.calculate(gender: gender, heightCm: h, waistCm: w, neckCm: n, hipCm: hp).bodyFatPercentage }
}

struct IdealWeightCalculatorView: View {
    @State private var height = ""
    @State private var gender = "Male"
    @State private var result: IdealWeightResult?
    private let calculator = IdealWeightCalculator()
    
    var body: some View {
        Form {
            Picker("Gender", selection: $gender) { Text("Male").tag("Male"); Text("Female").tag("Female") }.pickerStyle(.segmented)
            TextField("Height (cm)", text: $height).keyboardType(.decimalPad)
            Button("Calculate") { guard let h = Double(height) else { return }; result = calculator.calculate(gender: gender, heightCm: h) }
            if let r = result {
                Section { VStack { Text("Ideal Weight (Devine)").font(.subheadline); Text(String(format: "%.1f kg", r.idealWeight)).font(.largeTitle).bold(); Divider(); Text("Healthy BMI Range").font(.subheadline); Text(String(format: "%.1f - %.1f kg", r.minWeight, r.maxWeight)).font(.title2) }.frame(maxWidth: .infinity).padding() }
            }
        }.navigationTitle("Ideal Weight").navigationBarTitleDisplayMode(.inline)
    }
}
