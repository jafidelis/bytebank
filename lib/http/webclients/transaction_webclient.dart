import 'dart:convert';

import 'package:bytebank/models/transaction.dart';
import 'package:http/http.dart';

import '../webclient.dart';

class TransactionWebclient {
  Future<List<Transaction>> findAll() async {
    final Response response = await client.get(baseUrl).timeout(
          Duration(seconds: 5),
        );
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson
        .map((dynamic json) => Transaction.fromJson(json))
        .toList();
  }

  Future<Transaction> save(Transaction transaction, String password) async {
    final Response response = await client.post(baseUrl,
        headers: {
          'content-type': 'application/json',
          'password': password,
        },
        body: jsonEncode(transaction.toJson()));

    if (response.statusCode == 400) {
      throw Exception('there was an error submitting transaction');
    }

    if (response.statusCode == 401) {
      throw Exception('Authentication failed');
    }

    return Transaction.fromJson(jsonDecode(response.body));
  }
}
