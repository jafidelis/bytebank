import 'dart:convert';

import 'package:bytebank/models/transaction.dart';
import 'package:http/http.dart';

import '../webclient.dart';

class TransactionWebclient {
  final Uri _uri = Uri.http(baseUrl, '/transactions');

  Future<List<Transaction>> findAll() async {

    final Response response = await client.get(_uri);
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson
        .map((dynamic json) => Transaction.fromJson(json))
        .toList();
  }

  Future<Transaction> save(Transaction transaction, String password) async {
    final Response response = await client.post(_uri,
        headers: {
          'content-type': 'application/json',
          'password': password,
        },
        body: jsonEncode(transaction.toJson()));
    if (response.statusCode == 200) {
      return Transaction.fromJson(jsonDecode(response.body));
    }
    throw HttpException(_statusCodeResponse[response.statusCode]);
  }

  static final Map<int, String> _statusCodeResponse = {
    400 : 'there was an error submitting transaction',
    401 : 'Authentication failed'
  };
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message);
}
