import 'package:flutter/material.dart';
// import 'package:get_server/get_server.dart';
import 'package:get/get.dart';
import 'package:Melone/features/local_music_player/local_music_player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../utils/constants.dart';
import './local_music_controller.dart';

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
                    padding: const EdgeInsets.all(7.0),
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext, int index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 4),
                            // decoration:
                            //     BoxDecoration(borderRadius: BorderRadius.circular(12)),
                            child: Obx(
                              () => Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
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
                                  leading: QueryArtworkWidget(
                                    id: snapshot.data![index].id,
                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget: const Icon(
                                      Icons.music_note,
                                      color: Colors.black,
                                    ),
                                  ),
                                  trailing:
                                      controller.playIndex.value == index &&
                                              controller.isPlaying.value
                                          ? const Icon(
                                              Icons.play_arrow,
                                              color: black,
                                              size: 26,
                                            )
                                          : null,
                                  onTap: () {
                                    Get.to(
                                      () => Player(
                                        data: snapshot.data!,
                                      ),
                                      transition: Transition.downToUp,
                                    );
                                    controller.playSong(
                                        snapshot.data![index].uri, index);
                                    controller.playSong(
                                        snapshot.data![index].uri, index);
                                  },
                                ),
                              ),
                            ),
                          );
                        }));
              }
            }));
  }
}
