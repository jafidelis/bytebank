import 'dart:async';

import 'package:bytebank/components/Progress.dart';
import 'package:bytebank/components/container.dart';
import 'package:bytebank/components/error.dart';
import 'package:bytebank/components/response_dialog.dart';
import 'package:bytebank/components/transaction_auth_dialog.dart';
import 'package:bytebank/http/webclients/transaction_webclient.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

@immutable
abstract class TransactionFormState {
  const TransactionFormState();
}

@immutable
class SendingState extends TransactionFormState {
  const SendingState();
}

@immutable
class ShowFormState extends TransactionFormState {
  const ShowFormState();
}

@immutable
class SentState extends TransactionFormState {
  const SentState();
}

@immutable
class FatalErrorFormState extends TransactionFormState {
  final String _message;

  const FatalErrorFormState(this._message);
}

class TransactionFormCubit extends Cubit<TransactionFormState> {
  final TransactionWebclient _webClient = TransactionWebclient();

  TransactionFormCubit() : super(ShowFormState());

  void save(Transaction transactionCreated, String password,
      BuildContext context) async {
    emit(SendingState());
    _send(transactionCreated, password, context);
    // emit(SentState());
    // _showSuccesssfulMessage(transaction, context);
  }

  Future _showSuccesssfulMessage(
      Transaction transaction, BuildContext context) async {
    if (transaction != null) {
      await showDialog(
          context: context,
          builder: (contextDialog) => SuccessDialog('successfull transaction'));
      Navigator.pop(context);
    }
  }

  void _send(
      Transaction transactionCreated, String password, BuildContext context) {
    _webClient
        .save(transactionCreated, password)
        .then((transaction) => emit(SentState()))
        .catchError((e) {
      emit(FatalErrorFormState(e.massage));
    }, test: (e) => e is HttpException).catchError((e) {
      emit(FatalErrorFormState('timeout submiting the transaction'));
    }, test: (e) => e is TimeoutException).catchError((e) {
      emit(FatalErrorFormState(e.massage));
    });
  }

  void _showFailureMessage(BuildContext context,
      {String message = 'unknow error'}) {
    showDialog(
        context: context, builder: (contextDialog) => FailureDialog(message));
  }
}

class TransactionFormContainer extends BlocContainer {
  final Contact _contact;

  TransactionFormContainer(this._contact);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionFormCubit>(
      create: (BuildContext context) {
        return TransactionFormCubit();
      },
      child: BlocListener<TransactionFormCubit, TransactionFormState>(
          listener: (context, state) {
            if (state is SentState) {
              Navigator.pop(context);
            }
          },
          child: TransactionForm(_contact)),
    );
  }
}

class TransactionForm extends StatelessWidget {
  final Contact contact;

  TransactionForm(this.contact);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionFormCubit, TransactionFormState>(
        builder: (context, state) {
      if (state is ShowFormState) {
        return _BasicForm(contact);
      }
      if (state is SendingState || state is SentState) {
        return _ProgressView();
      }
      if (state is FatalErrorFormState) {
        return ErrorView(state._message);
      }
      return ErrorView('Unknown error');
    });
  }
}

class _ProgressView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progressing')),
      body: Progress(
        message: 'Sending...',
      ),
    );
  }
}

class _BasicForm extends StatelessWidget {
  final TextEditingController _valueController = TextEditingController();
  final String transactionId = Uuid().v4();
  final Contact _contact;

  _BasicForm(this._contact);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _contact.name,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _contact.accountNumber.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Text('Transfer'),
                    onPressed: () {
                      final double value =
                          double.tryParse(_valueController.text);
                      final transactionCreated =
                          Transaction(transactionId, value, _contact);
                      showDialog(
                        context: context,
                        builder: (contextDialog) => TransactionAuthDialog(
                          onConfirm: (password) {
                            BlocProvider.of<TransactionFormCubit>(context)
                                .save(transactionCreated, password, context);
                          },
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
