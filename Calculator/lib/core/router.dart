import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/more_screen.dart';
import '../ui/screens/settings_screen.dart';

import '../ui/screens/finance_screen.dart';
import '../features/finance/mortgage_calculator.dart';
import '../features/finance/loan_calculator.dart';
import '../features/finance/currency_converter.dart';
import '../features/finance/auto_loan_calculator.dart';
import '../features/finance/simple_interest_calculator.dart';
import '../features/finance/compound_interest_calculator.dart';
import '../features/finance/savings_goal_calculator.dart';
import '../features/finance/retirement_calculator.dart';
import '../features/finance/salary_calculator.dart';
import '../features/finance/tax_calculator.dart';
import '../ui/screens/health_screen.dart';
import '../features/health/bmi_calculator.dart';
import '../features/health/bmr_calculator.dart';
import '../features/health/body_fat_calculator.dart';
import '../features/health/calories_calculator.dart';
import '../features/health/ideal_weight_calculator.dart';
import '../features/health/pace_calculator.dart';
import '../features/health/due_date_calculator.dart';
import '../ui/screens/math_screen.dart';
import '../features/math/percentage_calculator.dart';
import '../features/math/random_number_generator.dart';
import '../features/math/standard_deviation_calculator.dart';
import '../ui/screens/other_screen.dart';
import '../features/other/age_calculator.dart';
import '../features/other/date_calculator.dart';
import '../features/other/time_calculator.dart';
import '../features/other/work_hours_calculator.dart';
import '../features/other/gpa_calculator.dart';
import '../features/other/grade_calculator.dart';
import '../features/other/password_generator.dart';
import '../features/other/unit_converter.dart';

import '../features/finance/inflation_calculator.dart';
import '../features/finance/sales_tax_calculator.dart';

import '../features/finance/tip_calculator.dart';
import '../features/finance/discount_calculator.dart';
import '../features/finance/roi_calculator.dart';
import '../features/finance/amortization_schedule.dart';
import '../features/other/fuel_cost_calculator.dart';
import '../features/math/aspect_ratio_calculator.dart';

import '../features/finance/investment_growth_calculator.dart';
import '../features/other/cooking_converter.dart';
import '../features/other/construction_calculator.dart';

import '../features/finance/unit_price_calculator.dart';
import '../features/finance/electricity_cost_calculator.dart';
import '../features/health/one_rep_max_calculator.dart';

import '../features/math/standard_calculator.dart';
import '../features/math/scientific_calculator.dart';

import '../features/finance/cagr_calculator.dart';
import '../features/finance/margin_markup_calculator.dart';
import '../features/health/water_intake_calculator.dart';
import '../features/other/tv_size_calculator.dart';
import '../features/other/ip_subnet_calculator.dart';

import '../features/finance/break_even_calculator.dart';
import '../features/health/target_heart_rate_calculator.dart';
import '../features/math/geometry_calculator.dart';
import '../features/electronics/ohms_law_calculator.dart';
import '../features/electronics/voltage_divider_calculator.dart';
import '../features/electronics/battery_life_calculator.dart';
import '../ui/screens/electronics_screen.dart';

import '../features/finance/rule_of_72_calculator.dart';
import '../features/math/gcd_lcm_calculator.dart';
import '../features/converters/data_storage_converter.dart';
import '../features/converters/fuel_consumption_converter.dart';
import '../features/photography/dof_calculator.dart';
import '../features/photography/ev_calculator.dart';
import '../features/physics/force_calculator.dart';
import '../features/physics/kinetic_energy_calculator.dart';

import '../ui/screens/converters_screen.dart';
import '../ui/screens/science_screen.dart';
import '../ui/screens/lifestyle_screen.dart';

import '../features/finance/net_worth_calculator.dart';
import '../features/health/bac_calculator.dart';
import '../features/math/prime_factorization_calculator.dart';
import '../features/math/permutation_combination_calculator.dart';
import '../features/converters/torque_converter.dart';
import '../features/converters/pressure_converter.dart';
import '../features/converters/speed_converter.dart';
import '../features/chemistry/dilution_calculator.dart';
import '../features/chemistry/ideal_gas_law_calculator.dart';

import '../features/chemistry/ideal_gas_law_calculator.dart';

import '../features/gardening/soil_mulch_calculator.dart';
import '../features/gardening/plant_spacing_calculator.dart';
import '../features/math/quadratic_solver.dart';
import '../features/math/matrix_determinant_calculator.dart';
import '../features/physics/projectile_motion_calculator.dart';
import '../features/physics/power_calculator.dart';
import '../features/converters/area_converter.dart';
import '../features/converters/power_unit_converter.dart';
import '../features/converters/angle_converter.dart';
import '../features/finance/credit_card_payoff_calculator.dart';

import '../features/finance/credit_card_payoff_calculator.dart';


import '../features/math/binary_converter.dart';


import '../features/text/word_count_calculator.dart';
import '../features/text/case_converter.dart';
import '../features/health/ovulation_calculator.dart';
import '../features/finance/tvm_calculator.dart';

import '../ui/screens/text_tools_screen.dart';

import '../features/other/flooring_calculator.dart';
import '../features/finance/rental_property_calculator.dart';

import '../features/math/roman_numeral_converter.dart';

import '../features/electronics/resistor_color_code_calculator.dart';
import '../features/text/base64_converter.dart';
import '../features/math/fibonacci_generator.dart';
import '../features/health/child_height_predictor.dart';

import '../ui/screens/dashboard_screen.dart';

import '../features/finance/stock_profit_calculator.dart';
import '../features/electronics/led_resistor_calculator.dart';
import '../features/math/circle_properties_calculator.dart';
import '../features/text/json_formatter.dart';

import '../features/finance/commission_calculator.dart';
import '../features/math/slope_calculator.dart';
import '../features/health/smoking_cost_calculator.dart';
import '../features/converters/shoe_size_converter.dart';
import '../features/finance/debt_snowball_calculator.dart';
import '../features/math/fraction_calculator.dart';
import '../features/health/macro_calculator.dart';
import '../features/electronics/capacitor_energy_calculator.dart';
import '../features/finance/loan_affordability_calculator.dart';
import '../features/finance/refinance_calculator.dart';
import '../features/health/sleep_calculator.dart';
import '../features/health/protein_intake_calculator.dart';
import '../features/math/volume_calculator.dart';
import '../features/math/surface_area_calculator.dart';
import '../features/math/factorial_calculator.dart';
import '../features/science/density_calculator.dart';
import '../features/science/acceleration_calculator.dart';

// NEW CALCULATORS
import '../features/other/timestamp_converter.dart';
import '../features/other/countdown_calculator.dart';
import '../features/other/birthday_calculator.dart';
import '../features/other/driving_time_calculator.dart';
import '../features/health/pet_age_calculator.dart';
import '../features/health/caffeine_calculator.dart';
import '../features/other/paint_calculator.dart';
import '../features/other/concrete_calculator.dart';
import '../features/other/tile_calculator.dart';

import '../features/custom_calculator/screens/custom_calculator_builder_screen.dart';
import '../features/custom_calculator/screens/custom_calculator_detail_screen.dart';
import '../features/custom_calculator/models/custom_calculator_model.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dashboard',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return HomeScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/more',
          builder: (context, state) => const MoreScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/standard',
          builder: (context, state) => const StandardCalculator(),
        ),
        GoRoute(
          path: '/scientific',
          builder: (context, state) => const ScientificCalculator(),
        ),
        GoRoute(
          path: '/finance',
          builder: (context, state) => const FinanceScreen(),
          routes: [
            GoRoute(
              path: 'mortgage',
              builder: (context, state) => const MortgageCalculator(),
            ),
            GoRoute(
              path: 'loan',
              builder: (context, state) => const LoanCalculator(),
            ),
            GoRoute(
              path: 'currency',
              builder: (context, state) => const CurrencyConverter(),
            ),
            GoRoute(
              path: 'car',
              builder: (context, state) => const AutoLoanCalculator(),
            ),
            GoRoute(
              path: 'interest',
              builder: (context, state) => const SimpleInterestCalculator(),
              routes: [
                GoRoute(
                  path: 'compound',
                  builder: (context, state) => const CompoundInterestCalculator(),
                ),
              ],
            ),
            GoRoute(
              path: 'savings',
              builder: (context, state) => const SavingsGoalCalculator(),
            ),
            GoRoute(
              path: 'retirement',
              builder: (context, state) => const RetirementCalculator(),
            ),
            GoRoute(
              path: 'salary',
              builder: (context, state) => const SalaryCalculator(),
            ),
            GoRoute(
              path: 'tax',
              builder: (context, state) => const TaxCalculator(),
            ),
            GoRoute(
              path: 'inflation',
              builder: (context, state) => const InflationCalculator(),
            ),
            GoRoute(
              path: 'salestax',
              builder: (context, state) => const SalesTaxCalculator(),
            ),

            GoRoute(
              path: 'tip',
              builder: (context, state) => const TipCalculator(),
            ),
            GoRoute(
              path: 'discount',
              builder: (context, state) => const DiscountCalculator(),
            ),
            GoRoute(
              path: 'roi',
              builder: (context, state) => const RoiCalculator(),
            ),
            GoRoute(
              path: 'amortization',
              builder: (context, state) => const AmortizationSchedule(),
            ),
            GoRoute(
              path: 'investment',
              builder: (context, state) => const InvestmentGrowthCalculator(),
            ),
            GoRoute(
              path: 'unitprice',
              builder: (context, state) => const UnitPriceCalculator(),
            ),
            GoRoute(
              path: 'electricity',
              builder: (context, state) => const ElectricityCostCalculator(),
            ),
            GoRoute(
              path: 'cagr',
              builder: (context, state) => const CAGRCalculator(),
            ),
            GoRoute(
              path: 'margin',
              builder: (context, state) => const MarginMarkupCalculator(),
            ),
            GoRoute(
              path: 'breakeven',
              builder: (context, state) => const BreakEvenCalculator(),
            ),
            GoRoute(
              path: 'rule72',
              builder: (context, state) => const RuleOf72Calculator(),
            ),
            GoRoute(
              path: 'networth',
              builder: (context, state) => const NetWorthCalculator(),
            ),
            GoRoute(
              path: 'creditcard',
              builder: (context, state) => const CreditCardPayoffCalculator(),
            ),
            GoRoute(
              path: 'tvm',
              builder: (context, state) => const TVMCalculator(),
            ),
            GoRoute(
              path: 'rental',
              builder: (context, state) => const RentalPropertyCalculator(),
            ),
            GoRoute(
              path: 'stock',
              builder: (context, state) => const StockProfitCalculator(),
            ),
            GoRoute(
              path: 'commission',
              builder: (context, state) => const CommissionCalculator(),
            ),
            GoRoute(
              path: 'debtsnowball',
              builder: (context, state) => const DebtSnowballCalculator(),
            ),
            GoRoute(
              path: 'debtsnowball',
              builder: (context, state) => const DebtSnowballCalculator(),
            ),
            GoRoute(
              path: 'affordability',
              builder: (context, state) => const LoanAffordabilityCalculator(),
            ),
            GoRoute(
              path: 'refinance',
              builder: (context, state) => const RefinanceCalculator(),
            ),
          ],
        ),
        GoRoute(
          path: '/health',
          builder: (context, state) => const HealthScreen(),
          routes: [
            GoRoute(
              path: 'bmi',
              builder: (context, state) => const BMICalculator(),
            ),
            GoRoute(
              path: 'bmr',
              builder: (context, state) => const BMRCalculator(),
            ),
            GoRoute(
              path: 'bodyfat',
              builder: (context, state) => const BodyFatCalculator(),
            ),
            GoRoute(
              path: 'calories',
              builder: (context, state) => const CaloriesCalculator(),
            ),
            GoRoute(
              path: 'idealweight',
              builder: (context, state) => const IdealWeightCalculator(),
            ),
            GoRoute(
              path: 'pace',
              builder: (context, state) => const PaceCalculator(),
            ),
            GoRoute(
              path: 'duedate',
              builder: (context, state) => const DueDateCalculator(),
            ),
            GoRoute(
              path: 'onerepmax',
              builder: (context, state) => const OneRepMaxCalculator(),
            ),
            GoRoute(
              path: 'water',
              builder: (context, state) => const WaterIntakeCalculator(),
            ),
            GoRoute(
              path: 'heartrate',
              builder: (context, state) => const TargetHeartRateCalculator(),
            ),
            GoRoute(
              path: 'bac',
              builder: (context, state) => const BacCalculator(),
            ),
            GoRoute(
              path: 'ovulation',
              builder: (context, state) => const OvulationCalculator(),
            ),
            GoRoute(
              path: 'childheight',
              builder: (context, state) => const ChildHeightPredictor(),
            ),
            GoRoute(
              path: 'smoking',
              builder: (context, state) => const SmokingCostCalculator(),
            ),
            GoRoute(
              path: 'macro',
              builder: (context, state) => const MacroCalculator(),
            ),
            GoRoute(
              path: 'macro',
              builder: (context, state) => const MacroCalculator(),
            ),
            GoRoute(
              path: 'sleep',
              builder: (context, state) => const SleepCalculator(),
            ),
            GoRoute(
              path: 'protein',
              builder: (context, state) => const ProteinIntakeCalculator(),
            ),
            GoRoute(
              path: 'petage',
              builder: (context, state) => const PetAgeCalculator(),
            ),
            GoRoute(
              path: 'caffeine',
              builder: (context, state) => const CaffeineCalculator(),
            ),
          ],
        ),
        GoRoute(
          path: '/math',
          builder: (context, state) => const MathScreen(),
          routes: [
            GoRoute(
              path: 'percentage',
              builder: (context, state) => const PercentageCalculator(),
            ),
            GoRoute(
              path: 'random',
              builder: (context, state) => const RandomNumberGenerator(),
            ),
            GoRoute(
              path: 'stddev',
              builder: (context, state) => const StandardDeviationCalculator(),
            ),
            GoRoute(
              path: 'aspectratio',
              builder: (context, state) => const AspectRatioCalculator(),
            ),
            GoRoute(
              path: 'geometry',
              builder: (context, state) => const GeometryCalculator(),
            ),
            GoRoute(
              path: 'gcdlcm',
              builder: (context, state) => const GcdLcmCalculator(),
            ),
            GoRoute(
              path: 'prime',
              builder: (context, state) => const PrimeFactorizationCalculator(),
            ),
            GoRoute(
              path: 'permcomb',
              builder: (context, state) => const PermutationCombinationCalculator(),
            ),
            GoRoute(
              path: 'quadratic',
              builder: (context, state) => const QuadraticSolver(),
            ),
            GoRoute(
              path: 'matrix',
              builder: (context, state) => const MatrixDeterminantCalculator(),
            ),
            GoRoute(
              path: 'binary',
              builder: (context, state) => const BinaryConverter(),
            ),

            GoRoute(
              path: 'roman',
              builder: (context, state) => const RomanNumeralConverter(),
            ),
            GoRoute(
              path: 'fibonacci',
              builder: (context, state) => const FibonacciGenerator(),
            ),
            GoRoute(
              path: 'circle',
              builder: (context, state) => const CirclePropertiesCalculator(),
            ),
            GoRoute(
              path: 'slope',
              builder: (context, state) => const SlopeCalculator(),
            ),
            GoRoute(
              path: 'fraction',
              builder: (context, state) => const FractionCalculator(),
            ),
            GoRoute(
              path: 'fraction',
              builder: (context, state) => const FractionCalculator(),
            ),
            GoRoute(
              path: 'volume',
              builder: (context, state) => const VolumeCalculator(),
            ),
            GoRoute(
              path: 'surfacearea',
              builder: (context, state) => const SurfaceAreaCalculator(),
            ),
            GoRoute(
              path: 'factorial',
              builder: (context, state) => const FactorialCalculator(),
            ),
          ],
        ),
        GoRoute(
          path: '/electronics',
          builder: (context, state) => const ElectronicsScreen(),
          routes: [
            GoRoute(
              path: 'ohms',
              builder: (context, state) => const OhmsLawCalculator(),
            ),
            GoRoute(
              path: 'voltage',
              builder: (context, state) => const VoltageDividerCalculator(),
            ),
            GoRoute(
              path: 'battery',
              builder: (context, state) => const BatteryLifeCalculator(),
            ),
            GoRoute(
              path: 'resistor',
              builder: (context, state) => const ResistorColorCodeCalculator(),
            ),
            GoRoute(
              path: 'led',
              builder: (context, state) => const LedResistorCalculator(),
            ),
            GoRoute(
              path: 'capacitor',
              builder: (context, state) => const CapacitorEnergyCalculator(),
            ),
          ],
        ),
        GoRoute(
          path: '/converters',
          builder: (context, state) => const ConvertersScreen(),
          routes: [
            GoRoute(
              path: 'unit',
              builder: (context, state) => const UnitConverter(),
            ),
            GoRoute(
              path: 'cooking',
              builder: (context, state) => const CookingConverter(),
            ),
            GoRoute(
              path: 'storage',
              builder: (context, state) => const DataStorageConverter(),
            ),
            GoRoute(
              path: 'fuelconsumption',
              builder: (context, state) => const FuelConsumptionConverter(),
            ),
            GoRoute(
              path: 'torque',
              builder: (context, state) => const TorqueConverter(),
            ),
            GoRoute(
              path: 'pressure',
              builder: (context, state) => const PressureConverter(),
            ),
            GoRoute(
              path: 'speed',
              builder: (context, state) => const SpeedConverter(),
            ),
            GoRoute(
              path: 'area',
              builder: (context, state) => const AreaConverter(),
            ),
            GoRoute(
              path: 'power',
              builder: (context, state) => const PowerUnitConverter(),
            ),
            GoRoute(
              path: 'angle',
              builder: (context, state) => const AngleConverter(),
            ),
            GoRoute(
              path: 'shoesize',
              builder: (context, state) => const ShoeSizeConverter(),
            ),
          ],
        ),
        GoRoute(
          path: '/science',
          builder: (context, state) => const ScienceScreen(),
          routes: [
            GoRoute(
              path: 'force',
              builder: (context, state) => const ForceCalculator(),
            ),
            GoRoute(
              path: 'kinetic',
              builder: (context, state) => const KineticEnergyCalculator(),
            ),
            GoRoute(
              path: 'projectile',
              builder: (context, state) => const ProjectileMotionCalculator(),
            ),
            GoRoute(
              path: 'power',
              builder: (context, state) => const PowerCalculator(),
            ),
            GoRoute(
              path: 'power',
              builder: (context, state) => const PowerCalculator(),
            ),
            GoRoute(
              path: 'density',
              builder: (context, state) => const DensityCalculator(),
            ),
            GoRoute(
              path: 'acceleration',
              builder: (context, state) => const AccelerationCalculator(),
            ),
            GoRoute(
              path: 'dilution',
              builder: (context, state) => const DilutionCalculator(),
            ),
            GoRoute(
              path: 'idealgas',
              builder: (context, state) => const IdealGasLawCalculator(),
            ),
          ],
        ),
        GoRoute(
          path: '/lifestyle',
          builder: (context, state) => const LifestyleScreen(),
          routes: [
            GoRoute(
              path: 'spacing',
              builder: (context, state) => const PlantSpacingCalculator(),
            ),
            GoRoute(
              path: 'soil',
              builder: (context, state) => const SoilMulchCalculator(),
            ),

            GoRoute(
              path: 'dof',
              builder: (context, state) => const DofCalculator(),
            ),
            GoRoute(
              path: 'ev',
              builder: (context, state) => const EvCalculator(),
            ),

          ],
        ),
        GoRoute(
          path: '/text',
          builder: (context, state) => const TextToolsScreen(),
          routes: [
            GoRoute(
              path: 'wordcount',
              builder: (context, state) => const WordCountCalculator(),
            ),
            GoRoute(
              path: 'case',
              builder: (context, state) => const CaseConverter(),
            ),

            GoRoute(
              path: 'base64',
              builder: (context, state) => const Base64Converter(),
            ),
            GoRoute(
              path: 'json',
              builder: (context, state) => const JsonFormatter(),
            ),

          ],
        ),
        GoRoute(
          path: '/custom/builder',
          builder: (context, state) {
            final calculator = state.extra as CustomCalculator?;
            return CustomCalculatorBuilderScreen(calculator: calculator);
          },
        ),
        GoRoute(
          path: '/custom/detail',
          builder: (context, state) {
            final calculator = state.extra as CustomCalculator?;
            final id = state.uri.queryParameters['id'];
            return CustomCalculatorDetailScreen(calculator: calculator, calculatorId: id);
          },
        ),
        GoRoute(
          path: '/other',
          builder: (context, state) => const OtherScreen(),
          routes: [
            GoRoute(
              path: 'age',
              builder: (context, state) => const AgeCalculator(),
            ),
            GoRoute(
              path: 'date',
              builder: (context, state) => const DateCalculator(),
            ),
            GoRoute(
              path: 'time',
              builder: (context, state) => const TimeCalculator(),
            ),
            GoRoute(
              path: 'workhours',
              builder: (context, state) => const WorkHoursCalculator(),
            ),
            GoRoute(
              path: 'gpa',
              builder: (context, state) => const GPACalculator(),
            ),
            GoRoute(
              path: 'grade',
              builder: (context, state) => const GradeCalculator(),
            ),
            GoRoute(
              path: 'password',
              builder: (context, state) => const PasswordGenerator(),
            ),
            GoRoute(
              path: 'fuel',
              builder: (context, state) => const FuelCostCalculator(),
            ),
            GoRoute(
              path: 'construction',
              builder: (context, state) => const ConstructionCalculator(),
            ),
            GoRoute(
              path: 'tvsize',
              builder: (context, state) => const TVSizeCalculator(),
            ),
            GoRoute(
              path: 'ipsubnet',
              builder: (context, state) => const IPSubnetCalculator(),
            ),
            GoRoute(
              path: 'flooring',
              builder: (context, state) => const FlooringCalculator(),
            ),
            // NEW CALCULATORS
            GoRoute(
              path: 'timestamp',
              builder: (context, state) => const TimestampConverter(),
            ),
            GoRoute(
              path: 'countdown',
              builder: (context, state) => const CountdownCalculator(),
            ),
            GoRoute(
              path: 'birthday',
              builder: (context, state) => const BirthdayCalculator(),
            ),
            GoRoute(
              path: 'drivingtime',
              builder: (context, state) => const DrivingTimeCalculator(),
            ),
            GoRoute(
              path: 'paint',
              builder: (context, state) => const PaintCalculator(),
            ),
            GoRoute(
              path: 'concrete',
              builder: (context, state) => const ConcreteCalculator(),
            ),
            GoRoute(
              path: 'tile',
              builder: (context, state) => const TileCalculator(),
            ),
          ],
        ),
      ],
    ),
  ],
);
