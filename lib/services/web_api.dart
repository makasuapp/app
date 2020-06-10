import 'dart:core';
import 'package:http/http.dart' as http;

class WebApi {
  static const apiScheme = 'https';
  static const apiHost = 'kitchen.bramper.com';
  static const prefix = '/api';

  static Uri uri(String path, {Map<String, dynamic> queryParameters}) {
    final uri = new Uri(
      scheme: apiScheme,
      host: apiHost,
      path: '$prefix$path',
      queryParameters: queryParameters
    );

    return uri;
  }

  static Future<String> _fetchJson(String endpoint) async {
    final uri = WebApi.uri(endpoint);
    final resp = await http.get(uri.toString());

    if (resp.statusCode != 200) {
      throw (resp.body);
    }

    return resp.body;
  }
  static Future<String> fetchRecipesJson() => WebApi._fetchJson('/recipes');
  static Future<String> fetchIngredientsJson() => WebApi._fetchJson('/ingredients');
}