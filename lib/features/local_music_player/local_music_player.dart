import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/state_manager.dart';
import '../../utils/constants.dart';
import 'package:on_audio_query/on_audio_query.dart';
import './local_music_controller.dart';

class Player extends StatelessWidget {
  final List<SongModel> data;
  const Player({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();

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
          Obx(
            () => Expanded(
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
                id: data[controller.playIndex.value].id,
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
          ),
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
            child: Obx(
              () => Column(
                children: [
                  Text(
                    "${data[controller.playIndex.value].displayNameWOExt}",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    "${data[controller.playIndex.value].artist}",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Obx(
                    () => Row(
                      children: [
                        Text("${controller.position.value}"),
                        Expanded(
                            child: Slider(
                                thumbColor: Colors.deepPurple,
                                inactiveColor: Colors.deepPurple[100],
                                activeColor: Colors.deepPurple,
                                min: Duration(seconds: 0).inSeconds.toDouble(),
                                max: controller.max.value,
                                value: controller.value.value,
                                onChanged: (newValue) {
                                  controller.changeDurationToSeconds(
                                      newValue.toInt());
                                  newValue = newValue;
                                })),
                        Text("${controller.duration.value}")
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            controller.playSong(
                                data[controller.playIndex.value].uri,
                                controller.playIndex.value - 1);
                          },
                          icon: const Icon(
                            Icons.skip_previous_rounded,
                            size: 40,
                            color: Colors.deepPurple,
                          )),
                      Obx(
                        () => CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.deepPurple,
                          child: Transform.scale(
                            scale: 2.5,
                            child: IconButton(
                                onPressed: () {
                                  if (controller.isPlaying.value) {
                                    controller.audioPlayer.pause();
                                    controller.isPlaying(false);
                                  } else {
                                    controller.audioPlayer.play();
                                    controller.isPlaying(true);
                                  }
                                },
                                icon: controller.isPlaying.value
                                    ? Icon(
                                        Icons.pause_outlined,
                                        color: whiteColor,
                                      )
                                    : Icon(
                                        Icons.play_arrow_rounded,
                                        color: whiteColor,
                                      )),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          controller.playSong(
                              data[controller.playIndex.value].uri,
                              controller.playIndex.value + 1);
                        },
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
            ),
          ))
        ],
      ),
    );
  }
}
