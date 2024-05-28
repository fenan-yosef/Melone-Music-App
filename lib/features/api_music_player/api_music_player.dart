import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class APIMusicPlayer extends StatefulWidget {
  final Map<String, dynamic> track;

  APIMusicPlayer({required this.track});

  @override
  _APIMusicPlayerState createState() => _APIMusicPlayerState();
}

class _APIMusicPlayerState extends State<APIMusicPlayer> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playOrPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.track['permalink']));
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(widget.track['artworkUrl']),
            SizedBox(height: 16.0),
            Text(
              widget.track['title'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(widget.track['user']['name']),
            SizedBox(height: 16.0),
            IconButton(
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              iconSize: 48.0,
              onPressed: _playOrPause,
            ),
          ],
        ),
      ),
    );
  }
}
