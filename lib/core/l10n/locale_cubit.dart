import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  final SharedPreferences prefs;

  LocaleCubit({required this.prefs}) : super(const Locale('en')) {
    _loadLocale();
  }

  void _loadLocale() {
    final languageCode = prefs.getString('language_code');
    if (languageCode != null) {
      emit(Locale(languageCode));
    }
  }

  void setLocale(String languageCode) {
    prefs.setString('language_code', languageCode);
    emit(Locale(languageCode));
  }
}
