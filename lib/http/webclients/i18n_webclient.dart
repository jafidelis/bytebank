import 'dart:convert';

import 'package:bytebank/models/transaction.dart';
import 'package:http/http.dart';

import '../webclient.dart';
const baseUri = 'gist.github.com';

class I18nWebclient {
  final String _viewKey;

  I18nWebclient(this._viewKey);

  Future<Map<String, dynamic>> findAll() async {
    final Uri uri = Uri.https(baseUri, '/jafidelis/7ac9b81bfb161225289f3548ef405a62/raw/40f7345ffcb655155809d64784d9ea04e8207a40/$_viewKey-i18n.json');
    final Response response = await client.get(uri);
    final Map<String, dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson;
  }
}
