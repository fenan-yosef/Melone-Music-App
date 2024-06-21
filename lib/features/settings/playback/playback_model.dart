
class PlaybackSettings {
  late double volume;
  late double playbackSpeed;
  late bool loopPlayback;
  late bool shufflePlayback;
  late double bassLevel;

  PlaybackSettings({
    this.volume = 1.0,
    this.playbackSpeed = 1.0,
    this.loopPlayback = false,
    this.shufflePlayback = false,
    this.bassLevel = 1.0,
  });

  void setPlaybackSpeed(double speed) {
    playbackSpeed = speed;
  }

  void setVolume(double level) {
    volume = level;
  }

  void toggleLoopPlayback() {
    loopPlayback = !loopPlayback;
  }

  void setBassLevel(double level) {
    bassLevel = level;
  }

  void setShufflePlayback() {
    shufflePlayback = !shufflePlayback;
  }
}