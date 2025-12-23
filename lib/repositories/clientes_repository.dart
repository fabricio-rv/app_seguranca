// lib/repositories/clientes_repository.dart
import '../services/moni_api_service.dart';

class ClientesRepository {
  final MoniApiService api;

  ClientesRepository(this.api);

  Future<List<Map<String, dynamic>>> buscarClientes() async {
    final data = await api.post('/LerDados', {
      "comando": "SELECT Codigo, RazaoSocial, CGC, Telefone FROM Clientes"
    });

    // Evita duplicatas por CGC
    final uniqueClients = <String, Map<String, dynamic>>{};
    for (var cliente in data) {
      final cpfCnpj = cliente['CGC'].toString();
      if (!uniqueClients.containsKey(cpfCnpj)) {
        uniqueClients[cpfCnpj] = cliente;
      }
    }

    return uniqueClients.values.toList();
  }
}
