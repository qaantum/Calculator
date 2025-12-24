import SwiftUI

struct CustomCalculatorListView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ListViewModel()
    
    @State private var showCreateSheet = false
    @State private var selectedTemplate: CustomCalculator?
    @State private var selectedCategory = "All"
    
    let templateCategories = ["All", "Finance", "Physics", "Math", "Health", "Conversions", "Advanced"]
    
    var categorizedTemplates: [String: [CustomCalculator]] {
        [
            "Finance": CalculatorTemplates.templates.filter {
                ["BMI Calculator", "Compound Interest", "Mortgage Payment", "Tip Calculator", "ROI Calculator", "Rule of 72"].contains($0.title)
            },
            "Physics": CalculatorTemplates.templates.filter {
                ["Force (F = ma)", "Kinetic Energy", "Gravitational Force", "Ohm's Law (V = IR)", "Projectile Range", "Wave Frequency"].contains($0.title)
            },
            "Math": CalculatorTemplates.templates.filter {
                ["Quadratic Formula", "Circle Area", "Sphere Volume", "Pythagorean Theorem", "Distance Formula"].contains($0.title)
            },
            "Health": CalculatorTemplates.templates.filter {
                ["BMI Calculator", "BMR (Mifflin-St Jeor)", "Target Heart Rate", "Water Intake"].contains($0.title)
            },
            "Conversions": CalculatorTemplates.templates.filter {
                ["Celsius to Fahrenheit", "Fahrenheit to Celsius", "Km to Miles", "Kg to Pounds"].contains($0.title)
            },
            "Advanced": CalculatorTemplates.templates.filter {
                ["Definite Integral ∫x² dx", "Derivative at Point", "Logarithm (any base)", "Trigonometry", "Days Between Dates", "Age Calculator"].contains($0.title)
            }
        ]
    }
    
    var displayedTemplates: [CustomCalculator] {
        if selectedCategory == "All" {
            return CalculatorTemplates.templates
        }
        return categorizedTemplates[selectedCategory] ?? []
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Header Section
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Image(systemName: "function")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(Color.accentColor)
                                .cornerRadius(10)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Build Your Own")
                                    .font(.headline)
                                Text("Create custom formulas with 30+ math functions")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        HStack(spacing: 8) {
                            ForEach(["sin, cos, tan", "∫ integrate", "d/dx"], id: \.self) { label in
                                Text(label)
                                    .font(.caption2)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.secondary.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Your Calculators Section
                Section {
                    if viewModel.calculators.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "function")
                                .font(.system(size: 40))
                                .foregroundColor(.secondary)
                            
                            Text("No custom calculators yet")
                                .font(.headline)
                            
                            Text("Create your own or start from a template")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            
                            Button {
                                showCreateSheet = true
                            } label: {
                                Label("Create New", systemImage: "plus.circle.fill")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                    } else {
                        ForEach(viewModel.calculators) { calc in
                            NavigationLink {
                                CustomCalculatorDetailView(calculator: calc)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(calc.title)
                                        .font(.headline)
                                    Text(calc.formula)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                    HStack {
                                        Text("\(calc.inputs.count) variables")
                                            .font(.caption2)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 2)
                                            .background(Color.accentColor.opacity(0.2))
                                            .cornerRadius(8)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                } header: {
                    Text("Your Calculators")
                }
                
                // Templates Section
                Section {
                    // Category Picker
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(templateCategories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.vertical, 4)
                    
                    // Template Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(displayedTemplates) { template in
                            TemplateCardView(template: template) {
                                selectedTemplate = template
                            }
                        }
                    }
                    .padding(.vertical, 8)
                } header: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Templates")
                        Text("Start with a pre-built formula and customize it")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Custom Calculators")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showCreateSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showCreateSheet) {
                CustomCalculatorBuilderView {
                    viewModel.reload()
                }
            }
            .sheet(item: $selectedTemplate) { template in
                // Create a copy of the template for editing
                CustomCalculatorBuilderView(existingCalculator: CustomCalculator(
                    title: "\(template.title) (Copy)",
                    iconName: template.iconName,
                    inputs: template.inputs,
                    formula: template.formula
                )) {
                    viewModel.reload()
                }
            }
            .onAppear {
                viewModel.reload()
            }
        }
    }
}

// MARK: - Template Card View

struct TemplateCardView: View {
    let template: CustomCalculator
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                Text(template.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(template.formula)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - View Model

@MainActor
class ListViewModel: ObservableObject {
    private let service = CustomCalculatorService()
    
    @Published var calculators: [CustomCalculator] = []
    
    func reload() {
        calculators = service.getCalculators()
    }
}

#Preview {
    CustomCalculatorListView()
}
