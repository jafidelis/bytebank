import 'package:bytebank/components/Progress.dart';
import 'package:bytebank/components/container.dart';
import 'package:bytebank/dao/contact_dao.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/contact_form.dart';
import 'package:bytebank/screens/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class ContactListState {
  const ContactListState();
}

@immutable
class InitContactListState extends ContactListState {
  const InitContactListState();
}

@immutable
class LoadingContactListState extends ContactListState {
  const LoadingContactListState();
}

@immutable
class LoadedContactListState extends ContactListState {
  final List<Contact> _contacts;
  const LoadedContactListState(this._contacts);
}

@immutable
class FatalErrorContactListState extends ContactListState {
  const FatalErrorContactListState();
}

class ContactListCubit extends Cubit<ContactListState> {
  ContactListCubit() : super(InitContactListState());

  void reload(ContactDao dao) async {
    emit(LoadingContactListState());
    final List<Contact> contacts = await dao.findAll() ?? [];
    emit(LoadedContactListState(contacts));
  }
}

class ContactsListContainer extends BlocContainer {
  @override
  Widget build(BuildContext context) {
    final ContactDao _dao = ContactDao();
    return BlocProvider<ContactListCubit>(
        create: (BuildContext context) {
          final cubit = ContactListCubit();
          cubit.reload(_dao);
          return cubit;
        },
        child: ContactsList(_dao));
  }
}


class ContactsList extends StatelessWidget {
  final ContactDao _dao;

  ContactsList(this._dao);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: BlocBuilder<ContactListCubit, ContactListState>(
        builder: (context, state) {
          if (state is InitContactListState || state is LoadingContactListState) {
            return Progress();
          }
          if (state is LoadedContactListState) {
            final contacts = state._contacts;
            return ListView.builder(
              itemBuilder: (context, index) {
                final Contact contact = contacts[index];
                return _ContactItem(
                  contact,
                  onClick: () {
                    push(context, TransactionFormContainer(contact));
                  },
                );
              },
              itemCount: contacts.length,
            );
          }
          return const Text('Unknown error');
        },
      ),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (context) => ContactForm(),
              ),
            );
        update(context);
      },
      child: Icon(Icons.add),
    );
  }

  void update(BuildContext context) {
    context.read<ContactListCubit>().reload(_dao);
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;
  final Function onClick;

  _ContactItem(
    this.contact, {
    @required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onClick(),
        title: Text(
          contact.name,
          style: TextStyle(fontSize: 24),
        ),
        subtitle: Text(
          contact.accountNumber.toString(),
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
