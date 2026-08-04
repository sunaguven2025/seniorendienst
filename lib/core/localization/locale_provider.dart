import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'language_service.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(_deviceLocale()) {
    loadSavedLanguage();
  }

  static Locale _deviceLocale() {
    final locale = PlatformDispatcher.instance.locale;

    switch (locale.languageCode) {
      case "de":
        return const Locale("de");

      case "tr":
        return const Locale("tr");

      default:
        return const Locale("en");
    }
  }

  Future<void> loadSavedLanguage() async {
    final code = await LanguageService.loadLanguage();

    if (code != null) {
      state = Locale(code);
    }
  }

  Future<void> changeLocale(String code) async {
    state = Locale(code);

    await LanguageService.saveLanguage(code);
  }
}
