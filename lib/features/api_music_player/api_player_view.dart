import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../utils/constants.dart';

class PlayerPage extends StatefulWidget {
  final String trackName;
  final String audioUrl;
  final String albumImage;

  PlayerPage(
      {required this.trackName,
      required this.audioUrl,
      required this.albumImage});

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _onshuffle = false;
  bool _onRepeat = false;
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
  void _toggleShuffle() {
    setState(() {
      _onshuffle = !_onshuffle;
    });
  }

  void _toggleRepeat(){
    setState(() {
      _onRepeat = !_onRepeat;
    });
  }



  void _rewind(){
    setState(() {
      _currentPosition = 0.0;
    });
  }
  void _forward(){
    setState(() {
      _currentPosition += 5;
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
            Container(
              child: Image.network(widget.albumImage),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
            ),
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
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    _onshuffle? Icons.shuffle_on_sharp : Icons.shuffle,
                    size: 20,
                    color: Colors.purple,
                  ),
                  onPressed: _toggleShuffle ,
                ),
                IconButton(
                  icon: Icon(
                    Icons.fast_rewind_outlined,
                    size: 40,
                    color: Colors.purple,
                  ),
                  onPressed: _rewind,
                ),
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 64,
                    color: Colors.purple,
                  ),
                  onPressed: _togglePlayPause,
                ),
                IconButton(
                  icon: Icon(
                    Icons.fast_forward_outlined,
                    size: 40,
                    color: Colors.purple,
                  ),
                  onPressed: _forward,
                ),
                IconButton(
                  icon: Icon(
                    _onRepeat ? Icons.repeat_one : Icons.repeat,
                    size: 20,
                    color: Colors.purple,
                  ),
                  onPressed: _toggleRepeat,
                ),
                
              ],
            ),
            ),
            // Add more components here (e.g., additional controls, etc.)
          ],
        ),
      ),
    );
  }
}
