import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final pinnedCalculatorsProvider = StateNotifierProvider<PinnedCalculatorsNotifier, List<String>>((ref) {
  return PinnedCalculatorsNotifier();
});

class PinnedCalculatorsNotifier extends StateNotifier<List<String>> {
  PinnedCalculatorsNotifier() : super([]) {
    _loadPinned();
  }

  Future<void> _loadPinned() async {
    final prefs = await SharedPreferences.getInstance();
    final pinned = prefs.getStringList('pinned_calculators') ?? [];
    state = pinned;
  }

  Future<void> togglePin(String route) async {
    final prefs = await SharedPreferences.getInstance();
    if (state.contains(route)) {
      state = state.where((r) => r != route).toList();
    } else {
      state = [...state, route];
    }
    await prefs.setStringList('pinned_calculators', state);
  }

  bool isPinned(String route) {
    return state.contains(route);
  }
}
