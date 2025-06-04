import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:terbangin/constants.dart';

class AuthService {

  Future<Map<String, dynamic>> login(String email, String password) async {
  try {
    final r = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    print('┌─ status = ${r.statusCode}');
    print('└─ body   = ${r.body}');

    final data = jsonDecode(r.body);

    if (r.statusCode == 200) {
      return {
        'success': true,
        'token': data['access_token'], // pastikan ini ada
      };
    }

    return {
      'success': false,
      'message': data['message'] ?? 'Login failed',
    };
  } catch (e) {
    print('Login exception → $e');
    return {'success': false, 'message': 'Network error'};
  }
}

Future<Map<String, dynamic>> register(String name, String email, String password) async {
  final response = await http.post(
    Uri.parse('$baseUrl/register'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode({
      'name': name,
      'email': email,
      'password': password,
    }),
  );

  final body = jsonDecode(response.body);
  if (response.statusCode == 200) {
    return {
      'success': true,
      'token': body['access_token'],
    };
  } else {
    return {
      'success': false,
      'message': body['message'] ?? 'Register failed',
    };
  }
}

}
