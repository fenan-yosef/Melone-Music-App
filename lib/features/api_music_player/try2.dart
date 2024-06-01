import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';

import '../../utils/constants.dart';

void main() {
  runApp(JamendoSearchApp());
}

class JamendoSearchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jamendo Search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SearchPage(),
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottom: TabBar(
          labelColor: purple,
          unselectedLabelColor: Colors.white,
          controller: _tabController,
          tabs: [
            Tab(text: 'Albums'),
            Tab(text: 'Artists'),
            Tab(text: 'Tracks'),
            Tab(text: 'Genres'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
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
                        ? 'albums'
                        : _tabController?.index == 1
                        ? 'artists'
                        : _tabController?.index == 2
                        ? 'tracks'
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
                  _buildResultsList('albums'),
                  _buildResultsList('artists'),
                  _buildResultsList('tracks'),
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
            title: Text(item['name']),
            leading: Image.network(item['image']),
            subtitle: type == 'albums' ? Text('Album') : Text('Artist'),
          );
        },
      );
    } else if (type == 'tracks') {
      return ListView.builder(
        itemCount: _results.length,
        itemBuilder: (context, index) {
          final track = _results[index];
          return ListTile(
            title: Text(track['name']),
            subtitle: Text(track['album_name'] ?? 'Single'),
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
      return ListView.builder(
        itemCount: _results.length,
        itemBuilder: (context, index) {
          final genre = _results[index];
          return ListTile(
            title: Text(genre['name']),
          );
        },
      );
    } else {
      return Container();
    }
  }

}

class PlayerPage extends StatefulWidget {
  final String trackName;
  final String audioUrl;
  final String albumImage;

  PlayerPage({required this.trackName, required this.audioUrl, required this.albumImage});

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  double _currentPosition = 0.0;
  double _totalDuration = 1.0;
  bool _isSliderChanging = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer.setSourceUrl(widget.audioUrl);
    _audioPlayer.onPositionChanged.listen((Duration duration) {
      setState(() {
        _currentPosition = duration.inSeconds.toDouble();
      });
    });
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _totalDuration = duration.inSeconds.toDouble();
      });
    });
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.resume();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _onSeek(double value) {
    if (!_isSliderChanging) {
      setState(() {
        _isSliderChanging = true;
      });
      _audioPlayer.seek(Duration(seconds: value.toInt())).then((_) {
        setState(() {
          _currentPosition = value;
          _isSliderChanging = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trackName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(widget.albumImage),
            SizedBox(height: 20),
            Text(
              widget.trackName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Slider(
              min: 0.0,
              max: _totalDuration,
              value: _currentPosition,
              onChanged: (value) {
                setState(() {
                  _currentPosition = value;
                });
              },
              onChangeEnd: _onSeek,
            ),
            SizedBox(height: 8),
            Text(
              '${Duration(seconds: _currentPosition.toInt()).toString().split('.').first}',
            ),
            SizedBox(height: 20),
            IconButton(
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 64),
              onPressed: _togglePlayPause,
            ),
            // Add more components here (e.g., additional controls, etc.)
          ],
        ),
      ),
    );
  }
}