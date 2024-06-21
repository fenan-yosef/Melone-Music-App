import 'package:flutter/material.dart';
import './playback_model.dart';
import './playback_controller.dart';

class PlaybackSettingsView extends StatefulWidget {
  final PlaybackSettingsController controller;

  PlaybackSettingsView({required this.controller});

  @override
  _PlaybackSettingsViewState createState() => _PlaybackSettingsViewState();
}

class _PlaybackSettingsViewState extends State<PlaybackSettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom AppBar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              color: Colors.purple,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Playback Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Body Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Playback Speed
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Playback Speed',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '${widget.controller.model.playbackSpeed}x',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: widget.controller.model.playbackSpeed,
                        min: 0.5,
                        max: 2.0,
                        divisions: 6,
                        onChanged: (value) {
                          setState(() {
                            widget.controller.changePlaybackSpeed(value);
                          });
                        },
                      ),
                      // Shuffle and Loop
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),                                decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: widget.controller.model.shufflePlayback ? Color.fromARGB(255, 197, 75, 171) : Color.fromARGB(255, 212, 155, 223),
                              ),
                              child: SwitchListTile(
                              value: widget.controller.model.shufflePlayback,
                              onChanged: (value) {
                                setState(() {
                                  widget.controller.toogleShuffleMode();
                                });
                              },
                              title: Text('Shuffle Mode',
                              style: TextStyle(
                                    fontSize: widget.controller.model.shufflePlayback ? 16 : 12,
                                    fontWeight: FontWeight.bold,
                                  ),),
                            ),
                          ),
                          ),
                          Expanded(
                            child: Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: widget.controller.model.loopPlayback ? Color.fromARGB(255, 197, 75, 171) : Color.fromARGB(255, 212, 155, 223),
                              ), 
                            child: SwitchListTile(
                              value: widget.controller.model.loopPlayback,
                              onChanged: (value) {
                                setState(() {
                                  widget.controller.toggleLoopPlayback();
                                });
                              },
                              title: Text('Loop Mode',
                              style: TextStyle(
                                    fontSize: widget.controller.model.loopPlayback ? 16 : 12,
                                    fontWeight: FontWeight.bold,
                                  ),),
                          ),
                          ),
                        ),
                        ],
                      ),
                      // Bass and Treble
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bass Level',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Slider(
                                  value: widget.controller.model.bassLevel,
                                  min: 0.0,
                                  max: 1.0,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.controller.changeBassLevel(value);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Treble Level',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Slider(
                                  value: widget.controller.model.volume,
                                  min: 0.0,
                                  max: 1.0,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.controller.changeVolume(value);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}