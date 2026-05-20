import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CepResult {
  const CepResult({
    required this.logradouro,
    required this.bairro,
    required this.localidade,
    required this.uf,
  });

  final String logradouro;
  final String bairro;
  final String localidade;
  final String uf;
}

class CepService {
  /// Returns [CepResult] for a valid 8-digit CEP, or null if not found.
  /// Throws [SocketException] / [TimeoutException] on network failure.
  Future<CepResult?> lookup(String cep) async {
    final digits = cep.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 8) return null;

    final uri = Uri.parse('https://viacep.com.br/ws/$digits/json/');
    final response = await http
        .get(uri, headers: {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw HttpException('HTTP ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json.containsKey('erro')) return null;

    return CepResult(
      logradouro: json['logradouro'] as String? ?? '',
      bairro: json['bairro'] as String? ?? '',
      localidade: json['localidade'] as String? ?? '',
      uf: json['uf'] as String? ?? '',
    );
  }
}
