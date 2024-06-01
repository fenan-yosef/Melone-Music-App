// search_screen.dart
import 'package:flutter/material.dart';
import './search_controller.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchControler _controller = SearchControler();
  List<String> _results = [];
  bool _isLoading = false;
  String _errorMessage = '';

  void _search(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      List<String> results = await _controller.search(query);
      setState(() {
        _results = results;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search, color: Colors.white),
              ),
              onSubmitted: _search,
            ),
            SizedBox(height: 20),
            if (_isLoading)
              Center(child: CircularProgressIndicator(color: Colors.purple)),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 2),
                    child: ListTile(
                      leading: Icon(Icons.music_note, color: Colors.purple),
                      title: Text(_results[index],
                      style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
