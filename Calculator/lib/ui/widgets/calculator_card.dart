import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../core/pinned_provider.dart';
import '../../features/custom_calculator/data/calculator_templates.dart';
import '../../features/custom_calculator/models/custom_calculator_model.dart';

class CalculatorCard extends ConsumerWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String? route;

  const CalculatorCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.route,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPinned = route != null && ref.watch(pinnedCalculatorsProvider).contains(route);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final template = route != null ? CalculatorTemplates.getTemplateForRoute(route!) : null;

    return Card(
      elevation: 4,
      shadowColor: color.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: color.withOpacity(0.1),
        highlightColor: color.withOpacity(0.05),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          theme.cardColor,
                          theme.cardColor.withOpacity(0.8),
                        ]
                      : [
                          Colors.white,
                          Colors.grey.shade50,
                        ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: FaIcon(icon, size: 28, color: color),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 42,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (route != null)
              Positioned(
                top: 8,
                right: 8,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (template != null)
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            // Fork logic
                            final copy = CustomCalculator(
                              id: const Uuid().v4(),
                              title: '${template.title} (Custom)',
                              iconCode: template.iconCode,
                              iconFontFamily: template.iconFontFamily,
                              iconFontPackage: template.iconFontPackage,
                              inputs: List.from(template.inputs),
                              formula: template.formula,
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                            );
                            context.push('/custom/builder', extra: copy);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.edit,
                              color: theme.disabledColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          ref.read(pinnedCalculatorsProvider.notifier).togglePin(route!);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                            color: isPinned ? color : theme.disabledColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
