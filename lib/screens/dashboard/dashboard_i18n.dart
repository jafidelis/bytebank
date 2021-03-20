

import 'package:bytebank/components/localization/i18n_messages.dart';

class DashboardViewLazyI18N {
  final I18NMessages _messages;

  DashboardViewLazyI18N(this._messages);

  String get transfer => _messages.get('transfer');

  String get transaction_feed => _messages.get('transaction_feed');

  String get change_name => _messages.get('change_name');

}


// Forma de construir fixo na própia view... não é muito adequado.
// class DashboardI18N extends ViewI18N {
//   DashboardI18N(BuildContext context): super(context);
//
//   String get transfer => localize({'pt-br': 'Transfererir', 'en': 'Transfer'});
//
//   String get transaction_feed => localize({'pt-br': 'Transações', 'en': 'Transaction feed'});
//
//   String get change_name => localize({'pt-br': 'Mudar nome', 'en': 'Change name'});
//
// }