import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../secrets.dart';

class NokiaNumberService {
  static const String _host = 'network-as-code.nokia.rapidapi.com';
  // Prefer p-eu; some accounts use p. We will try both.
  static const List<String> _bases = [
    'https://network-as-code.p-eu.rapidapi.com/passthrough/camara/v1',
    'https://network-as-code.p.rapidapi.com/passthrough/camara/v1',
  ];

  static Map<String, String> _baseHeaders({Map<String, String>? extra}) {
    final headers = <String, String>{
      'x-rapidapi-host': _host,
      'x-rapidapi-key': rapidApiKey,
    };
    if (extra != null) headers.addAll(extra);
    return headers;
  }

  // GET /number-verification/v0/device-phone-number?state=...&code=...
  static Future<Map<String, dynamic>> phoneNumberShare({required String state, String? code, String? authorizationToken}) async {
    Exception? lastError;
    for (final base in _bases) {
      final uri = Uri.parse('$base/number-verification/number-verification/v0/device-phone-number').replace(queryParameters: {
        'state': state,
        if (code != null && code.isNotEmpty) 'code': code,
      });
      if (kDebugMode) {
        print('NokiaNumberService.phoneNumberShare -> GET $uri');
      }
      final res = await http.get(
        uri,
        headers: _baseHeaders(
          extra: authorizationToken != null && authorizationToken.isNotEmpty
              ? {'authorization': authorizationToken}
              : null,
        ),
      );
      if (kDebugMode) {
        print('Status: ${res.statusCode}');
        print('Body: ${res.body}');
      }
      if (res.statusCode >= 200 && res.statusCode < 300) {
        try {
          return json.decode(res.body) as Map<String, dynamic>;
        } catch (_) {
          return {'raw': res.body};
        }
      }
      lastError = Exception('phoneNumberShare failed on $base: ${res.statusCode} ${res.body}');
      // Try next base if 404/400
      if (res.statusCode != 404 && res.statusCode < 500) break;
    }
    throw lastError ?? Exception('phoneNumberShare failed');
  }

  // POST /number-verification/v0/verify  body {"phoneNumber":"+99999991000"}
  static Future<Map<String, dynamic>> phoneNumberVerify({required String phoneNumber, String? authorizationToken}) async {
    final headers = _baseHeaders(
      extra: {
        'Content-Type': 'application/json',
        if (authorizationToken != null && authorizationToken.isNotEmpty)
          'authorization': authorizationToken,
      },
    );
    final body = json.encode({'phoneNumber': phoneNumber});
    Exception? lastError;
    for (final base in _bases) {
      final uri = Uri.parse('$base/number-verification/number-verification/v0/verify');
      if (kDebugMode) {
        print('NokiaNumberService.phoneNumberVerify -> POST $uri');
      }
      final res = await http.post(uri, headers: headers, body: body);
      if (kDebugMode) {
        print('Status: ${res.statusCode}');
        print('Body: ${res.body}');
      }
      if (res.statusCode >= 200 && res.statusCode < 300) {
        try {
          return json.decode(res.body) as Map<String, dynamic>;
        } catch (_) {
          return {'raw': res.body};
        }
      }
      lastError = Exception('phoneNumberVerify failed on $base: ${res.statusCode} ${res.body}');
      if (res.statusCode != 404 && res.statusCode < 500) break;
    }
    throw lastError ?? Exception('phoneNumberVerify failed');
  }
}
