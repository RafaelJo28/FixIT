// Minimal HTTP client for the FixIT backend.
//
// PROTOTYPE: all endpoints return mocked responses for now. Replace
// [baseUrl] and the method bodies with real API calls when the Neon
// Postgres backend is ready.
import 'dart:convert';

import 'package:fixit/services/auth_storage.dart';
import 'package:http/http.dart' as http;

/// Base URL of the FixIT API. Change this when the backend is deployed.
const String kApiBaseUrl = 'https://api.fixit.example.com';

/// Throw this when the API returns an error status code.
class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode: $message)';
}

/// Centralized HTTP client with auth header injection and error handling.
class ApiClient {
  ApiClient({http.Client? client, this.baseUrl = kApiBaseUrl})
      : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;
  final AuthStorage _storage = AuthStorage.instance;

  /// Adds the bearer token (if any) and JSON content-type to [headers].
  Map<String, String> _headers({
    bool requireAuth = false,
    Map<String, String>? extra,
  }) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?extra,
    };
    if (requireAuth) {
      final token = _storage.token;
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Future<http.Response> get(
    String path, {
    bool requireAuth = false,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await _client.get(uri, headers: _headers(
      requireAuth: requireAuth,
      extra: headers,
    ));
    return _check(response);
  }

  Future<http.Response> post(
    String path, {
    dynamic body,
    Map<String, String>? headers,
    bool requireAuth = false,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await _client.post(
      uri,
      headers: _headers(requireAuth: requireAuth, extra: headers),
      body: body == null ? null : jsonEncode(body),
    );
    return _check(response);
  }

  Future<http.Response> put(
    String path, {
    dynamic body,
    Map<String, String>? headers,
    bool requireAuth = false,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await _client.put(
      uri,
      headers: _headers(requireAuth: requireAuth, extra: headers),
      body: body == null ? null : jsonEncode(body),
    );
    return _check(response);
  }

  Future<http.Response> delete(
    String path, {
    bool requireAuth = false,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await _client.delete(
      uri,
      headers: _headers(requireAuth: requireAuth, extra: headers),
    );
    return _check(response);
  }

  http.Response _check(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    }
    throw ApiException(response.statusCode, response.body);
  }

  void dispose() {
    _client.close();
  }
}

/// Convenience accessor so the rest of the app can use a single shared client.
final ApiClient api = ApiClient();