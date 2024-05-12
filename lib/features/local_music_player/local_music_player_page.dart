import 'package:flutter/material.dart';
// import 'package:get_server/get_server.dart';
import 'package:get/get.dart';
import 'package:msss/features/local_music_player/local_music_player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../utils/constants.dart';

class LocalMusicPlayer extends StatelessWidget {
  const LocalMusicPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());

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
        body: FutureBuilder<List<SongModel>>(
            future: controller.audioQuery.querySongs(
              ignoreCase: true,
              orderType: OrderType.ASC_OR_SMALLER,
              sortType: null,
              uriType: UriType.EXTERNAL,
            ),
            builder: (BuildContext context, snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data!.isEmpty) {
                print("True");
                print(snapshot.data);
                return Center(
                  child: Text("No song found!", style: ourStyle()),
                );
              } else {
                return Padding(
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
                              title: Text(
                                snapshot.data![index].displayNameWOExt,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "${snapshot.data![index].artist}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
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
                        }));
              }
            }));
  }
}
