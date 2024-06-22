import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import '../../utils/constants.dart';
import '../api_music_player/api_player_view.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin {

  final TextEditingController _controller = TextEditingController();
  final String clientId = '31a665e6'; // Replace with your actual client ID
  TabController? _tabController;
  bool _isLoading = false;
  List<dynamic> _results = [];
  AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  Future<void> _search(String query, String type) async {
    setState(() {
      _isLoading = true;
    });

    String url;
    switch (type) {
      case 'albums':
        url = 'https://api.jamendo.com/v3.0/albums/?client_id=$clientId&format=json&search=$query';
        break;
      case 'artists':
        url = 'https://api.jamendo.com/v3.0/artists/?client_id=$clientId&format=json&search=$query';
        break;
      case 'tracks':
        url = 'https://api.jamendo.com/v3.0/tracks/?client_id=$clientId&format=json&search=$query';
        break;
      case 'genres':
        url = 'https://api.jamendo.com/v3.0/tags/?client_id=$clientId&format=json&search=$query';
        break;
      default:
        url = '';
        break;
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _results = data['results'];
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load search results');
    }
  }

  void _play(String url) async {
    await _audioPlayer.play(UrlSource(url));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  void _onTabChanged(int tabIndex) {
    String query = _controller.text;
    String type = tabIndex == 0
        ? 'tracks'
        : tabIndex == 1
        ? 'artists'
        : tabIndex == 2
        ? 'albums'
        : 'genres';
    _search(query, type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        bottom: TabBar(
          labelColor: Color(0xff0B183F),
          unselectedLabelColor: Colors.white,
          controller: _tabController,
          tabs: [
            Tab(text: 'Tracks'),
            Tab(text: 'Artists'),
            Tab(text: 'Albums'),
            Tab(text: 'Genres'),
          ],
          onTap: _onTabChanged,
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              style: const TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(
                    color: Colors.white38
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: Colors.white,),
                  onPressed: () {
                    String query = _controller.text;
                    String type = _tabController?.index == 0
                        ? 'tracks'
                        : _tabController?.index == 1
                        ? 'artists'
                        : _tabController?.index == 2
                        ? 'albums'
                        : 'genres';
                    _search(query, type);
                  },
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : TabBarView(
                controller: _tabController,
                children: [
                  _buildResultsList('tracks'),
                  _buildResultsList('artists'),
                  _buildResultsList('albums'),
                  _buildResultsList('genres'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList(String type) {
    if (type == 'albums' || type == 'artists') {
      return ListView.builder(
        itemCount: _results.length,
        itemBuilder: (context, index) {
          final item = _results[index];
          return ListTile(
            title: Text(item['name'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            leading: Image.network(item['image']),
            subtitle: type == 'albums' ? Text('Album', style: TextStyle(color: Colors.white38),) : Text('Artist', style: TextStyle(color: Colors.white38),),
            onTap: (){
              // print(_results.toList());
            },
          );
        },
      );
    } else if (type == 'tracks') {
      return ListView.builder(
        itemCount: _results.length,
        itemBuilder: (context, index) {
          final track = _results[index];
          return ListTile(
            title: Text(track['name'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text(track['album_name'] ?? 'Single', style: TextStyle(color: Colors.white38)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayerPage(
                    trackName: track['name'],
                    audioUrl: track['audio'],
                    albumImage: track['image'],
                  ),
                ),
              );
            },
          );
        },
      );
    } else if (type == 'genres') {
      if(_results.length == 0){
        return Center(
          child:Text("No results found", style: TextStyle(color: Colors.white38)),
        );
      }
      return ListView.builder(
        itemCount: _results.length,
        itemBuilder: (context, index) {
          final genre = _results[index];
          return ListTile(
            title: Text(genre['name'], style: TextStyle(color: Colors.white38)),
          );
        },
      );
    } else {
      return Container();
    }
  }

}
