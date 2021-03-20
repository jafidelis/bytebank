import 'package:flutter/material.dart';

import 'i18n_messages.dart';

@immutable
abstract class I18NMessagesState {
  const I18NMessagesState();
}

@immutable
class InitI18NMessagesState extends I18NMessagesState {
  const InitI18NMessagesState();
}

@immutable
class LoadingI18NMessagesState extends I18NMessagesState {
  const LoadingI18NMessagesState();
}

@immutable
class LoadedI18NMessagesState extends I18NMessagesState {
  final I18NMessages i18nMessages;
  const LoadedI18NMessagesState(this.i18nMessages);
}

@immutable
class FatalErrorI18NMessagesState extends I18NMessagesState {
  const FatalErrorI18NMessagesState();
}