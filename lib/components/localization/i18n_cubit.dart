import 'package:bytebank/http/webclients/i18n_webclient.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstorage/localstorage.dart';

import 'i18n_messages.dart';
import 'i18n_state.dart';

class I18NMessagesCubit extends Cubit<I18NMessagesState> {
  final LocalStorage storage = new LocalStorage('local_inseguro_version_1');
  final String _viewKey;

  I18NMessagesCubit(this._viewKey) : super(InitI18NMessagesState());

  reload(I18nWebclient client) async {
    emit(LoadingI18NMessagesState());
    await storage.ready;
    final items = storage.getItem(_viewKey);
    if (items != null) {
      emit(LoadedI18NMessagesState(I18NMessages(items)));
      return;
    }
    final Map<String, dynamic> messages = await client.findAll();
    saveAndRefresh(messages);
  }

  void saveAndRefresh(Map<String, dynamic> messages) {
    storage.setItem(_viewKey, messages);
    emit(LoadedI18NMessagesState(I18NMessages(messages)));
  }
}