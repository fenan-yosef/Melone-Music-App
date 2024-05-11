import 'package:flutter/material.dart';
import 'package:your_app_name/features/authentication/authentication.dart';
import 'package:your_app_name/features/music_feed/music_feed.dart';
import 'package:your_app_name/features/local_music_player/local_music_player.dart';
import 'package:your_app_name/features/music_equalizer/music_equalizer.dart';
import 'package:your_app_name/features/search/search.dart';
import 'package:your_app_name/features/settings/settings.dart';

class Routes {
  static const String initial = '/';
  static final Map<String, WidgetBuilder> routes = {
    '/': (context) => AuthenticationPage(),
    '/musicFeed': (context) => MusicFeedPage(),
    '/localMusicPlayer': (context) => LocalMusicPlayerPage(),
    '/musicEqualizer': (context) => MusicEqualizerPage(),
    '/search': (context) => SearchPage(),
    '/settings': (context) => SettingsPage(),
  };
}
