import SwiftUI

struct LogarithmCalculatorView: View {
    @State private var value = ""; @State private var base = "10"; @State private var logType = "Common (log₁₀)"
    @State private var result: LogarithmResult?; private let calculator = LogarithmCalculator()
    let types = ["Natural (ln)", "Common (log₁₀)", "Binary (log₂)", "Custom"]
    var body: some View {
        Form {
            Section { TextField("Value", text: $value).keyboardType(.decimalPad).onChange(of: value) { _ in calc() }
                Picker("Type", selection: $logType) { ForEach(types, id: \.self) { Text($0) } }.onChange(of: logType) { _ in calc() } }
            if logType == "Custom" { Section { TextField("Base", text: $base).keyboardType(.decimalPad).onChange(of: base) { _ in calc() } } }
            if let r = result { Section { VStack { Text(r.formula).font(.subheadline); Text(String(format: "%.8f", r.result)).font(.largeTitle).bold() }.frame(maxWidth: .infinity).padding() } }
        }.navigationTitle("Logarithm").navigationBarTitleDisplayMode(.inline)
    }
    private func calc() { guard let v = Double(value) else { return }
        result = logType == "Natural (ln)" ? calculator.naturalLog(v) : logType == "Common (log₁₀)" ? calculator.commonLog(v) : logType == "Binary (log₂)" ? calculator.binaryLog(v) : calculator.customLog(v, base: Double(base) ?? 10) }
}

struct StatisticsCalculatorView: View {
    @State private var data = ""; @State private var result: StatisticsResult?
    private let calculator = StatisticsCalculator()
    var body: some View {
        Form {
            Section { TextEditor(text: $data).frame(height: 100).onChange(of: data) { _ in calc() } } header: { Text("Enter Numbers (comma or space separated)") }
            if let r = result { Section { VStack(alignment: .leading, spacing: 12) {
                HStack { Text("Count"); Spacer(); Text("\(r.count) values").bold() }; Divider()
                HStack { Text("Mean"); Spacer(); Text(String(format: "%.4f", r.mean)).bold().foregroundColor(.blue) }
                HStack { Text("Median"); Spacer(); Text(String(format: "%.4f", r.median)).bold().foregroundColor(.blue) }
                HStack { Text("Mode"); Spacer(); Text(r.mode?.map { String(format: "%.2f", $0) }.joined(separator: ", ") ?? "No mode").bold().foregroundColor(.blue) }
                HStack { Text("Range"); Spacer(); Text(String(format: "%.4f", r.range)).bold().foregroundColor(.blue) }
            }.padding() } }
        }.navigationTitle("Statistics").navigationBarTitleDisplayMode(.inline)
    }
    private func calc() { let nums = data.components(separatedBy: CharacterSet(charactersIn: ", \n")).compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
        if !nums.isEmpty { result = calculator.calculate(nums) } }
}

struct SummationCalculatorView: View {
    @State private var firstTerm = ""; @State private var commonDiff = ""; @State private var numTerms = ""; @State private var seriesType = "Arithmetic"
    @State private var result: SummationResult?; private let calculator = SummationCalculator()
    var body: some View {
        Form {
            Section { Picker("Type", selection: $seriesType) { Text("Arithmetic").tag("Arithmetic"); Text("Geometric").tag("Geometric") }.pickerStyle(.segmented).onChange(of: seriesType) { _ in calc() } }
            Section { TextField("First Term (a)", text: $firstTerm).keyboardType(.decimalPad).onChange(of: firstTerm) { _ in calc() }
                TextField(seriesType == "Arithmetic" ? "Common Difference (d)" : "Common Ratio (r)", text: $commonDiff).keyboardType(.decimalPad).onChange(of: commonDiff) { _ in calc() }
                TextField("Number of Terms (n)", text: $numTerms).keyboardType(.numberPad).onChange(of: numTerms) { _ in calc() } }
            if let r = result { Section { VStack { Text("Sum of Series").font(.subheadline); Text(String(format: "%.4f", r.sum)).font(.largeTitle).bold()
                Divider(); HStack { Text("Last Term"); Spacer(); Text(String(format: "%.4f", r.nthTerm)).bold() } }.padding() }
                Section { HStack { ForEach(r.terms.prefix(5), id: \.self) { t in Text(String(format: "%.1f", t)).padding(6).background(Color.blue.opacity(0.2)).cornerRadius(8) } } } header: { Text("First Terms") } }
        }.navigationTitle("Summation").navigationBarTitleDisplayMode(.inline)
    }
    private func calc() { guard let a = Double(firstTerm), let d = Double(commonDiff), let n = Int(numTerms) else { return }
        result = seriesType == "Arithmetic" ? calculator.arithmetic(firstTerm: a, commonDiff: d, numTerms: n) : calculator.geometric(firstTerm: a, commonRatio: d, numTerms: n) }
}
