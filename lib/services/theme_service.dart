import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService with ChangeNotifier {

  final SharedPreferences sharedPreferences;
  ThemeService(this.sharedPreferences);

  static const darkThemeKey = "dark_theme";

  bool _darkTheme = true;

  set darkTheme(bool value) { 
    _darkTheme = value;
    sharedPreferences.setBool(darkThemeKey, value);
    notifyListeners();
  }

  bool get darkTheme => sharedPreferences.getBool(darkThemeKey) ?? _darkTheme;
}