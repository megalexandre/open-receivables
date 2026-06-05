import 'package:organizagrana/l10n/app_localizations.dart';

class AppValidators {

  static String? required(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) return l10n.validationsFieldRequired;
    return null;
  }

  static String? password(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) return l10n.validationsPasswordRequired;
    return null;
  }

  static String? email(String? value, AppLocalizations l10n) {
    final email = value?.trim() ?? '';

    final emailRegex = RegExp(
      r'^[^\s@]+@[^\s@]+\.[^\s@]+$'
    );

    if (email.isEmpty) {
      return l10n.validationsEmailRequired;
    }

    if (!emailRegex.hasMatch(email)) {
      return l10n.validationsEmailInvalid;
    }

    return null;
  }
  
}