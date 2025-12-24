import SwiftUI

struct CustomCalculatorBuilderView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: BuilderViewModel
    
    var existingCalculator: CustomCalculator?
    var onSave: () -> Void
    
    init(existingCalculator: CustomCalculator? = nil, onSave: @escaping () -> Void) {
        self.existingCalculator = existingCalculator
        self.onSave = onSave
        _viewModel = StateObject(wrappedValue: BuilderViewModel(calculator: existingCalculator))
    }
    
    // Formula helper categories
    let formulaHelpers: [(String, [String])] = [
        ("Basic", ["+", "-", "*", "/", "^", "()", "pi", "e", "phi"]),
        ("Trig", ["sin()", "cos()", "tan()", "asin()", "acos()", "atan()"]),
        ("Log", ["ln()", "log()", "log(x,b)", "exp()"]),
        ("Root", ["sqrt()", "cbrt()", "root(x,n)"]),
        ("Round", ["abs()", "ceil()", "floor()", "round()"]),
        ("Calc", ["deriv(f,x,p)", "integrate(f,x,a,b)"]),
        ("Stat", ["min(a,b)", "max(a,b)", "factorial()"]),
        ("Date", ["age()", "daysBetween()"])
    ]
    
    @State private var selectedTab = 0
    @State private var showHelp = false
    
    var body: some View {
        NavigationStack {
            Form {
                // Title Section
                Section("Calculator Info") {
                    TextField("Calculator Name", text: $viewModel.title)
                }
                
                // Variables Section
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            TextField("Name (e.g. x, rate)", text: $viewModel.varName)
                                .textFieldStyle(.roundedBorder)
                                .autocapitalization(.none)
                            TextField("Unit", text: $viewModel.varUnit)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 70)
                        }
                        
                        TextField("Description (optional)", text: $viewModel.varDesc)
                            .textFieldStyle(.roundedBorder)
                        
                        HStack {
                            TextField("Min", text: $viewModel.varMin)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                            TextField("Max", text: $viewModel.varMax)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                        }
                        
                        Button {
                            viewModel.addVariable()
                        } label: {
                            Label("Add Variable", systemImage: "plus.circle.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                    if !viewModel.variables.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.variables) { variable in
                                    HStack(spacing: 4) {
                                        Button {
                                            viewModel.formula += variable.name
                                        } label: {
                                            Text(variable.name)
                                            if let unit = variable.unitLabel, !unit.isEmpty {
                                                Text("(\(unit))")
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                        Button {
                                            viewModel.removeVariable(variable.name)
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.accentColor.opacity(0.2))
                                    .cornerRadius(16)
                                }
                            }
                        }
                    }
                } header: {
                    HStack {
                        Text("Variables")
                        Spacer()
                        Text("\(viewModel.variables.count) defined")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Formula Section
                Section {
                    TextField("e.g. m * a or sqrt(x^2 + y^2)", text: $viewModel.formula, axis: .vertical)
                        .lineLimit(2...4)
                    
                    Picker("Category", selection: $selectedTab) {
                        ForEach(0..<formulaHelpers.count, id: \.self) { index in
                            Text(formulaHelpers[index].0).tag(index)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(formulaHelpers[selectedTab].1, id: \.self) { op in
                                Button(op) {
                                    let insertText: String
                                    if op.hasSuffix("()") {
                                        insertText = String(op.dropLast(1))
                                    } else if op.contains(",") {
                                        insertText = op.replacingOccurrences(of: "x", with: "")
                                            .replacingOccurrences(of: "a", with: "")
                                            .replacingOccurrences(of: "b", with: "")
                                            .replacingOccurrences(of: "n", with: "")
                                            .replacingOccurrences(of: "p", with: "")
                                            .replacingOccurrences(of: "f", with: "")
                                    } else {
                                        insertText = op
                                    }
                                    viewModel.formula += insertText
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                } header: {
                    HStack {
                        Text("Formula")
                        Spacer()
                        Button {
                            showHelp = true
                        } label: {
                            Label("Help", systemImage: "questionmark.circle")
                                .font(.caption)
                        }
                    }
                }
                
                // Test Section
                Section("Test Formula") {
                    if viewModel.variables.isEmpty {
                        Text("Add variables to test")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(viewModel.variables) { variable in
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(variable.name)
                                            .fontWeight(.medium)
                                        if let unit = variable.unitLabel {
                                            Text("(\(unit))")
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    if let desc = variable.description {
                                        Text(desc)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                Spacer()
                                TextField("0", text: Binding(
                                    get: { viewModel.playgroundValues[variable.name] ?? "" },
                                    set: { viewModel.playgroundValues[variable.name] = $0 }
                                ))
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                                .frame(width: 100)
                            }
                        }
                        
                        Button {
                            viewModel.testFormula()
                        } label: {
                            Label("Calculate", systemImage: "play.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                    Divider()
                    
                    if let error = viewModel.error {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                            Text(error)
                                .foregroundColor(.red)
                        }
                    } else {
                        HStack {
                            Text("Result:")
                                .fontWeight(.medium)
                            Spacer()
                            Text(viewModel.result.isEmpty ? "—" : viewModel.result)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(viewModel.result.isEmpty ? .secondary : .accentColor)
                        }
                    }
                }
                
                // Save Button
                Section {
                    Button {
                        viewModel.saveCalculator()
                        onSave()
                        dismiss()
                    } label: {
                        Label("Save Calculator", systemImage: "checkmark.circle.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle(existingCalculator == nil ? "Build Calculator" : "Edit Calculator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showHelp = true
                    } label: {
                        Image(systemName: "questionmark.circle")
                    }
                }
            }
            .alert("Error", isPresented: .constant(viewModel.saveError != nil)) {
                Button("OK") {
                    viewModel.saveError = nil
                }
            } message: {
                Text(viewModel.saveError ?? "")
            }
            .sheet(isPresented: $showHelp) {
                FunctionHelpView()
            }
        }
    }
}

// MARK: - Function Help View

struct FunctionHelpView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(MathEngine.supportedFunctions, id: \.self) { line in
                    Text(line)
                        .font(.system(.body, design: .monospaced))
                }
            }
            .navigationTitle("Supported Functions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - View Model

@MainActor
class BuilderViewModel: ObservableObject {
    private let service = CustomCalculatorService()
    private var existingId: String?
    private var existingCreatedAt: Date?
    private var existingPinned: Bool = false
    
    @Published var title = ""
    @Published var formula = ""
    @Published var variables: [CalculatorVariable] = []
    
    @Published var varName = ""
    @Published var varUnit = ""
    @Published var varDesc = ""
    @Published var varMin = ""
    @Published var varMax = ""
    
    @Published var playgroundValues: [String: String] = [:]
    @Published var result = ""
    @Published var error: String?
    @Published var saveError: String?
    
    let reservedWords = ["pi", "e", "phi", "log", "ln", "sqrt", "sin", "cos", "tan", "abs",
                         "ceil", "floor", "round", "exp", "asin", "acos", "atan", "sinh", "cosh", "tanh",
                         "cbrt", "root", "min", "max", "deriv", "integrate", "factorial", "mod", "age", "daysbetween"]
    
    init(calculator: CustomCalculator? = nil) {
        if let calc = calculator {
            self.existingId = calc.id
            self.existingCreatedAt = calc.createdAt
            self.existingPinned = calc.pinned
            self.title = calc.title
            self.formula = calc.formula
            self.variables = calc.inputs
            for v in calc.inputs {
                playgroundValues[v.name] = v.defaultValue
            }
        }
    }
    
    func addVariable() {
        let name = varName.trimmingCharacters(in: .whitespaces).lowercased()
        guard !name.isEmpty else { return }
        
        if reservedWords.contains(name) {
            error = "'\(name)' is a reserved word"
            return
        }
        
        if variables.contains(where: { $0.name.lowercased() == name }) {
            error = "Variable '\(varName)' already exists"
            return
        }
        
        let newVar = CalculatorVariable(
            name: varName.trimmingCharacters(in: .whitespaces),
            defaultValue: "0",
            description: varDesc.isEmpty ? nil : varDesc,
            unitLabel: varUnit.isEmpty ? nil : varUnit,
            min: Double(varMin),
            max: Double(varMax)
        )
        
        variables.append(newVar)
        playgroundValues[newVar.name] = "0"
        
        // Clear inputs
        varName = ""
        varUnit = ""
        varDesc = ""
        varMin = ""
        varMax = ""
        error = nil
    }
    
    func removeVariable(_ name: String) {
        variables.removeAll { $0.name == name }
        playgroundValues.removeValue(forKey: name)
    }
    
    func testFormula() {
        error = nil
        result = ""
        
        var inputs: [String: Double] = [:]
        for v in variables {
            guard let text = playgroundValues[v.name], let value = Double(text) else {
                error = "Invalid number for '\(v.name)'"
                return
            }
            if let min = v.min, value < min {
                error = "'\(v.name)' must be ≥ \(min)"
                return
            }
            if let max = v.max, value > max {
                error = "'\(v.name)' must be ≤ \(max)"
                return
            }
            inputs[v.name] = value
        }
        
        switch MathEngine.evaluate(formula: formula, variables: inputs) {
        case .success(let value):
            let formatted = String(format: "%.6f", value)
            // Trim trailing zeros
            result = formatted.replacingOccurrences(of: "\\.?0+$", with: "", options: .regularExpression)
        case .error(let message):
            error = message
        }
    }
    
    func saveCalculator() {
        guard !title.isEmpty else {
            saveError = "Please enter a title"
            return
        }
        guard !formula.isEmpty else {
            saveError = "Please enter a formula"
            return
        }
        
        let calculator = CustomCalculator(
            id: existingId ?? UUID().uuidString,
            title: title,
            inputs: variables,
            formula: formula,
            createdAt: existingCreatedAt ?? Date(),
            updatedAt: Date(),
            pinned: existingPinned
        )
        
        service.saveCalculator(calculator)
    }
}
