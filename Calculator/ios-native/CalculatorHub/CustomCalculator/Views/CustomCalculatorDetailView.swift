import SwiftUI

struct CustomCalculatorDetailView: View {
    let calculatorId: String?
    let initialCalculator: CustomCalculator?
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = DetailViewModel()
    
    @State private var showDeleteAlert = false
    @State private var showEditSheet = false
    
    init(calculatorId: String? = nil, calculator: CustomCalculator? = nil) {
        self.calculatorId = calculatorId
        self.initialCalculator = calculator
    }
    
    var body: some View {
        Group {
            if viewModel.loading {
                ProgressView()
            } else if let calc = viewModel.calculator {
                Form {
                    // Formula Display
                    Section("Formula") {
                        Text(calc.formula)
                            .font(.system(.body, design: .monospaced))
                    }
                    
                    // Inputs
                    Section("Inputs") {
                        if calc.inputs.isEmpty {
                            Text("No variables defined")
                                .foregroundColor(.secondary)
                        } else {
                            ForEach(calc.inputs) { variable in
                                HStack {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(variable.name)
                                                .fontWeight(.medium)
                                            if let unit = variable.unitLabel, !unit.isEmpty {
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
                                        get: { viewModel.inputValues[variable.name] ?? "" },
                                        set: { viewModel.inputValues[variable.name] = $0 }
                                    ))
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.decimalPad)
                                    .frame(width: 100)
                                }
                            }
                        }
                        
                        Button {
                            viewModel.calculate()
                        } label: {
                            Label("Calculate", systemImage: "equal.circle.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                    // Result
                    if !viewModel.result.isEmpty || viewModel.error != nil {
                        Section {
                            if let error = viewModel.error {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.red)
                                    Text(error)
                                        .foregroundColor(.red)
                                }
                            } else {
                                VStack {
                                    Text("Result")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text(viewModel.result)
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                            }
                        }
                    }
                }
                .navigationTitle(calc.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button {
                                showEditSheet = true
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            
                            Button(role: .destructive) {
                                showDeleteAlert = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
                .alert("Delete Calculator?", isPresented: $showDeleteAlert) {
                    Button("Cancel", role: .cancel) {}
                    Button("Delete", role: .destructive) {
                        viewModel.delete()
                        dismiss()
                    }
                } message: {
                    Text("This cannot be undone.")
                }
                .sheet(isPresented: $showEditSheet) {
                    if let calc = viewModel.calculator {
                        CustomCalculatorBuilderView(existingCalculator: calc) {
                            viewModel.reload()
                        }
                    }
                }
            } else {
                ContentUnavailableView(
                    "Calculator Not Found",
                    systemImage: "exclamationmark.triangle",
                    description: Text("The calculator could not be loaded.")
                )
            }
        }
        .onAppear {
            viewModel.load(id: calculatorId, calculator: initialCalculator)
        }
    }
}

@MainActor
class DetailViewModel: ObservableObject {
    private let service = CustomCalculatorService()
    
    @Published var calculator: CustomCalculator?
    @Published var loading = true
    @Published var inputValues: [String: String] = [:]
    @Published var result = ""
    @Published var error: String?
    
    func load(id: String?, calculator: CustomCalculator?) {
        loading = true
        
        if let calc = calculator {
            self.calculator = calc
            loadLastValues(calc)
        } else if let id = id {
            self.calculator = service.getById(id)
            if let calc = self.calculator {
                loadLastValues(calc)
            }
        }
        
        loading = false
    }
    
    func reload() {
        if let id = calculator?.id {
            calculator = service.getById(id)
            if let calc = calculator {
                loadLastValues(calc)
            }
        }
    }
    
    private func loadLastValues(_ calc: CustomCalculator) {
        let lastValues = service.getLastValues(calc.id)
        for v in calc.inputs {
            if let savedValue = lastValues[v.name] {
                inputValues[v.name] = String(savedValue)
            } else {
                inputValues[v.name] = v.defaultValue
            }
        }
    }
    
    func calculate() {
        guard let calc = calculator else { return }
        
        error = nil
        result = ""
        
        var inputs: [String: Double] = [:]
        for v in calc.inputs {
            guard let text = inputValues[v.name], let value = Double(text) else {
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
        
        // Save values
        service.saveLastValues(calc.id, values: inputs)
        
        switch MathEngine.evaluate(formula: calc.formula, variables: inputs) {
        case .success(let value):
            result = String(format: "%.4f", value)
        case .error(let message):
            error = message
        }
    }
    
    func delete() {
        if let id = calculator?.id {
            service.deleteCalculator(id)
        }
    }
}
