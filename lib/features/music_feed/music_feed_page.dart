import 'package:Melone/features/local_music_player/local_music_player_page.dart';
import 'package:Melone/features/search/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:on_audio_query/on_audio_query.dart';
import 'dart:convert';

import '../../utils/constants.dart';
import '../local_music_player/local_music_player.dart';
import '../settings/settings_page.dart';

class HomeFeed extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeFeed> {
  int _currentIndex = 0;
  late Future<MusicFeedData> _musicFeedData;

  @override
  void initState() {
    super.initState();
    _musicFeedData = fetchMusicFeedData();
  }

  Future<MusicFeedData> fetchMusicFeedData() async {
    final randomAlbumResponse =
        await http.get(Uri.parse('https://api.deezer.com/chart'));
    final topTracksResponse =
        await http.get(Uri.parse('https://api.deezer.com/chart/0/tracks'));
    final randomTracksResponse =
        await http.get(Uri.parse('https://api.deezer.com/track/3135556'));

    if (randomAlbumResponse.statusCode == 200 &&
        topTracksResponse.statusCode == 200 &&
        randomTracksResponse.statusCode == 200) {
      var randomAlbumsData =
          json.decode(randomAlbumResponse.body)['albums']['data'];
      var randomArtistsData =
          json.decode(randomAlbumResponse.body)['artists']['data'];
      var topTracksData = json.decode(topTracksResponse.body)['data'];
      print(topTracksData);
      var randomTracksData = [
        json.decode(randomTracksResponse.body)
      ]; //['tracks']['data'];  // Single track

      return MusicFeedData(
        albums: randomAlbumsData
            .map<Album>((json) => Album.fromJson(json))
            .toList(),
        artists: randomArtistsData
            .map<Artist>((json) => Artist.fromJson(json))
            .toList(),
        topTracks:
            topTracksData.map<Track>((json) => Track.fromJson(json)).toList(),
        randomTracks: randomTracksData
            .map<Track>((json) => Track.fromJson(json))
            .toList(),
      );
    } else {
      throw Exception('Failed to load music data');
    }
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 0) {
        _musicFeedData =
            fetchMusicFeedData(); // Refresh data when home is tapped
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [
      MusicFeed(musicFeedData: _musicFeedData),
      SearchPage(),
      LocalMusicScreen(),
      // MenuView(),
    ];

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Color(0xff30cfd0), Color(0xff330867)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: Icon(
            Icons.account_circle_rounded,
            color: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          title: Center(
            child: Text(
              "Melone",
              style: TextStyle(
                fontSize: 20,
                color: Color(0xff2c0d6e),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search_rounded,
                color: Colors.transparent,
              ),
              color: black,
            )
          ],
        ),
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              label: 'Home',
              backgroundColor: Color(0xff091838),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_music),
              label: 'Local Music',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_rounded),
              label: 'Menu',
            ),
          ],
          selectedItemColor: Color(0xff2cc3c4),
          unselectedItemColor: Colors.white,
          backgroundColor: Colors.transparent,
          elevation: 2.0,
        ),
      ),
    );
  }
}

class MusicFeedData {
  final List<Album> albums;
  final List<Track> topTracks;
  final List<Track> randomTracks;
  final List<Artist> artists;

  MusicFeedData(
      {required this.albums,
      required this.topTracks,
      required this.randomTracks,
      required this.artists});
}

class MusicFeed extends StatelessWidget {
  final Future<MusicFeedData> musicFeedData;

  MusicFeed({required this.musicFeedData});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MusicFeedData>(
      future: musicFeedData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: Colors.black,
          ));
        } else if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Center(
              child: Column(
            children: [
              SizedBox(height: 90),
              Icon(
                Icons.wifi_off_rounded,
                size: 60,
                color: Colors.white,
              ),
              SizedBox(height: 30),
              Text(
                "Failed to connect to deezer.com, \nplease check your conection!",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w100,
                  letterSpacing: 2,
                ),
              )
            ],
          ));
        } else {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                SectionTitle(title: 'Artists'),
                HorizontalArtistList(artists: snapshot.data!.artists),
                SizedBox(
                  height: 20,
                ),
                SectionTitle(title: 'Albums'),
                HorizontalAlbumList(albums: snapshot.data!.albums),
                SizedBox(
                  height: 20,
                ),
                SectionTitle(title: 'Top Tracks'),
                HorizontalTrackList(tracks: snapshot.data!.topTracks),
                SectionTitle(title: 'Special Suggestions'),
                HorizontalTrackList(tracks: snapshot.data!.randomTracks),
              ],
            ),
          );
        }
      },
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class HorizontalArtistList extends StatelessWidget {
  final List<Artist> artists;

  HorizontalArtistList({required this.artists});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: artists.length,
        itemBuilder: (context, index) {
          final artist = artists[index];
          return Container(
            width: 160,
            child: Card(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              elevation: 3.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff0ba360),
                      Color(0xff3cba92)
                    ], // Replace with your desired colors
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.network(
                          artist.coverUrl,
                          fit: BoxFit.cover,
                          height: 120,
                          width: 160,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        artist.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class HorizontalAlbumList extends StatelessWidget {
  final List<Album> albums;

  HorizontalAlbumList({required this.albums});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];
          return Container(
            width: 160,
            child: Card(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff9795f0),
                      Color(0xff3cba92)
                    ], // Replace with your desired colors
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.network(album.coverUrl,
                              fit: BoxFit.cover, height: 120, width: 160)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        album.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        album.artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class HorizontalTrackList extends StatelessWidget {
  final List<Track> tracks;

  HorizontalTrackList({required this.tracks});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: tracks.length,
        itemBuilder: (context, index) {
          final track = tracks[index];
          return GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) =>
              //         Player(
              //       data: tracks, // Pass the list of tracks
              //       currentIndex: index, // Pass the index of the selected track
              //     ),
              //   ),
              // );
            },
            child: Container(
              width: 200,
              child: Card(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(0xff92cc9d),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          track.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          track.artist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LocalMusicScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LocalMusicPlayer();
  }
}

class Album {
  final String title;
  final String artist;
  final String coverUrl;

  Album({required this.title, required this.artist, required this.coverUrl});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      title: json['title'],
      artist: json['artist']['name'],
      coverUrl: json['cover_medium'],
    );
  }
}

class Track {
  final String previewUri;
  final String title;
  final String artist;

  Track({required this.previewUri, required this.title, required this.artist});

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      previewUri: json['preview'],
      title: json['title'],
      artist: json['artist']['name'],
    );
  }
}

class Artist {
  final String name;
  final String coverUrl;

  Artist({required this.name, required this.coverUrl});

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      name: json['name'],
      coverUrl: json['picture_medium'],
    );
  }
}
