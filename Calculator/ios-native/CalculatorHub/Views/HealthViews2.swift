import SwiftUI

struct MacroCalculatorView: View {
    @State private var calories = "2000", protein = "30", carbs = "40", fat = "30"
    @State private var result: MacroResult?
    private let calc = MacroCalculator()
    
    var body: some View {
        Form {
            TextField("Target Calories", text: $calories).keyboardType(.numberPad)
            HStack { TextField("Protein %", text: $protein).keyboardType(.numberPad); TextField("Carbs %", text: $carbs).keyboardType(.numberPad); TextField("Fat %", text: $fat).keyboardType(.numberPad) }
            Button("Calculate Macros") { result = calc.calculate(targetCalories: Int(calories) ?? 2000, proteinPercent: Int(protein) ?? 30, carbsPercent: Int(carbs) ?? 40, fatPercent: Int(fat) ?? 30) }
            if let r = result { Section(header: Text("Daily Macros")) {
                HStack { Text("Protein"); Spacer(); Text("\(r.protein)g").font(.title2).bold() }
                HStack { Text("Carbs"); Spacer(); Text("\(r.carbs)g").font(.title2).bold() }
                HStack { Text("Fat"); Spacer(); Text("\(r.fat)g").font(.title2).bold() }
            }}
        }.navigationTitle("Macro Calculator").navigationBarTitleDisplayMode(.inline)
    }
}

struct WaterIntakeCalculatorView: View {
    @State private var weight = "", activity = "Normal"
    @State private var result: WaterResult?
    private let calc = WaterIntakeCalculator()
    let activities = ["Sedentary", "Normal", "Active", "Athlete"]
    
    var body: some View {
        Form {
            TextField("Weight (kg)", text: $weight).keyboardType(.decimalPad)
            Picker("Activity", selection: $activity) { ForEach(activities, id: \.self) { Text($0) } }.pickerStyle(.segmented)
            Button("Calculate") { guard let w = Double(weight) else { return }; result = calc.calculate(weightKg: w, activityLevel: activity) }
            if let r = result { Section { VStack { Text("Daily Intake").font(.subheadline); Text(String(format: "%.1f liters", r.liters)).font(.largeTitle).bold(); Text("(\(r.glasses) glasses)") }.frame(maxWidth: .infinity) } }
        }.navigationTitle("Water Intake").navigationBarTitleDisplayMode(.inline)
    }
}

struct TargetHeartRateView: View {
    @State private var age = ""
    @State private var result: TargetHRResult?
    private let calc = TargetHeartRateCalculator()
    
    var body: some View {
        Form {
            TextField("Age", text: $age).keyboardType(.numberPad).onChange(of: age) { _ in if let a = Int(age) { result = calc.calculate(age: a) } }
            if let r = result { Section {
                Text("Max HR: \(r.maxHR) bpm").font(.title2).bold().frame(maxWidth: .infinity)
                Divider()
                ForEach(r.zones, id: \.0) { zone in HStack { Text(zone.0); Spacer(); Text("\(zone.1)-\(zone.2) bpm").bold() } }
            }}
        }.navigationTitle("Target Heart Rate").navigationBarTitleDisplayMode(.inline)
    }
}

struct SleepCalculatorView: View {
    @State private var hour = "22", min = "00"
    @State private var result: SleepResult?
    private let calc = SleepCalculator()
    
    var body: some View {
        Form {
            Section(header: Text("Bedtime")) { HStack { TextField("Hour (0-23)", text: $hour).keyboardType(.numberPad); TextField("Minute", text: $min).keyboardType(.numberPad) } }
            Button("Calculate Wake Times") { result = calc.calculateWakeUp(bedtimeHour: Int(hour) ?? 22, bedtimeMin: Int(min) ?? 0) }
            if let r = result { Section(header: Text("Optimal Wake Up Times")) {
                HStack { ForEach(r.wakeUpTimes, id: \.self) { Text($0).font(.title2).bold() } }.frame(maxWidth: .infinity)
                Text("Based on 90-min sleep cycles").font(.caption).frame(maxWidth: .infinity)
            }}
        }.navigationTitle("Sleep Calculator").navigationBarTitleDisplayMode(.inline)
    }
}

struct PaceCalculatorView: View {
    @State private var distance = "", hours = "0", mins = "", secs = "0"
    @State private var result: PaceResult?
    private let calc = PaceCalculator()
    
    var body: some View {
        Form {
            TextField("Distance (km)", text: $distance).keyboardType(.decimalPad)
            Section(header: Text("Time")) { HStack { TextField("Hours", text: $hours).keyboardType(.numberPad); TextField("Minutes", text: $mins).keyboardType(.numberPad); TextField("Seconds", text: $secs).keyboardType(.numberPad) } }
            Button("Calculate") { guard let d = Double(distance) else { return }; result = calc.calculate(distanceKm: d, hours: Int(hours) ?? 0, minutes: Int(mins) ?? 0, seconds: Int(secs) ?? 0) }
            if let r = result { Section {
                HStack { Text("Pace/km"); Spacer(); Text(r.pacePerKm).font(.title2).bold() }
                HStack { Text("Pace/mile"); Spacer(); Text(r.pacePerMile).font(.title2).bold() }
                HStack { Text("Speed"); Spacer(); Text(String(format: "%.2f km/h", r.speed)).font(.title2).bold() }
            }}
        }.navigationTitle("Pace Calculator").navigationBarTitleDisplayMode(.inline)
    }
}
