import 'package:bytebank/models/name.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/name.dart';
import 'package:bytebank/screens/transactions_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/dashboard_feature_item.dart';
import 'dashboard_i18n.dart';

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
                  FeatureItem(
                    _i18n.transfer,
                    Icons.monetization_on,
                    onClick: () => _showContactList(context),
                  ),
                  FeatureItem(
                    _i18n.transaction_feed,
                    Icons.description,
                    onClick: () => _showTransactionList(context),
                  ),
                  FeatureItem(
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


