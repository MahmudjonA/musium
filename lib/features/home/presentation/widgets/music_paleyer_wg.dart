import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import '../../domain/entities/music.dart';

class MusicPlayerUI extends StatefulWidget {
  final Music music;

  const MusicPlayerUI({super.key, required this.music});

  @override
  State<MusicPlayerUI> createState() => _MusicPlayerUIState();
}

class _MusicPlayerUIState extends State<MusicPlayerUI> {
  late AudioPlayer _player;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    _player = AudioPlayer();

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());

    await _player.setUrl(widget.music.audioUrl);
    _duration = _player.duration ?? Duration.zero;

    _player.positionStream.listen((pos) {
      setState(() => _position = pos);
    });

    _player.playerStateStream.listen((state) {
      setState(() => _isPlaying = state.playing);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_isPlaying) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.music.trackName,
            style: const TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.music.trackArtist,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Icon(Icons.share, color: Colors.white, size: 20),
              SizedBox(width: 15),
              Icon(Icons.favorite_border, color: Colors.white, size: 20),
              SizedBox(width: 15),
              Icon(Icons.download_outlined, color: Colors.white, size: 20),
            ],
          ),
          const SizedBox(height: 10),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              trackHeight: 2,
              activeTrackColor: Colors.cyan,
              inactiveTrackColor: Colors.grey.shade700,
              thumbColor: Colors.cyan,
            ),
            child: Slider(
              value: _position.inSeconds.toDouble(),
              min: 0,
              max: _duration.inSeconds.toDouble(),
              onChanged: (value) {
                _player.seek(Duration(seconds: value.toInt()));
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_position),
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                _formatDuration(_duration),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _roundIcon(Icons.shuffle),
              _roundIcon(Icons.skip_previous),
              _playButton(),
              _roundIcon(Icons.skip_next),
              _roundIcon(Icons.equalizer),
              _roundIcon(Icons.add),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(1, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  Widget _roundIcon(IconData icon) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: Colors.black,
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _playButton() {
    return GestureDetector(
      onTap: _togglePlay,
      child: Container(
        width: 65,
        height: 65,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [Colors.cyan, Colors.blueAccent]),
          boxShadow: [
            BoxShadow(color: Colors.cyanAccent, blurRadius: 8, spreadRadius: 1),
          ],
        ),
        child: Icon(
          _isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }
}
