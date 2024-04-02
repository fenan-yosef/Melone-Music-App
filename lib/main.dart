import 'dart:io';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Music Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MusicPlayerScreen(),
    );
  }
}

class MusicPlayerScreen extends StatefulWidget {
  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  AudioPlayer _audioPlayer = AudioPlayer();
  List<String> _musicFiles = [];

  @override
  void initState() {
    super.initState();
    _getMusicFiles();
  }

  Future<void> _getMusicFiles() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String musicDirPath = '${appDir.path}/Music';
    Directory musicDir = Directory(musicDirPath);
    List<FileSystemEntity> files = musicDir.listSync(recursive: false);

    List<String> musicFiles = [];
    for (FileSystemEntity file in files) {
      if (file is File && file.path.endsWith('.mp3')) {
        musicFiles.add(file.path);
      }
    }

    setState(() {
      _musicFiles = musicFiles;
    });
  }

  Future<void> _playMusic(String filePath) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(filePath, isLocal: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Local Music Player'),
      ),
      body: ListView.builder(
        itemCount: _musicFiles.length,
        itemBuilder: (context, index) {
          String musicFile = _musicFiles[index];
          return ListTile(
            title: Text(
              musicFile.split('/').last,
            ),
            onTap: () => _playMusic(musicFile),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
