import 'package:flutter/foundation.dart';

class ThemeService with ChangeNotifier {

  bool _darkTheme = true;

  set darkTheme(bool value) { 
    _darkTheme = value;
    notifyListeners();
  }

  bool get darkTheme => _darkTheme;


}