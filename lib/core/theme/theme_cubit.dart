import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences prefs;
  
  ThemeCubit({required this.prefs}) : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final themeIndex = prefs.getInt('theme_mode');
    if (themeIndex != null) {
      emit(ThemeMode.values[themeIndex]);
    }
  }

  void toggleTheme(bool isDark) {
    final mode = isDark ? ThemeMode.dark : ThemeMode.light;
    prefs.setInt('theme_mode', mode.index);
    emit(mode);
  }
}
