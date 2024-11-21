part of 'locale_cubit.dart';

class InitLocaleState extends LocaleState {
  final Locale locale;

  InitLocaleState(this.locale);
}

class LocaleChangedState extends LocaleState {
  final Locale locale;

  LocaleChangedState(this.locale);
}

abstract class LocaleState {}
