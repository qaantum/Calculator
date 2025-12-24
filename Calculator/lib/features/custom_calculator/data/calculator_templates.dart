import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/custom_calculator_model.dart';

class CalculatorTemplates {
  static List<CustomCalculator> get templates => [
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'BMI Calculator',
      iconCode: FontAwesomeIcons.weightScale.codePoint,
      iconFontFamily: FontAwesomeIcons.weightScale.fontFamily,
      iconFontPackage: FontAwesomeIcons.weightScale.fontPackage,
      inputs: [
        CalculatorVariable(name: 'weight', unitLabel: 'kg', min: 0, description: 'Your body weight'),
        CalculatorVariable(name: 'height', unitLabel: 'm', min: 0, description: 'Your height in meters'),
      ],
      formula: 'weight / (height ^ 2)',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Discount Calculator',
      iconCode: FontAwesomeIcons.tags.codePoint,
      iconFontFamily: FontAwesomeIcons.tags.fontFamily,
      iconFontPackage: FontAwesomeIcons.tags.fontPackage,
      inputs: [
        CalculatorVariable(name: 'price', unitLabel: '\$', min: 0, description: 'Original Price'),
        CalculatorVariable(name: 'discount', unitLabel: '%', min: 0, max: 100, description: 'Discount Percentage'),
      ],
      formula: 'price * (1 - discount / 100)',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Sales Tax',
      iconCode: FontAwesomeIcons.receipt.codePoint,
      iconFontFamily: FontAwesomeIcons.receipt.fontFamily,
      iconFontPackage: FontAwesomeIcons.receipt.fontPackage,
      inputs: [
        CalculatorVariable(name: 'amount', unitLabel: '\$', min: 0, description: 'Pre-tax Amount'),
        CalculatorVariable(name: 'tax_rate', unitLabel: '%', min: 0, max: 100, description: 'Tax Rate'),
      ],
      formula: 'amount * (1 + tax_rate / 100)',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Tip Calculator',
      iconCode: FontAwesomeIcons.coins.codePoint,
      iconFontFamily: FontAwesomeIcons.coins.fontFamily,
      iconFontPackage: FontAwesomeIcons.coins.fontPackage,
      inputs: [
        CalculatorVariable(name: 'bill', unitLabel: '\$', min: 0, description: 'Bill Amount'),
        CalculatorVariable(name: 'tip_percent', unitLabel: '%', min: 0, description: 'Tip Percentage'),
        CalculatorVariable(name: 'people', unitLabel: '', min: 1, type: VariableType.integer, description: 'Number of People (split)'),
      ],
      formula: '(bill * (1 + tip_percent / 100)) / people',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Circle Area',
      iconCode: FontAwesomeIcons.circle.codePoint,
      iconFontFamily: FontAwesomeIcons.circle.fontFamily,
      iconFontPackage: FontAwesomeIcons.circle.fontPackage,
      inputs: [
        CalculatorVariable(name: 'r', unitLabel: 'm', min: 0, description: 'Radius'),
      ],
      formula: 'pi * r^2',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Finance
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Simple Loan',
      iconCode: FontAwesomeIcons.moneyBillWave.codePoint,
      iconFontFamily: FontAwesomeIcons.moneyBillWave.fontFamily,
      iconFontPackage: FontAwesomeIcons.moneyBillWave.fontPackage,
      inputs: [
        CalculatorVariable(name: 'principal', unitLabel: '\$', min: 0, description: 'Loan Amount'),
        CalculatorVariable(name: 'rate', unitLabel: '%', min: 0, description: 'Annual Interest Rate'),
        CalculatorVariable(name: 'years', unitLabel: 'yr', min: 0, description: 'Loan Term'),
      ],
      formula: 'principal * (1 + (rate/100) * years)',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Finance - Mortgage
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Mortgage Calculator',
      iconCode: FontAwesomeIcons.house.codePoint,
      iconFontFamily: FontAwesomeIcons.house.fontFamily,
      iconFontPackage: FontAwesomeIcons.house.fontPackage,
      inputs: [
        CalculatorVariable(name: 'principal', unitLabel: '\$', min: 0, description: 'Loan Amount'),
        CalculatorVariable(name: 'rate', unitLabel: '%', min: 0, description: 'Annual Interest Rate'),
        CalculatorVariable(name: 'years', unitLabel: 'yr', min: 0, description: 'Loan Term'),
      ],
      // Monthly payment formula: P * (r(1+r)^n) / ((1+r)^n - 1)
      // r = rate / 100 / 12, n = years * 12
      formula: '(principal * ((rate/1200) * ((1 + rate/1200)^(years*12)))) / (((1 + rate/1200)^(years*12)) - 1)',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Finance - Auto Loan
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Auto Loan Calculator',
      iconCode: FontAwesomeIcons.car.codePoint,
      iconFontFamily: FontAwesomeIcons.car.fontFamily,
      iconFontPackage: FontAwesomeIcons.car.fontPackage,
      inputs: [
        CalculatorVariable(name: 'price', unitLabel: '\$', min: 0, description: 'Vehicle Price'),
        CalculatorVariable(name: 'down_payment', unitLabel: '\$', min: 0, description: 'Down Payment'),
        CalculatorVariable(name: 'rate', unitLabel: '%', min: 0, description: 'Interest Rate'),
        CalculatorVariable(name: 'months', unitLabel: 'mo', min: 0, description: 'Loan Term (Months)'),
      ],
      formula: '((price - down_payment) * ((rate/1200) * ((1 + rate/1200)^months))) / (((1 + rate/1200)^months) - 1)',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Finance - ROI
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'ROI Calculator',
      iconCode: FontAwesomeIcons.chartLine.codePoint,
      iconFontFamily: FontAwesomeIcons.chartLine.fontFamily,
      iconFontPackage: FontAwesomeIcons.chartLine.fontPackage,
      inputs: [
        CalculatorVariable(name: 'initial', unitLabel: '\$', min: 0, description: 'Initial Investment'),
        CalculatorVariable(name: 'final_val', unitLabel: '\$', min: 0, description: 'Final Value'),
      ],
      formula: '((final_val - initial) / initial) * 100',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Finance - Break Even
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Break-Even Point',
      iconCode: FontAwesomeIcons.scaleBalanced.codePoint,
      iconFontFamily: FontAwesomeIcons.scaleBalanced.fontFamily,
      iconFontPackage: FontAwesomeIcons.scaleBalanced.fontPackage,
      inputs: [
        CalculatorVariable(name: 'fixed_costs', unitLabel: '\$', min: 0, description: 'Total Fixed Costs'),
        CalculatorVariable(name: 'price', unitLabel: '\$', min: 0, description: 'Price per Unit'),
        CalculatorVariable(name: 'variable_cost', unitLabel: '\$', min: 0, description: 'Variable Cost per Unit'),
      ],
      formula: 'fixed_costs / (price - variable_cost)',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Finance - Margin
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Profit Margin',
      iconCode: FontAwesomeIcons.percent.codePoint,
      iconFontFamily: FontAwesomeIcons.percent.fontFamily,
      iconFontPackage: FontAwesomeIcons.percent.fontPackage,
      inputs: [
        CalculatorVariable(name: 'cost', unitLabel: '\$', min: 0, description: 'Cost'),
        CalculatorVariable(name: 'revenue', unitLabel: '\$', min: 0, description: 'Revenue'),
      ],
      formula: '((revenue - cost) / revenue) * 100',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Finance - Markup
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Markup Calculator',
      iconCode: FontAwesomeIcons.arrowTrendUp.codePoint,
      iconFontFamily: FontAwesomeIcons.arrowTrendUp.fontFamily,
      iconFontPackage: FontAwesomeIcons.arrowTrendUp.fontPackage,
      inputs: [
        CalculatorVariable(name: 'cost', unitLabel: '\$', min: 0, description: 'Cost'),
        CalculatorVariable(name: 'price', unitLabel: '\$', min: 0, description: 'Selling Price'),
      ],
      formula: '((price - cost) / cost) * 100',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Finance - Rule of 72
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Rule of 72',
      iconCode: FontAwesomeIcons.hourglassHalf.codePoint,
      iconFontFamily: FontAwesomeIcons.hourglassHalf.fontFamily,
      iconFontPackage: FontAwesomeIcons.hourglassHalf.fontPackage,
      inputs: [
        CalculatorVariable(name: 'rate', unitLabel: '%', min: 0, description: 'Annual Interest Rate'),
      ],
      formula: '72 / rate',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Finance - Net Worth
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Net Worth',
      iconCode: FontAwesomeIcons.sackDollar.codePoint,
      iconFontFamily: FontAwesomeIcons.sackDollar.fontFamily,
      iconFontPackage: FontAwesomeIcons.sackDollar.fontPackage,
      inputs: [
        CalculatorVariable(name: 'assets', unitLabel: '\$', min: 0, description: 'Total Assets'),
        CalculatorVariable(name: 'liabilities', unitLabel: '\$', min: 0, description: 'Total Liabilities'),
      ],
      formula: 'assets - liabilities',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Finance - Unit Price
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Unit Price',
      iconCode: FontAwesomeIcons.tag.codePoint,
      iconFontFamily: FontAwesomeIcons.tag.fontFamily,
      iconFontPackage: FontAwesomeIcons.tag.fontPackage,
      inputs: [
        CalculatorVariable(name: 'price', unitLabel: '\$', min: 0, description: 'Total Price'),
        CalculatorVariable(name: 'quantity', unitLabel: '', min: 0, description: 'Quantity/Weight/Volume'),
      ],
      formula: 'price / quantity',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Finance - Electricity Cost
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Electricity Cost',
      iconCode: FontAwesomeIcons.bolt.codePoint,
      iconFontFamily: FontAwesomeIcons.bolt.fontFamily,
      iconFontPackage: FontAwesomeIcons.bolt.fontPackage,
      inputs: [
        CalculatorVariable(name: 'power', unitLabel: 'W', min: 0, description: 'Power Consumption (Watts)'),
        CalculatorVariable(name: 'hours', unitLabel: 'h', min: 0, description: 'Hours per Day'),
        CalculatorVariable(name: 'cost_kwh', unitLabel: '\$', min: 0, description: 'Cost per kWh'),
      ],
      formula: '(power * hours * 30 * cost_kwh) / 1000', // Monthly cost
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Finance - Inflation
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Inflation Calculator',
      iconCode: FontAwesomeIcons.moneyBillTrendUp.codePoint,
      iconFontFamily: FontAwesomeIcons.moneyBillTrendUp.fontFamily,
      iconFontPackage: FontAwesomeIcons.moneyBillTrendUp.fontPackage,
      inputs: [
        CalculatorVariable(name: 'amount', unitLabel: '\$', min: 0, description: 'Current Amount'),
        CalculatorVariable(name: 'rate', unitLabel: '%', min: 0, description: 'Inflation Rate'),
        CalculatorVariable(name: 'years', unitLabel: 'yr', min: 0, description: 'Years'),
      ],
      formula: 'amount * ((1 + rate/100)^years)', // Future Value
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Finance - Effective Rate
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Effective Annual Rate',
      iconCode: FontAwesomeIcons.percent.codePoint,
      iconFontFamily: FontAwesomeIcons.percent.fontFamily,
      iconFontPackage: FontAwesomeIcons.percent.fontPackage,
      inputs: [
        CalculatorVariable(name: 'nominal_rate', unitLabel: '%', min: 0, description: 'Nominal Rate'),
        CalculatorVariable(name: 'periods', unitLabel: '', min: 1, description: 'Compounding Periods per Year'),
      ],
      formula: '((1 + (nominal_rate/100)/periods)^periods - 1) * 100',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Health - BMR (Mifflin-St Jeor)
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'BMR Calculator',
      iconCode: FontAwesomeIcons.fire.codePoint,
      iconFontFamily: FontAwesomeIcons.fire.fontFamily,
      iconFontPackage: FontAwesomeIcons.fire.fontPackage,
      inputs: [
        CalculatorVariable(name: 'weight', unitLabel: 'kg', min: 0, description: 'Weight'),
        CalculatorVariable(name: 'height', unitLabel: 'cm', min: 0, description: 'Height'),
        CalculatorVariable(name: 'age', unitLabel: 'yr', min: 0, description: 'Age'),
        // Note: Gender factor (s) is hard to model with simple variables. Using Male (+5) as default or averaging.
        // Better: Add a variable 's' where user enters +5 for Male, -161 for Female.
        CalculatorVariable(name: 'gender_factor', unitLabel: '', min: -161, max: 5, description: 'Gender Factor (+5 Male, -161 Female)'),
      ],
      formula: '(10 * weight) + (6.25 * height) - (5 * age) + gender_factor',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Health - Body Fat (US Navy - Simplified for Male)
    // Female formula is much more complex with hips. We'll stick to a generic or Male version for the template.
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Body Fat (Male)',
      iconCode: FontAwesomeIcons.person.codePoint,
      iconFontFamily: FontAwesomeIcons.person.fontFamily,
      iconFontPackage: FontAwesomeIcons.person.fontPackage,
      inputs: [
        CalculatorVariable(name: 'waist', unitLabel: 'cm', min: 0, description: 'Waist Circumference'),
        CalculatorVariable(name: 'neck', unitLabel: 'cm', min: 0, description: 'Neck Circumference'),
        CalculatorVariable(name: 'height', unitLabel: 'cm', min: 0, description: 'Height'),
      ],
      // 495 / (1.0324 - 0.19077 * log10(waist - neck) + 0.15456 * log10(height)) - 450
      formula: '495 / (1.0324 - 0.19077 * log(waist - neck, 10) + 0.15456 * log(height, 10)) - 450',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Health - Ideal Weight (Devine)
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Ideal Weight (Male)',
      iconCode: FontAwesomeIcons.weightScale.codePoint,
      iconFontFamily: FontAwesomeIcons.weightScale.fontFamily,
      iconFontPackage: FontAwesomeIcons.weightScale.fontPackage,
      inputs: [
        CalculatorVariable(name: 'height_inches', unitLabel: 'in', min: 0, description: 'Height in Inches'),
      ],
      // 50 kg + 2.3 kg per inch over 5ft (60 inches)
      formula: '50 + 2.3 * (height_inches - 60)',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Health - Pace
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Running Pace',
      iconCode: FontAwesomeIcons.personRunning.codePoint,
      iconFontFamily: FontAwesomeIcons.personRunning.fontFamily,
      iconFontPackage: FontAwesomeIcons.personRunning.fontPackage,
      inputs: [
        CalculatorVariable(name: 'time_min', unitLabel: 'min', min: 0, description: 'Time in Minutes'),
        CalculatorVariable(name: 'distance_km', unitLabel: 'km', min: 0, description: 'Distance in km'),
      ],
      formula: 'time_min / distance_km', // min/km
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Health - Water Intake
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Water Intake',
      iconCode: FontAwesomeIcons.glassWater.codePoint,
      iconFontFamily: FontAwesomeIcons.glassWater.fontFamily,
      iconFontPackage: FontAwesomeIcons.glassWater.fontPackage,
      inputs: [
        CalculatorVariable(name: 'weight', unitLabel: 'kg', min: 0, description: 'Weight'),
      ],
      formula: 'weight * 35', // 35ml per kg
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Health - Target Heart Rate (Karvonen - 70% intensity)
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Target Heart Rate',
      iconCode: FontAwesomeIcons.heartPulse.codePoint,
      iconFontFamily: FontAwesomeIcons.heartPulse.fontFamily,
      iconFontPackage: FontAwesomeIcons.heartPulse.fontPackage,
      inputs: [
        CalculatorVariable(name: 'age', unitLabel: 'yr', min: 0, description: 'Age'),
        CalculatorVariable(name: 'resting_hr', unitLabel: 'bpm', min: 0, description: 'Resting Heart Rate'),
        CalculatorVariable(name: 'intensity', unitLabel: '%', min: 0, max: 100, description: 'Intensity %'),
      ],
      // ((220 - age) - resting) * intensity + resting
      formula: '((220 - age) - resting_hr) * (intensity / 100) + resting_hr',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Health - BAC (Widmark - Male)
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'BAC Calculator',
      iconCode: FontAwesomeIcons.wineGlass.codePoint,
      iconFontFamily: FontAwesomeIcons.wineGlass.fontFamily,
      iconFontPackage: FontAwesomeIcons.wineGlass.fontPackage,
      inputs: [
        CalculatorVariable(name: 'alcohol_grams', unitLabel: 'g', min: 0, description: 'Alcohol Consumed (grams)'),
        CalculatorVariable(name: 'weight', unitLabel: 'kg', min: 0, description: 'Body Weight'),
        CalculatorVariable(name: 'hours', unitLabel: 'h', min: 0, description: 'Time Since Drinking'),
        CalculatorVariable(name: 'r', unitLabel: '', min: 0.55, max: 0.68, description: 'Distribution Ratio (0.68 Male, 0.55 Female)'),
      ],
      // (Alcohol / (Weight * r)) * 100 - (0.015 * hours)
      formula: '((alcohol_grams / (weight * 1000 * r)) * 100) - (0.015 * hours)',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Math - Percentage
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Percentage Calculator',
      iconCode: FontAwesomeIcons.percent.codePoint,
      iconFontFamily: FontAwesomeIcons.percent.fontFamily,
      iconFontPackage: FontAwesomeIcons.percent.fontPackage,
      inputs: [
        CalculatorVariable(name: 'value', unitLabel: '', min: 0, description: 'Value'),
        CalculatorVariable(name: 'total', unitLabel: '', min: 0, description: 'Total'),
      ],
      formula: '(value / total) * 100',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Math - Aspect Ratio (Width from Height)
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Aspect Ratio (Width)',
      iconCode: FontAwesomeIcons.expand.codePoint,
      iconFontFamily: FontAwesomeIcons.expand.fontFamily,
      iconFontPackage: FontAwesomeIcons.expand.fontPackage,
      inputs: [
        CalculatorVariable(name: 'height', unitLabel: 'px', min: 0, description: 'Height'),
        CalculatorVariable(name: 'ratio_w', unitLabel: '', min: 0, description: 'Ratio Width (e.g. 16)'),
        CalculatorVariable(name: 'ratio_h', unitLabel: '', min: 0, description: 'Ratio Height (e.g. 9)'),
      ],
      formula: 'height * (ratio_w / ratio_h)',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Electronics - Ohm's Law (Voltage)
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Ohm\'s Law (Voltage)',
      iconCode: FontAwesomeIcons.bolt.codePoint,
      iconFontFamily: FontAwesomeIcons.bolt.fontFamily,
      iconFontPackage: FontAwesomeIcons.bolt.fontPackage,
      inputs: [
        CalculatorVariable(name: 'current', unitLabel: 'A', min: 0, description: 'Current'),
        CalculatorVariable(name: 'resistance', unitLabel: 'Ω', min: 0, description: 'Resistance'),
      ],
      formula: 'current * resistance',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Science - Force
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Force (F=ma)',
      iconCode: FontAwesomeIcons.weightHanging.codePoint,
      iconFontFamily: FontAwesomeIcons.weightHanging.fontFamily,
      iconFontPackage: FontAwesomeIcons.weightHanging.fontPackage,
      inputs: [
        CalculatorVariable(name: 'mass', unitLabel: 'kg', min: 0, description: 'Mass'),
        CalculatorVariable(name: 'acceleration', unitLabel: 'm/s²', min: 0, description: 'Acceleration'),
      ],
      formula: 'mass * acceleration',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Science - Kinetic Energy
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Kinetic Energy',
      iconCode: FontAwesomeIcons.atom.codePoint,
      iconFontFamily: FontAwesomeIcons.atom.fontFamily,
      iconFontPackage: FontAwesomeIcons.atom.fontPackage,
      inputs: [
        CalculatorVariable(name: 'mass', unitLabel: 'kg', min: 0, description: 'Mass'),
        CalculatorVariable(name: 'velocity', unitLabel: 'm/s', min: 0, description: 'Velocity'),
      ],
      formula: '0.5 * mass * (velocity ^ 2)',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Science - Density
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Density',
      iconCode: FontAwesomeIcons.cube.codePoint,
      iconFontFamily: FontAwesomeIcons.cube.fontFamily,
      iconFontPackage: FontAwesomeIcons.cube.fontPackage,
      inputs: [
        CalculatorVariable(name: 'mass', unitLabel: 'kg', min: 0, description: 'Mass'),
        CalculatorVariable(name: 'volume', unitLabel: 'm³', min: 0, description: 'Volume'),
      ],
      formula: 'mass / volume',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Science - Acceleration
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Acceleration',
      iconCode: FontAwesomeIcons.gaugeHigh.codePoint,
      iconFontFamily: FontAwesomeIcons.gaugeHigh.fontFamily,
      iconFontPackage: FontAwesomeIcons.gaugeHigh.fontPackage,
      inputs: [
        CalculatorVariable(name: 'final_v', unitLabel: 'm/s', min: 0, description: 'Final Velocity'),
        CalculatorVariable(name: 'initial_v', unitLabel: 'm/s', min: 0, description: 'Initial Velocity'),
        CalculatorVariable(name: 'time', unitLabel: 's', min: 0, description: 'Time'),
      ],
      formula: '(final_v - initial_v) / time',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Science - Power (Work/Time)
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Power',
      iconCode: FontAwesomeIcons.plug.codePoint,
      iconFontFamily: FontAwesomeIcons.plug.fontFamily,
      iconFontPackage: FontAwesomeIcons.plug.fontPackage,
      inputs: [
        CalculatorVariable(name: 'work', unitLabel: 'J', min: 0, description: 'Work Done'),
        CalculatorVariable(name: 'time', unitLabel: 's', min: 0, description: 'Time'),
      ],
      formula: 'work / time',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Lifestyle - Age
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Age Calculator',
      iconCode: FontAwesomeIcons.cakeCandles.codePoint,
      iconFontFamily: FontAwesomeIcons.cakeCandles.fontFamily,
      iconFontPackage: FontAwesomeIcons.cakeCandles.fontPackage,
      inputs: [
        CalculatorVariable(name: 'birthdate', unitLabel: '', type: VariableType.date, description: 'Date of Birth'),
      ],
      formula: 'age(birthdate)',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Lifestyle - Date Difference
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Date Difference',
      iconCode: FontAwesomeIcons.calendarDays.codePoint,
      iconFontFamily: FontAwesomeIcons.calendarDays.fontFamily,
      iconFontPackage: FontAwesomeIcons.calendarDays.fontPackage,
      inputs: [
        CalculatorVariable(name: 'start_date', unitLabel: '', type: VariableType.date, description: 'Start Date'),
        CalculatorVariable(name: 'end_date', unitLabel: '', type: VariableType.date, description: 'End Date'),
      ],
      formula: 'daysBetween(start_date, end_date)',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Lifestyle - Days Until
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Days Until Event',
      iconCode: FontAwesomeIcons.hourglassStart.codePoint,
      iconFontFamily: FontAwesomeIcons.hourglassStart.fontFamily,
      iconFontPackage: FontAwesomeIcons.hourglassStart.fontPackage,
      inputs: [
        CalculatorVariable(name: 'event_date', unitLabel: '', type: VariableType.date, description: 'Event Date'),
        CalculatorVariable(name: 'today', unitLabel: '', type: VariableType.date, description: 'Today (or Start Date)'),
      ],
      formula: 'daysBetween(today, event_date)',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Conversion - Celsius to Fahrenheit
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Celsius to Fahrenheit',
      iconCode: FontAwesomeIcons.temperatureHalf.codePoint,
      iconFontFamily: FontAwesomeIcons.temperatureHalf.fontFamily,
      iconFontPackage: FontAwesomeIcons.temperatureHalf.fontPackage,
      inputs: [
        CalculatorVariable(name: 'celsius', unitLabel: '°C', description: 'Temperature in Celsius'),
      ],
      formula: '(celsius * 9/5) + 32',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Conversion - Fahrenheit to Celsius
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Fahrenheit to Celsius',
      iconCode: FontAwesomeIcons.temperatureHalf.codePoint,
      iconFontFamily: FontAwesomeIcons.temperatureHalf.fontFamily,
      iconFontPackage: FontAwesomeIcons.temperatureHalf.fontPackage,
      inputs: [
        CalculatorVariable(name: 'fahrenheit', unitLabel: '°F', description: 'Temperature in Fahrenheit'),
      ],
      formula: '(fahrenheit - 32) * 5/9',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Conversion - Fuel Efficiency (L/100km to MPG)
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'L/100km to MPG',
      iconCode: FontAwesomeIcons.gasPump.codePoint,
      iconFontFamily: FontAwesomeIcons.gasPump.fontFamily,
      iconFontPackage: FontAwesomeIcons.gasPump.fontPackage,
      inputs: [
        CalculatorVariable(name: 'l_per_100km', unitLabel: 'L/100km', min: 0, description: 'Litres per 100km'),
      ],
      formula: '235.215 / l_per_100km',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    // Finance - Monthly Savings
    CustomCalculator(
      id: const Uuid().v4(),
      title: 'Monthly Savings',
      iconCode: FontAwesomeIcons.piggyBank.codePoint,
      iconFontFamily: FontAwesomeIcons.piggyBank.fontFamily,
      iconFontPackage: FontAwesomeIcons.piggyBank.fontPackage,
      inputs: [
        CalculatorVariable(name: 'initial', unitLabel: '\$', min: 0, description: 'Initial Balance'),
        CalculatorVariable(name: 'monthly', unitLabel: '\$', min: 0, description: 'Monthly Contribution'),
        CalculatorVariable(name: 'rate', unitLabel: '%', min: 0, description: 'Annual Interest Rate'),
        CalculatorVariable(name: 'years', unitLabel: 'yr', min: 0, description: 'Duration'),
      ],
      // FV = P(1+r)^t + PMT * (((1+r)^t - 1) / r)
      // r = rate/100/12, t = years*12
      formula: '(initial * (1 + rate/1200)^(years*12)) + (monthly * (((1 + rate/1200)^(years*12) - 1) / (rate/1200)))',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  static final Map<String, String> _routeToTemplateTitle = {
    '/finance/loan': 'Simple Loan',
    '/finance/mortgage': 'Mortgage Calculator',
    '/finance/car': 'Auto Loan Calculator',
    '/finance/discount': 'Discount Calculator',
    '/finance/salestax': 'Sales Tax',
    '/finance/tip': 'Tip Calculator',
    '/finance/roi': 'ROI Calculator',
    '/finance/breakeven': 'Break-Even Point',
    '/finance/margin': 'Profit Margin', // Maps to Margin Calculator
    '/finance/rule72': 'Rule of 72',
    '/finance/networth': 'Net Worth',
    '/finance/unitprice': 'Unit Price',
    '/finance/electricity': 'Electricity Cost',
    '/finance/inflation': 'Inflation Calculator',
    '/finance/effectiverate': 'Effective Annual Rate',
    '/health/bmi': 'BMI Calculator',
    '/health/bmr': 'BMR Calculator',
    '/health/bodyfat': 'Body Fat (Male)',
    '/health/idealweight': 'Ideal Weight (Male)',
    '/health/pace': 'Running Pace',
    '/health/water': 'Water Intake',
    '/health/heartrate': 'Target Heart Rate',
    '/health/bac': 'BAC Calculator',
    '/math/area': 'Circle Area',
    '/math/percentage': 'Percentage Calculator',
    '/math/aspectratio': 'Aspect Ratio (Width)',
    '/electronics/ohms': 'Ohm\'s Law (Voltage)',
    '/science/force': 'Force (F=ma)',
    '/science/kinetic': 'Kinetic Energy',
    '/science/density': 'Density',
    '/science/acceleration': 'Acceleration',
    '/science/power': 'Power',
    '/science/acceleration': 'Acceleration',
    '/science/power': 'Power',
    '/lifestyle/age': 'Age Calculator',
    '/lifestyle/date': 'Date Difference',
    '/lifestyle/date': 'Date Difference',
    '/lifestyle/daysuntil': 'Days Until Event',
    '/conversion/c2f': 'Celsius to Fahrenheit',
    '/conversion/f2c': 'Fahrenheit to Celsius',
    '/conversion/fuel': 'L/100km to MPG',
    '/finance/savings': 'Monthly Savings',
  };

  static CustomCalculator? getTemplateForRoute(String route) {
    final title = _routeToTemplateTitle[route];
    if (title == null) return null;
    try {
      return templates.firstWhere((t) => t.title == title);
    } catch (_) {
      return null;
    }
  }
}
