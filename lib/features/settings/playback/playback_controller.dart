import './playback_model.dart';
// import './playback_view.dart';

class PlaybackSettingsController {
  final PlaybackSettings model;
  PlaybackSettingsController(this.model);

  void changePlaybackSpeed(double speed) {
    model.setPlaybackSpeed(speed);
    print("Playback speed changed to $speed");
  }

  void changeVolume(double level) {
    model.setVolume(level);
    print("Volume changed to $level");
  }

  void toggleLoopPlayback() {
    model.toggleLoopPlayback();
    print("Loop mode: ${model.loopPlayback}");
  }

  void toogleShuffleMode() {
    model.setShufflePlayback();
    print("Shuffle mode: ${model.shufflePlayback}");
  }

  void changeBassLevel(double level) {
    model.setBassLevel(level);
    print("Bass level changed to $level");
  }
}
