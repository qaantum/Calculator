import 'package:flutter/material.dart';

enum VariableType { number, integer }

class CalculatorVariable {
  final String name;
  final String defaultValue;
  final String? description;
  final String? unitLabel;
  final double? min;
  final double? max;
  final VariableType type;

  CalculatorVariable({
    required this.name,
    this.defaultValue = '0',
    this.description,
    this.unitLabel,
    this.min,
    this.max,
    this.type = VariableType.number,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'defaultValue': defaultValue,
    'description': description,
    'unitLabel': unitLabel,
    'min': min,
    'max': max,
    'type': type.index,
  };

  factory CalculatorVariable.fromJson(Map<String, dynamic> json) {
    return CalculatorVariable(
      name: json['name'],
      defaultValue: json['defaultValue'] ?? '0',
      description: json['description'],
      unitLabel: json['unitLabel'],
      min: json['min'],
      max: json['max'],
      type: VariableType.values[json['type'] ?? 0],
    );
  }
}

class CustomCalculator {
  final String id;
  final String title;
  final int iconCode;
  final String? iconFontFamily;
  final String? iconFontPackage;
  final List<CalculatorVariable> inputs;
  final String formula;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool pinned;
  final int version;

  CustomCalculator({
    required this.id,
    required this.title,
    required this.iconCode,
    this.iconFontFamily,
    this.iconFontPackage,
    required this.inputs,
    required this.formula,
    required this.createdAt,
    required this.updatedAt,
    this.pinned = false,
    this.version = 1,
  });

  IconData get icon => IconData(
        iconCode,
        fontFamily: iconFontFamily,
        fontPackage: iconFontPackage,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'iconCode': iconCode,
    'iconFontFamily': iconFontFamily,
    'iconFontPackage': iconFontPackage,
    'inputs': inputs.map((e) => e.toJson()).toList(),
    'formula': formula,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'pinned': pinned,
    'version': version,
  };

  factory CustomCalculator.fromJson(Map<String, dynamic> json) {
    return CustomCalculator(
      id: json['id'],
      title: json['title'],
      iconCode: json['iconCode'],
      iconFontFamily: json['iconFontFamily'],
      iconFontPackage: json['iconFontPackage'],
      inputs: (json['inputs'] as List).map((e) => CalculatorVariable.fromJson(e)).toList(),
      formula: json['formula'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      pinned: json['pinned'] ?? false,
      version: json['version'] ?? 1,
    );
  }
}
