import SwiftUI

struct MoonPhaseCalculatorView: View {
    @State private var year = "\(Calendar.current.component(.year, from: Date()))"
    @State private var month = "\(Calendar.current.component(.month, from: Date()))"
    @State private var day = "\(Calendar.current.component(.day, from: Date()))"
    @State private var result: MoonPhaseResult?; private let calculator = MoonPhaseCalculator()
    var body: some View {
        Form {
            Section { HStack { TextField("Month", text: $month).keyboardType(.numberPad).onChange(of: month) { _ in calc() }
                TextField("Day", text: $day).keyboardType(.numberPad).onChange(of: day) { _ in calc() }
                TextField("Year", text: $year).keyboardType(.numberPad).onChange(of: year) { _ in calc() } } }
            if let r = result { Section { VStack(spacing: 16) { Text(getMoonEmoji(r.phaseName)).font(.system(size: 80))
                Text(r.phaseName).font(.title).bold(); Text("\(String(format: "%.1f", r.illumination))% illuminated").font(.subheadline) }.frame(maxWidth: .infinity).padding() } }
        }.navigationTitle("Moon Phase").navigationBarTitleDisplayMode(.inline).onAppear { calc() }
    }
    private func calc() { result = calculator.calculate(year: Int(year) ?? 2024, month: Int(month) ?? 1, day: Int(day) ?? 1) }
    private func getMoonEmoji(_ phase: String) -> String { switch phase { case "New Moon": return "🌑"; case "Waxing Crescent": return "🌒"; case "First Quarter": return "🌓"; case "Waxing Gibbous": return "🌔"; case "Full Moon": return "🌕"; case "Waning Gibbous": return "🌖"; case "Last Quarter": return "🌗"; default: return "🌘" } }
}

struct DiceRollerView: View {
    @State private var sides = 6; @State private var count = 2; @State private var result: DiceRollResult?
    @State private var isRolling = false; private let roller = DiceRoller()
    let diceOptions = [4, 6, 8, 10, 12, 20, 100]
    var body: some View {
        Form {
            Section { ScrollView(.horizontal, showsIndicators: false) { HStack { ForEach(diceOptions, id: \.self) { d in Button("D\(d)") { sides = d }.buttonStyle(.bordered).tint(sides == d ? .blue : .gray) } } } }
            Section { Stepper("Dice Count: \(count)", value: $count, in: 1...20) }
            Section { Button(action: { withAnimation(.spring(response: 0.3)) { isRolling = true }; DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { result = roller.roll(sides: sides, count: count); isRolling = false } }) { Text("🎲 Roll Dice").frame(maxWidth: .infinity).padding(8) }.buttonStyle(.borderedProminent) }
            if let r = result { Section { VStack { Text("Total").font(.subheadline); Text("\(r.total)").font(.system(size: 60, weight: .bold)) }.frame(maxWidth: .infinity).padding() }
                Section { ScrollView(.horizontal) { HStack { ForEach(r.rolls.indices, id: \.self) { i in Text("\(r.rolls[i])").padding(8).background(Color.blue.opacity(0.2)).cornerRadius(8) } } } } header: { Text("Individual Rolls") } }
        }.navigationTitle("Dice Roller").navigationBarTitleDisplayMode(.inline)
    }
}

struct HashGeneratorView: View {
    @State private var input = ""; @State private var result: HashResult?
    private let generator = HashGenerator()
    var body: some View {
        Form {
            Section { TextEditor(text: $input).frame(height: 100).onChange(of: input) { _ in if !input.isEmpty { result = generator.generate(input) } else { result = nil } } } header: { Text("Enter Text") }
            if let r = result { ForEach([("MD5", r.md5), ("SHA-1", r.sha1), ("SHA-256", r.sha256), ("SHA-512", r.sha512)], id: \.0) { name, hash in
                Section { HStack { VStack(alignment: .leading) { Text(name).font(.caption).bold(); Text(hash).font(.caption2).lineLimit(2) }; Spacer()
                    Button(action: { UIPasteboard.general.string = hash }) { Image(systemName: "doc.on.doc") } } } } }
        }.navigationTitle("Hash Generator").navigationBarTitleDisplayMode(.inline)
    }
}
