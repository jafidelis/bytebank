import 'package:bytebank/components/container.dart';
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
      child: DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final name = context.read<NameCubit>().state;
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
                    'Transfer',
                    Icons.monetization_on,
                    onClick: () => _showContactList(context),
                  ),
                  _FeatureItem(
                    'Transaction feed',
                    Icons.description,
                    onClick: () => _showTransactionList(context),
                  ),
                  _FeatureItem(
                    'Change name',
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
