import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class LocalMusicPlayer extends StatelessWidget {
  const LocalMusicPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: black,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search_rounded),
            color: black,
          )
        ],
        leading: Icon(
          Icons.sort_rounded,
          color: black,
        ),
        title: Text(
          "Melone",
          style: TextStyle(
            fontSize: 20,
            color: purple,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: 100,
            itemBuilder: (BuildContext, int index) {
              return Container(
                margin: EdgeInsets.only(bottom: 4),
                // decoration:
                //     BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  tileColor: Colors.deepPurple[100],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  // tileColor: Colors.deepPurple,
                  title: Text('Music name', style: ourStyle()),
                  subtitle: Text(
                    "Artist Name",
                    style: ourStyle(),
                  ),
                  leading: Icon(
                    Icons.music_note,
                    color: black,
                  ),
                  trailing: const Icon(
                    Icons.play_arrow,
                    color: black,
                    size: 26,
                  ),
                ),
              );
            }),
      ),
    );
  }
}
