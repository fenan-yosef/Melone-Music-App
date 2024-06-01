import 'package:Melone/features/api_music_player/api_music_player.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../local_music_player/local_music_player_page.dart';

class MusicFeedPage extends StatefulWidget {
  @override
  _MusicFeedPageState createState() => _MusicFeedPageState();
}

class _MusicFeedPageState extends State<MusicFeedPage> {
  List<dynamic> tracks = [];

  @override
  void initState() {
    super.initState();
    fetchSoundCloudPlaylist();
  }

  void fetchSoundCloudPlaylist() async {
    var url = 'https://soundcloud-scraper.p.rapidapi.com/v1/playlist/tracks';
    var params = {
      'playlist': 'https://soundcloud.com/thechainsmokers/sets/no-hard-feelings'
    };
    var headers = {
      'X-RapidAPI-Key': '3c25554214msh75ac2607247858cp11e9f5jsnf436bba31bd1',
      'X-RapidAPI-Host': 'soundcloud-scraper.p.rapidapi.com'
    };

    print(params);

    var queryString = params.keys
        .map((key) => '$key=${Uri.encodeComponent(params[key] ?? '')}')
        .join('&');
    var fullUrl = '$url?$queryString';
    print('------------');
    print(queryString);

    try {
      var response = await http.get(Uri.parse(fullUrl), headers: headers);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // print('data' + data.toString());
        if (data['tracks'] != null && data['tracks']['items'] != null) {
          print('---------------ulala-----------');
          print("tracks");
          // print(tracks[0]);
          setState(() {
            tracks = data['tracks']['items'];
          });
          print("tracks");
          print(tracks[0]['type']);
        } else {
          print('Error: data["tracks"] or data["tracks"]["items"] is null');
        }
      } else {
        print('Failed to load tracks: ${response.statusCode}');
      }
    } catch (error) {
      print('ejgu');
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('here');
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Feed'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LocalMusicPlayer()),
                );
              },
              child: Text('Your Musics'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: tracks.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: tracks.length,
                      itemBuilder: (context, index) {
                        var track = tracks[index];
                        return GestureDetector(
                          onTap: () {
                            //
                          },
                          child: ListTile(
                            title: Text(track['title']),
                            subtitle: Text(track['user']['name']),
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
