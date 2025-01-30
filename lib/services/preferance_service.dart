import 'package:hive/hive.dart';

class PreferencesService {
  static const _preferencesBox = 'preferencesBox';

  Future<void> init() async {
    await Hive.openBox(_preferencesBox);
  }

  bool get isDarkMode {
    return Hive.box(_preferencesBox).get('isDarkMode', defaultValue: false);
  }

  set isDarkMode(bool value) {
    Hive.box(_preferencesBox).put('isDarkMode', value);
  }

  String get sortOrder {
    return Hive.box(_preferencesBox).get('sortOrder', defaultValue: 'date');
  }

  set sortOrder(String value) {
    Hive.box(_preferencesBox).put('sortOrder', value);
  }
}
