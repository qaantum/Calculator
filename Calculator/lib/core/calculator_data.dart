import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CalculatorItem {
  final String title;
  final IconData icon;
  final String route;
  final String category;

  const CalculatorItem({
    required this.title,
    required this.icon,
    required this.route,
    required this.category,
  });
}

final List<CalculatorItem> allCalculators = [
  // Standard
  const CalculatorItem(title: 'Standard', icon: FontAwesomeIcons.calculator, route: '/standard', category: 'Standard'),
  const CalculatorItem(title: 'Scientific', icon: FontAwesomeIcons.flask, route: '/scientific', category: 'Scientific'),

  // Finance
  const CalculatorItem(title: 'Amortization', icon: FontAwesomeIcons.tableList, route: '/finance/amortization', category: 'Finance'),
  const CalculatorItem(title: 'Auto Loan', icon: FontAwesomeIcons.car, route: '/finance/car', category: 'Finance'),
  const CalculatorItem(title: 'Break-Even', icon: FontAwesomeIcons.scaleBalanced, route: '/finance/breakeven', category: 'Finance'),
  const CalculatorItem(title: 'CAGR', icon: FontAwesomeIcons.arrowTrendUp, route: '/finance/cagr', category: 'Finance'),
  const CalculatorItem(title: 'Currency', icon: FontAwesomeIcons.arrowRightArrowLeft, route: '/finance/currency', category: 'Finance'),
  const CalculatorItem(title: 'Discount', icon: FontAwesomeIcons.tags, route: '/finance/discount', category: 'Finance'),
  const CalculatorItem(title: 'Effective Rate', icon: FontAwesomeIcons.chartLine, route: '/finance/effectiverate', category: 'Finance'),
  const CalculatorItem(title: 'Electricity', icon: FontAwesomeIcons.bolt, route: '/finance/electricity', category: 'Finance'),
  const CalculatorItem(title: 'Inflation', icon: FontAwesomeIcons.arrowTrendUp, route: '/finance/inflation', category: 'Finance'),
  const CalculatorItem(title: 'Compound Interest', icon: FontAwesomeIcons.chartLine, route: '/finance/interest/compound', category: 'Finance'),
  const CalculatorItem(title: 'Credit Card Payoff', icon: FontAwesomeIcons.creditCard, route: '/finance/creditcard', category: 'Finance'),
  const CalculatorItem(title: 'Investment', icon: FontAwesomeIcons.moneyBillTrendUp, route: '/finance/investment', category: 'Finance'),
  const CalculatorItem(title: 'Loan', icon: FontAwesomeIcons.moneyBillWave, route: '/finance/loan', category: 'Finance'),
  const CalculatorItem(title: 'Loan Affordability', icon: FontAwesomeIcons.handHoldingDollar, route: '/finance/affordability', category: 'Finance'),
  const CalculatorItem(title: 'Margin', icon: FontAwesomeIcons.shop, route: '/finance/margin', category: 'Finance'),
  const CalculatorItem(title: 'Mortgage', icon: FontAwesomeIcons.house, route: '/finance/mortgage', category: 'Finance'),
  const CalculatorItem(title: 'Refinance', icon: FontAwesomeIcons.rotate, route: '/finance/refinance', category: 'Finance'),
  const CalculatorItem(title: 'Rental Property', icon: FontAwesomeIcons.houseUser, route: '/finance/rental', category: 'Finance'),
  const CalculatorItem(title: 'Retirement', icon: FontAwesomeIcons.umbrellaBeach, route: '/finance/retirement', category: 'Finance'),
  const CalculatorItem(title: 'ROI', icon: FontAwesomeIcons.chartPie, route: '/finance/roi', category: 'Finance'),
  const CalculatorItem(title: 'Rule of 72', icon: FontAwesomeIcons.hourglassHalf, route: '/finance/rule72', category: 'Finance'),
  const CalculatorItem(title: 'Salary', icon: FontAwesomeIcons.briefcase, route: '/finance/salary', category: 'Finance'),
  const CalculatorItem(title: 'Savings Goal', icon: FontAwesomeIcons.piggyBank, route: '/finance/savings', category: 'Finance'),
  const CalculatorItem(title: 'Sales Tax', icon: FontAwesomeIcons.receipt, route: '/finance/salestax', category: 'Finance'),
  const CalculatorItem(title: 'Simple Interest', icon: FontAwesomeIcons.percent, route: '/finance/interest', category: 'Finance'),
  const CalculatorItem(title: 'Tax', icon: FontAwesomeIcons.calculator, route: '/finance/tax', category: 'Finance'),
  const CalculatorItem(title: 'TVM Calculator', icon: FontAwesomeIcons.moneyBillTrendUp, route: '/finance/tvm', category: 'Finance'),
  const CalculatorItem(title: 'Unit Price', icon: FontAwesomeIcons.tag, route: '/finance/unitprice', category: 'Finance'),

  // Health
  const CalculatorItem(title: 'BAC', icon: FontAwesomeIcons.wineGlass, route: '/health/bac', category: 'Health'),
  const CalculatorItem(title: 'BMI', icon: FontAwesomeIcons.weightScale, route: '/health/bmi', category: 'Health'),
  const CalculatorItem(title: 'BMR', icon: FontAwesomeIcons.fire, route: '/health/bmr', category: 'Health'),
  const CalculatorItem(title: 'Body Fat', icon: FontAwesomeIcons.person, route: '/health/bodyfat', category: 'Health'),
  const CalculatorItem(title: 'Calories', icon: FontAwesomeIcons.utensils, route: '/health/calories', category: 'Health'),
  const CalculatorItem(title: 'Child Height', icon: FontAwesomeIcons.child, route: '/health/childheight', category: 'Health'),
  const CalculatorItem(title: 'Ideal Weight', icon: FontAwesomeIcons.weightScale, route: '/health/idealweight', category: 'Health'),
  const CalculatorItem(title: 'One Rep Max', icon: FontAwesomeIcons.dumbbell, route: '/health/onerepmax', category: 'Health'),
  const CalculatorItem(title: 'Ovulation', icon: FontAwesomeIcons.calendarCheck, route: '/health/ovulation', category: 'Health'),
  const CalculatorItem(title: 'Pace', icon: FontAwesomeIcons.personRunning, route: '/health/pace', category: 'Health'),
  const CalculatorItem(title: 'Pregnancy Due Date', icon: FontAwesomeIcons.baby, route: '/health/duedate', category: 'Health'),
  const CalculatorItem(title: 'Protein Intake', icon: FontAwesomeIcons.drumstickBite, route: '/health/protein', category: 'Health'),
  const CalculatorItem(title: 'Sleep Calculator', icon: FontAwesomeIcons.bed, route: '/health/sleep', category: 'Health'),
  const CalculatorItem(title: 'Target Heart Rate', icon: FontAwesomeIcons.heartPulse, route: '/health/heartrate', category: 'Health'),
  const CalculatorItem(title: 'Water Intake', icon: FontAwesomeIcons.glassWater, route: '/health/water', category: 'Health'),

  // Math
  const CalculatorItem(title: 'Aspect Ratio', icon: FontAwesomeIcons.expand, route: '/math/aspectratio', category: 'Math'),
  const CalculatorItem(title: 'Binary Converter', icon: FontAwesomeIcons.zero, route: '/math/binary', category: 'Math'),
  const CalculatorItem(title: 'Factorial', icon: FontAwesomeIcons.exclamation, route: '/math/factorial', category: 'Math'),
  const CalculatorItem(title: 'Fibonacci', icon: FontAwesomeIcons.arrowUpRightDots, route: '/math/fibonacci', category: 'Math'),
  const CalculatorItem(title: 'GCD / LCM', icon: FontAwesomeIcons.calculator, route: '/math/gcdlcm', category: 'Math'),
  const CalculatorItem(title: 'Geometry', icon: FontAwesomeIcons.shapes, route: '/math/geometry', category: 'Math'),
  const CalculatorItem(title: 'Hex Converter', icon: FontAwesomeIcons.f, route: '/math/hex', category: 'Math'),
  const CalculatorItem(title: 'Matrix Determinant', icon: FontAwesomeIcons.tableCells, route: '/math/matrix', category: 'Math'),
  const CalculatorItem(title: 'Percentage', icon: FontAwesomeIcons.percent, route: '/math/percentage', category: 'Math'),
  const CalculatorItem(title: 'Permutation & Comb', icon: FontAwesomeIcons.arrowDownUpAcrossLine, route: '/math/permcomb', category: 'Math'),
  const CalculatorItem(title: 'Prime Factorization', icon: FontAwesomeIcons.hashtag, route: '/math/prime', category: 'Math'),
  const CalculatorItem(title: 'Quadratic Solver', icon: FontAwesomeIcons.xmarksLines, route: '/math/quadratic', category: 'Math'),
  const CalculatorItem(title: 'Random Number', icon: FontAwesomeIcons.shuffle, route: '/math/random', category: 'Math'),
  const CalculatorItem(title: 'Roman Numerals', icon: FontAwesomeIcons.iCursor, route: '/math/roman', category: 'Math'),
  const CalculatorItem(title: 'Standard Deviation', icon: FontAwesomeIcons.chartBar, route: '/math/stddev', category: 'Math'),
  const CalculatorItem(title: 'Surface Area', icon: FontAwesomeIcons.layerGroup, route: '/math/surfacearea', category: 'Math'),
  const CalculatorItem(title: 'Volume', icon: FontAwesomeIcons.cube, route: '/math/volume', category: 'Math'),

  // Electronics
  const CalculatorItem(title: 'Battery Life', icon: FontAwesomeIcons.batteryFull, route: '/electronics/battery', category: 'Electronics'),
  const CalculatorItem(title: 'Ohm\'s Law', icon: FontAwesomeIcons.bolt, route: '/electronics/ohms', category: 'Electronics'),
  const CalculatorItem(title: 'Resistor Color Code', icon: FontAwesomeIcons.palette, route: '/electronics/resistor', category: 'Electronics'),
  const CalculatorItem(title: 'Voltage Divider', icon: FontAwesomeIcons.plug, route: '/electronics/voltage', category: 'Electronics'),

  // Converters
  const CalculatorItem(title: 'Angle', icon: FontAwesomeIcons.compass, route: '/converters/angle', category: 'Converters'),
  const CalculatorItem(title: 'Area', icon: FontAwesomeIcons.vectorSquare, route: '/converters/area', category: 'Converters'),
  const CalculatorItem(title: 'Cooking', icon: FontAwesomeIcons.utensils, route: '/converters/cooking', category: 'Converters'),
  const CalculatorItem(title: 'Data Storage', icon: FontAwesomeIcons.hardDrive, route: '/converters/storage', category: 'Converters'),
  const CalculatorItem(title: 'Fuel Consumption', icon: FontAwesomeIcons.gasPump, route: '/converters/fuelconsumption', category: 'Converters'),
  const CalculatorItem(title: 'Power', icon: FontAwesomeIcons.bolt, route: '/converters/power', category: 'Converters'),
  const CalculatorItem(title: 'Pressure', icon: FontAwesomeIcons.gauge, route: '/converters/pressure', category: 'Converters'),
  const CalculatorItem(title: 'Speed', icon: FontAwesomeIcons.gaugeHigh, route: '/converters/speed', category: 'Converters'),
  const CalculatorItem(title: 'Torque', icon: FontAwesomeIcons.wrench, route: '/converters/torque', category: 'Converters'),
  const CalculatorItem(title: 'Unit Converter', icon: FontAwesomeIcons.rightLeft, route: '/converters/unit', category: 'Converters'),

  // Photography
  const CalculatorItem(title: 'Depth of Field', icon: FontAwesomeIcons.camera, route: '/lifestyle/dof', category: 'Lifestyle'),
  const CalculatorItem(title: 'Exposure Value', icon: FontAwesomeIcons.sun, route: '/lifestyle/ev', category: 'Lifestyle'),

  // Physics / Science
  const CalculatorItem(title: 'Acceleration', icon: FontAwesomeIcons.gaugeHigh, route: '/science/acceleration', category: 'Science'),
  const CalculatorItem(title: 'Density', icon: FontAwesomeIcons.cubes, route: '/science/density', category: 'Science'),
  const CalculatorItem(title: 'Force', icon: FontAwesomeIcons.weightHanging, route: '/science/force', category: 'Science'),
  const CalculatorItem(title: 'Kinetic Energy', icon: FontAwesomeIcons.personRunning, route: '/science/kinetic', category: 'Science'),
  const CalculatorItem(title: 'Power', icon: FontAwesomeIcons.bolt, route: '/science/power', category: 'Science'),
  const CalculatorItem(title: 'Projectile Motion', icon: FontAwesomeIcons.share, route: '/science/projectile', category: 'Science'),

  // Chemistry
  const CalculatorItem(title: 'Dilution', icon: FontAwesomeIcons.flask, route: '/science/dilution', category: 'Science'),
  const CalculatorItem(title: 'Ideal Gas Law', icon: FontAwesomeIcons.cloud, route: '/science/idealgas', category: 'Science'),

  // Gardening
  const CalculatorItem(title: 'Plant Spacing', icon: FontAwesomeIcons.rulerHorizontal, route: '/lifestyle/spacing', category: 'Lifestyle'),
  const CalculatorItem(title: 'Soil / Mulch', icon: FontAwesomeIcons.trowel, route: '/lifestyle/soil', category: 'Lifestyle'),

  // Sports / Lifestyle
  const CalculatorItem(title: 'Pizza Party', icon: FontAwesomeIcons.pizzaSlice, route: '/lifestyle/pizza', category: 'Lifestyle'),
  const CalculatorItem(title: 'Cricket Run Rate', icon: FontAwesomeIcons.baseballBatBall, route: '/lifestyle/cricket', category: 'Lifestyle'),
  const CalculatorItem(title: 'Tennis Score', icon: FontAwesomeIcons.tableTennisPaddleBall, route: '/lifestyle/tennis', category: 'Lifestyle'),

  // Text Tools
  const CalculatorItem(title: 'Base64 Converter', icon: FontAwesomeIcons.code, route: '/text/base64', category: 'Text Tools'),
  const CalculatorItem(title: 'Case Converter', icon: FontAwesomeIcons.font, route: '/text/case', category: 'Text Tools'),
  const CalculatorItem(title: 'Lorem Ipsum', icon: FontAwesomeIcons.paragraph, route: '/text/lorem', category: 'Text Tools'),
  const CalculatorItem(title: 'Reverse Text', icon: FontAwesomeIcons.leftRight, route: '/text/reverse', category: 'Text Tools'),
  const CalculatorItem(title: 'Word Count', icon: FontAwesomeIcons.alignLeft, route: '/text/wordcount', category: 'Text Tools'),

  // Other
  const CalculatorItem(title: 'Age', icon: FontAwesomeIcons.cakeCandles, route: '/other/age', category: 'Other'),
  const CalculatorItem(title: 'Construction', icon: FontAwesomeIcons.trowel, route: '/other/construction', category: 'Other'),
  const CalculatorItem(title: 'Date Calculator', icon: FontAwesomeIcons.calendarDays, route: '/other/date', category: 'Other'),
  const CalculatorItem(title: 'Flooring', icon: FontAwesomeIcons.rug, route: '/other/flooring', category: 'Other'),
  const CalculatorItem(title: 'Fuel Cost', icon: FontAwesomeIcons.gasPump, route: '/other/fuel', category: 'Other'),
  const CalculatorItem(title: 'GPA Calculator', icon: FontAwesomeIcons.graduationCap, route: '/other/gpa', category: 'Other'),
  const CalculatorItem(title: 'Grade Calculator', icon: FontAwesomeIcons.a, route: '/other/grade', category: 'Other'),
  const CalculatorItem(title: 'IP Subnet', icon: FontAwesomeIcons.networkWired, route: '/other/ipsubnet', category: 'Other'),
  const CalculatorItem(title: 'Password Gen', icon: FontAwesomeIcons.key, route: '/other/password', category: 'Other'),
  const CalculatorItem(title: 'Time Calculator', icon: FontAwesomeIcons.clock, route: '/other/time', category: 'Other'),
  const CalculatorItem(title: 'TV Size', icon: FontAwesomeIcons.tv, route: '/other/tvsize', category: 'Other'),
  const CalculatorItem(title: 'Work Hours', icon: FontAwesomeIcons.briefcase, route: '/other/workhours', category: 'Other'),
  // Finance
  const CalculatorItem(title: 'Stock Profit', icon: FontAwesomeIcons.arrowTrendUp, route: '/finance/stock', category: 'Finance'),
  const CalculatorItem(title: 'Commission', icon: FontAwesomeIcons.handHoldingDollar, route: '/finance/commission', category: 'Finance'),
  const CalculatorItem(title: 'Debt Snowball', icon: FontAwesomeIcons.snowflake, route: '/finance/debtsnowball', category: 'Finance'),

  // Math
  const CalculatorItem(title: 'Circle Properties', icon: FontAwesomeIcons.circle, route: '/math/circle', category: 'Math'),
  const CalculatorItem(title: 'Slope', icon: FontAwesomeIcons.arrowTrendUp, route: '/math/slope', category: 'Math'),
  const CalculatorItem(title: 'Fraction', icon: FontAwesomeIcons.divide, route: '/math/fraction', category: 'Math'),

  // Electronics
  const CalculatorItem(title: 'LED Resistor', icon: FontAwesomeIcons.lightbulb, route: '/electronics/led', category: 'Electronics'),
  const CalculatorItem(title: 'Capacitor Energy', icon: FontAwesomeIcons.bolt, route: '/electronics/capacitor', category: 'Electronics'),

  // Text Tools
  const CalculatorItem(title: 'JSON Formatter', icon: FontAwesomeIcons.fileCode, route: '/text/json', category: 'Text Tools'),

  // Health
  const CalculatorItem(title: 'Smoking Cost', icon: FontAwesomeIcons.banSmoking, route: '/health/smoking', category: 'Health'),
  const CalculatorItem(title: 'Macro', icon: FontAwesomeIcons.utensils, route: '/health/macro', category: 'Health'),

  // Converters
  const CalculatorItem(title: 'Shoe Size', icon: FontAwesomeIcons.shoePrints, route: '/converters/shoesize', category: 'Converters'),
];
