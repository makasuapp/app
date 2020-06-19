import 'dart:core';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ingredient_update.dart';

class WebApi {
  String apiScheme;
  String apiHost;
  final prefix = '/api';

  WebApi({apiScheme, apiHost}) {
    this.apiScheme = apiScheme ?? 'https';
    this.apiHost = apiHost ?? 'kitchen.bramper.com';
  }

  Uri uri(String path, {Map<String, dynamic> queryParameters}) {
    final uri = new Uri(
      scheme: this.apiScheme,
      host: this.apiHost,
      path: '${this.prefix}$path',
      queryParameters: queryParameters
    );

    return uri;
  }

  Future<String> _fetchJson(String endpoint) async {
    final uri = this.uri(endpoint);
    final resp = await http.get(uri.toString());

    if (resp.statusCode != 200) {
      throw (resp.body);
    }

    return resp.body;
  }
  Future<String> fetchRecipesJson() => this._fetchJson('/recipes');
  Future<String> fetchInventoryJson() => this._fetchJson('/inventory');

  Future<dynamic> _postJson(String endpoint, dynamic body) async {
    final uri = this.uri(endpoint);
    final resp = await http.post(
      uri.toString(), 
      headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body
    );

    if (resp.statusCode != 200) {
      throw (resp.body);
    }

    return resp.body;
  }

  Future<void> postInventorySaveQty(List<IngredientUpdate> updates) async {
    final body = jsonEncode({'updates': updates});
    return this._postJson('/inventory/save_qty', body);
  }
}