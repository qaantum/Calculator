import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/pinned_provider.dart';

class PinButton extends ConsumerWidget {
  final String route;

  const PinButton({super.key, required this.route});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPinned = ref.watch(pinnedCalculatorsProvider).contains(route);

    return IconButton(
      icon: Icon(
        isPinned ? Icons.push_pin : Icons.push_pin_outlined,
        color: isPinned ? Colors.amber : null,
      ),
      onPressed: () {
        ref.read(pinnedCalculatorsProvider.notifier).togglePin(route);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isPinned ? 'Unpinned from Dashboard' : 'Pinned to Dashboard'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }
}
