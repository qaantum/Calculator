import SwiftUI

struct BinaryConverterView: View {
    @State private var input = ""
    @State private var inputType = "Decimal"
    private let conv = BinaryConverter()
    let types = ["Decimal", "Binary", "Hex", "Octal"]
    
    var decimal: Int {
        switch inputType {
        case "Binary": return conv.binaryToDecimal(input)
        case "Hex": return conv.hexToDecimal(input)
        case "Octal": return conv.octalToDecimal(input)
        default: return Int(input) ?? 0
        }
    }
    
    var body: some View {
        Form {
            Picker("Input Type", selection: $inputType) { ForEach(types, id: \.self) { Text($0) } }
            TextField("Value", text: $input).keyboardType(inputType == "Decimal" ? .numberPad : .default)
            Section(header: Text("Results")) {
                HStack { Text("Decimal"); Spacer(); Text("\(decimal)").bold() }
                HStack { Text("Binary"); Spacer(); Text(conv.decimalToBinary(decimal)).bold() }
                HStack { Text("Hex"); Spacer(); Text(conv.decimalToHex(decimal)).bold() }
                HStack { Text("Octal"); Spacer(); Text(conv.decimalToOctal(decimal)).bold() }
            }
        }.navigationTitle("Number Base Converter").navigationBarTitleDisplayMode(.inline)
    }
}

struct RomanNumeralConverterView: View {
    @State private var decimal = "", roman = ""
    @State private var romanResult = "---", decimalResult = "---"
    private let conv = RomanNumeralConverter()
    
    var body: some View {
        Form {
            Section(header: Text("Decimal → Roman")) {
                TextField("Decimal (1-3999)", text: $decimal).keyboardType(.numberPad).onChange(of: decimal) { _ in romanResult = conv.toRoman(Int(decimal) ?? 0) }
                Text(romanResult).font(.title).bold()
            }
            Section(header: Text("Roman → Decimal")) {
                TextField("Roman Numeral", text: $roman).autocapitalization(.allCharacters).onChange(of: roman) { _ in decimalResult = "\(conv.fromRoman(roman))" }
                Text(decimalResult).font(.title).bold()
            }
        }.navigationTitle("Roman Numerals").navigationBarTitleDisplayMode(.inline)
    }
}

struct GradeCalculatorView: View {
    @State private var gradesInput = ""
    @State private var result: GradeResult?
    private let calc = GradeCalculator()
    
    var body: some View {
        Form {
            Section(header: Text("Enter grades (comma separated)")) { TextEditor(text: $gradesInput).frame(height: 100) }
            Button("Calculate") { let grades = gradesInput.components(separatedBy: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }; if !grades.isEmpty { result = calc.calculate(grades: grades) } }
            if let r = result { Section { VStack {
                Text(String(format: "Average: %.1f%%", r.average)).font(.title3)
                Text("Grade: \(r.letterGrade)").font(.largeTitle).bold()
                Text(String(format: "GPA: %.2f", r.gpa)).font(.title3)
            }.frame(maxWidth: .infinity) }}
        }.navigationTitle("Grade Calculator").navigationBarTitleDisplayMode(.inline)
    }
}

struct OneRepMaxCalculatorView: View {
    @State private var weight = "", reps = ""
    @State private var result: OneRepMaxResult?
    private let calc = OneRepMaxCalculator()
    
    var body: some View {
        Form {
            TextField("Weight Lifted", text: $weight).keyboardType(.decimalPad)
            TextField("Reps Performed", text: $reps).keyboardType(.numberPad)
            Button("Calculate 1RM") { guard let w = Double(weight), let r = Int(reps) else { return }; result = calc.calculate(weight: w, reps: r) }
            if let r = result { Section {
                VStack { Text("Estimated 1RM").font(.subheadline); Text(String(format: "%.1f", r.oneRepMax)).font(.largeTitle).bold() }.frame(maxWidth: .infinity)
                Divider()
                ForEach(r.estimatedReps.prefix(6), id: \.0) { rep in HStack { Text("\(rep.0) rep\(rep.0 > 1 ? "s" : "")"); Spacer(); Text(String(format: "%.1f", rep.1)).bold() } }
            }}
        }.navigationTitle("One Rep Max").navigationBarTitleDisplayMode(.inline)
    }
}
