import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServices {
  final http.Client client;
  ApiServices(this.client);

  static const String baseUrl =
      'https://crudcrud.com/api/9dd7ee0d61664b18bb557bb6feadd5df/employees';

  Future<bool> deleteById(String id) async {
    final url = '$baseUrl/$id';
    final uri = Uri.parse(url);

    try {
      final response = await http.delete(uri);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
            'Failed to delete employee. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete employee. Error: $e');
    }
  }

  Future<List?> fetchApi() async {
    final url = '$baseUrl';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch data. Error: $e');
    }
  }

  Future<bool> updateApi(String id, Map body) async {
    final url = '$baseUrl/$id';
    final uri = Uri.parse(url);

    try {
      final response = await http.put(
        uri,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
            'Failed to update employee. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update employee. Error: $e');
    }
  }

  Future<bool> addApi(Map body) async {
    final url = '$baseUrl';
    final uri = Uri.parse(url);

    try {
      final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception(
            'Failed to add employee. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to add employee. Error: $e');
    }
  }
}
