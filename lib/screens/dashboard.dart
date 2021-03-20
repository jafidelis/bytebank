import 'package:bytebank/components/container.dart';
import 'package:bytebank/components/localization.dart';
import 'package:bytebank/models/name.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/name.dart';
import 'package:bytebank/screens/transactions_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardContainer extends BlocContainer {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NameCubit("Alexandre"),
      child: I18NLoadingContainer(
        (messages) => DashboardView(DashboardViewLazyI18N(messages))
      ),
    );
  }
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

class DashboardViewLazyI18N {
  final I18NMessages _messages;

  DashboardViewLazyI18N(this._messages);

  String get transfer => _messages.get('transfer');

  String get transaction_feed => _messages.get('transaction_feed');

  String get change_name => _messages.get('change_name');

}

class DashboardView extends StatelessWidget {
  final DashboardViewLazyI18N _i18n;

  DashboardView(this._i18n);

  @override
  Widget build(BuildContext context) {
    // final name = context.read<NameCubit>().state;
    // var i18n = DashboardViewLazyI18N(_messages);
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NameCubit, String> (
          builder: (context, state) => Text('Welcome $state'),
        )
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('images/bytebank_logo.png'),
          ),
          SingleChildScrollView(
            child: Container(
              height: 116,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _FeatureItem(
                    _i18n.transfer,
                    Icons.monetization_on,
                    onClick: () => _showContactList(context),
                  ),
                  _FeatureItem(
                    _i18n.transaction_feed,
                    Icons.description,
                    onClick: () => _showTransactionList(context),
                  ),
                  _FeatureItem(
                    _i18n.change_name,
                    Icons.person_outline,
                    onClick: () => _showChangeName(context),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _showContactList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ContactsListContainer(),
      ),
    );
  }

  _showTransactionList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TransactionsList(),
      ),
    );
  }

  _showChangeName(BuildContext blocContext) {
    Navigator.of(blocContext).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: BlocProvider.of<NameCubit>(blocContext),
          child: NameContainer(),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String _name;
  final IconData _icon;
  final Function onClick;

  _FeatureItem(
    this._name,
    this._icon, {
    @required this.onClick,
  })  : assert(_icon != null),
        assert(onClick != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: () => onClick(),
          child: Container(
            padding: EdgeInsets.all(8.0),
            height: 100,
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _icon,
                  color: Colors.white,
                  size: 32.0,
                ),
                Text(
                  _name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
