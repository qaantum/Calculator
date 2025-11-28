import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/custom_calculator_model.dart';

class CustomCalculatorService {
  static const String _key = 'custom_calculators';

  Future<List<CustomCalculator>> getCalculators() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    final List<CustomCalculator> calculators = [];
    
    for (var e in jsonList) {
      try {
        calculators.add(CustomCalculator.fromJson(e));
      } catch (e) {
        print('Error parsing calculator: $e');
        // Skip invalid items
      }
    }
    return calculators;
  }

  Future<CustomCalculator?> getById(String id) async {
    final list = await getCalculators();
    try {
      return list.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveCalculator(CustomCalculator calculator) async {
    final prefs = await SharedPreferences.getInstance();
    final List<CustomCalculator> current = await getCalculators();
    
    // Check if exists and update, else add
    final index = current.indexWhere((c) => c.id == calculator.id);
    if (index >= 0) {
      current[index] = calculator;
    } else {
      current.add(calculator);
    }

    final String jsonString = jsonEncode(current.map((e) => e.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  Future<void> deleteCalculator(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<CustomCalculator> current = await getCalculators();
    
    current.removeWhere((c) => c.id == id);
    
    final String jsonString = jsonEncode(current.map((e) => e.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }
  Future<Map<String, double>> getLastValues(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('custom_calculator_values_$id');
    if (jsonString == null) return {};
    
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return jsonMap.map((key, value) => MapEntry(key, (value as num).toDouble()));
  }

  Future<void> saveLastValues(String id, Map<String, double> values) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(values);
    await prefs.setString('custom_calculator_values_$id', jsonString);
  }
}
