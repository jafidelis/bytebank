import 'package:flutter/material.dart';

class TransactionAuthDialog extends StatefulWidget {
  final Function(String password) onConfirm;

  TransactionAuthDialog({
    @required this.onConfirm,
  });

  @override
  _TransactionAuthDialogState createState() => _TransactionAuthDialogState();
}

class _TransactionAuthDialogState extends State<TransactionAuthDialog> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Authenticate'),
      content: TextField(
        controller: _passwordController,
        obscureText: true,
        maxLength: 4,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
        style: TextStyle(
          fontSize: 64,
          letterSpacing: 24,
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
      ),
      actions: [
        _ActionButton('Cancel', onClick: () => Navigator.pop(context)),
        _ActionButton('Confirm', onClick: () {
          widget.onConfirm(_passwordController.text);
          Navigator.pop(context);
        }),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Function onClick;

  _ActionButton(this.label, {@required this.onClick});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () => onClick(),
      child: Text(label),
    );
  }
}
