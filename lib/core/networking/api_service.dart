import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<dynamic>> getAlbums() async {
    final response = await client.get(Uri.parse('$baseUrl/albums'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load albums');
    }
  }

  Future<List<dynamic>> getPhotosByAlbum(int albumId) async {
    final response = await client.get(Uri.parse('$baseUrl/photos?albumId=$albumId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load photos');
    }
  }
}