import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management_app/services/preferance_service.dart';

final preferencesViewModelProvider =
    StateNotifierProvider<PreferencesViewModel, PreferencesService>((ref) {
  return PreferencesViewModel();
});

class PreferencesViewModel extends StateNotifier<PreferencesService> {
  PreferencesViewModel() : super(PreferencesService());

  void toggleTheme(bool isDarkMode) {
    state.isDarkMode = isDarkMode;
  }

  void setSortOrder(String sortOrder) {
    state.sortOrder = sortOrder;
  }
}
