// search_controller.dart
import './search_viewmodel.dart';

class SearchControler {
  final SearchModel _model = SearchModel();

  Future<List<String>> search(String query) async {
    return await _model.fetchSearchResults(query);
  }
}
