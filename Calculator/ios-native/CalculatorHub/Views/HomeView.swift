import SwiftUI

struct HomeView: View {
    var body: some View {
        List {
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
    }
    
    @ViewBuilder
    func calculatorDestination(for calculator: CalculatorItem) -> some View {
        switch calculator.route {
        case "/standard":
            StandardCalculatorView()
        case "/scientific":
            ScientificCalculatorView()
        case "/health/bmi":
            BMICalculatorView()
        case "/finance/interest/compound":
            CompoundInterestCalculatorView()
        default:
            Text("Coming soon: \(calculator.title)")
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

