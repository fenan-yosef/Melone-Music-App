import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:msss/utils/constants.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Player extends StatelessWidget {
  final SongModel data;
  const Player({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Center(
            child: Text(
          "Now Playing",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        )),
        actions: [
          IconButton(
              onPressed: () {}, icon: Icon(Icons.favorite_border_rounded))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // color: Colors.deepPurple[100],
            ),
            alignment: Alignment.center,
            child: QueryArtworkWidget(
              id: data.id,
              type: ArtworkType.AUDIO,
              artworkHeight: double.infinity,
              artworkWidth: double.infinity,
              nullArtworkWidget: const Icon(
                Icons.music_note_rounded,
                size: 48,
                color: whiteColor,
              ),
            ),
          )),
          SizedBox(
            height: 12,
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              color: whiteColor,
            ),
            child: Column(
              children: [
                Text(
                  "${data.displayNameWOExt}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "${data.artist}",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Text("0:0"),
                    Expanded(
                        child: Slider(
                            thumbColor: Colors.deepPurple,
                            inactiveColor: Colors.deepPurple[100],
                            activeColor: Colors.deepPurple,
                            value: 0.0,
                            onChanged: (newValue) {})),
                    Text("4:00")
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.skip_previous_rounded,
                          size: 40,
                          color: Colors.deepPurple,
                        )),
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.deepPurple,
                      child: Transform.scale(
                        scale: 2.5,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.play_arrow_rounded,
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.skip_next_rounded,
                        size: 40,
                        color: Colors.deepPurple,
                      ),
                    )
                  ],
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
