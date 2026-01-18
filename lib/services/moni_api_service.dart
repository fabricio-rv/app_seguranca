import 'dart:convert';
import 'package:http/http.dart' as http;

class MoniApiService {
  final String baseUrl;
  final String username;
  final String password;

  MoniApiService({
    required this.baseUrl,
    required this.username,
    required this.password,
  });

  /// Método genérico para requisições POST
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Basic ${base64Encode(utf8.encode('$username:$password'))}',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erro ao comunicar com Moni: ${response.body}');
    }
  }
}
