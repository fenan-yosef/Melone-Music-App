// search_model.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchModel {
  final String _baseUrl = 'https://api.deezer.com/search';

  Future<List<String>> fetchSearchResults(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl?q=$query'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['data'];

      return results.map<String>((result) {
        return result['title']; // Assuming you want the title of the track
      }).toList();
    } else {
      throw Exception('Failed to load search results');
    }
  }
}
