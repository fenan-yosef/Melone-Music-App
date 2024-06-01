// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// // import 'package:flutter_web_auth/flutter_web_auth.dart';
//
// class SpotifyService {
//   final String clientId = 'f68fd47050aa4b1aa9e1058078f137a2';
//   final String clientSecret = '1f2bd085021445ffb8cc2a066bd15322';
//   final String redirectUri = 'myapp://auth';
//   String? _accessToken;
//
//   Future<void> authenticate() async {
//     final result = await FlutterWebAuth.authenticate(
//       url: 'https://accounts.spotify.com/authorize?client_id=$clientId&response_type=code&redirect_uri=$redirectUri&scope=user-library-read',
//       callbackUrlScheme: 'myapp',
//     );
//
//     final code = Uri.parse(result).queryParameters['code'];
//
//     final response = await http.post(
//       Uri.parse('https://accounts.spotify.com/api/token'),
//       headers: {'Content-Type': 'application/x-www-form-urlencoded'},
//       body: {
//         'grant_type': 'authorization_code',
//         'code': code,
//         'redirect_uri': redirectUri,
//         'client_id': clientId,
//         'client_secret': clientSecret,
//       },
//     );
//
//     _accessToken = json.decode(response.body)['access_token'];
//   }
//
//   Future<List<dynamic>> searchMusic(String query) async {
//     if (_accessToken == null) {
//       await authenticate();
//     }
//
//     final response = await http.get(
//       Uri.parse('https://api.spotify.com/v1/search?q=$query&type=track'),
//       headers: {'Authorization': 'Bearer $_accessToken'},
//     );
//
//     if (response.statusCode == 200) {
//       return json.decode(response.body)['tracks']['items'];
//     } else {
//       throw Exception('Failed to load music');
//     }
//   }
// }
//
// 
// class MusicSearchScreen extends StatefulWidget {
//   @override
//   _MusicSearchScreenState createState() => _MusicSearchScreenState();
// }
//
// class _MusicSearchScreenState extends State<MusicSearchScreen> {
//   final SpotifyService _spotifyService = SpotifyService();
//   final TextEditingController _controller = TextEditingController();
//   List<dynamic> _results = [];
//   bool _isLoading = false;
//
//   void _searchMusic() async {
//     setState(() {
//       _isLoading = true;
//     });
//     final results = await _spotifyService.searchMusic(_controller.text);
//     setState(() {
//       _results = results;
//       _isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Music Search'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _controller,
//               decoration: InputDecoration(
//                 labelText: 'Search Music',
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.search),
//                   onPressed: _searchMusic,
//                 ),
//               ),
//             ),
//             _isLoading ? CircularProgressIndicator() : SizedBox.shrink(),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _results.length,
//                 itemBuilder: (context, index) {
//                   final track = _results[index];
//                   return ListTile(
//                     title: Text(track['name']),
//                     subtitle: Text(track['artists'][0]['name']),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => AudioPlayerWidget(url: track['preview_url']),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class AudioPlayerWidget extends StatefulWidget {
//   final String url;
//   AudioPlayerWidget({required this.url});
//
//   @override
//   _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
// }
//
// class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _audioPlayer.setUrl(widget.url).then((_) {
//       setState(() {
//         _isLoading = false;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Audio Player'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             _isLoading
//                 ? CircularProgressIndicator()
//                 : StreamBuilder<PlayerState>(
//               stream: _audioPlayer.playerStateStream,
//               builder: (context, snapshot) {
//                 final playerState = snapshot.data;
//                 if (playerState?.processingState == ProcessingState.buffering) {
//                   return CircularProgressIndicator();
//                 } else if (playerState?.playing == true) {
//                   return IconButton(
//                     icon: Icon(Icons.pause),
//                     onPressed: _audioPlayer.pause,
//                   );
//                 } else {
//                   return IconButton(
//                     icon: Icon(Icons.play_arrow),
//                     onPressed: _audioPlayer.play,
//                   );
//                 }
//               },
//             ),
//             StreamBuilder<Duration>(
//               stream: _audioPlayer.positionStream,
//               builder: (context, snapshot) {
//                 final position = snapshot.data ?? Duration.zero;
//                 return Slider(
//                   value: position.inSeconds.toDouble(),
//                   onChanged: (value) {
//                     _audioPlayer.seek(Duration(seconds: value.toInt()));
//                   },
//                   min: 0,
//                   max: (_audioPlayer.duration?.inSeconds.toDouble() ?? 0),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// class DeezerService {
//   final String apiUrl = 'https://api.deezer.com/search';
//
//   Future<List<dynamic>> searchMusic(String query) async {
//     final response = await http.get(Uri.parse('$apiUrl?q=$query'));
//     if (response.statusCode == 200) {
//       return json.decode(response.body)['data'];
//     } else {
//       throw Exception('Failed to load music');
//     }
//   }
// }
//
