import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:video_wallpaper/change_wallpaper.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoAssetPath;

  VideoPlayerScreen({required this.videoAssetPath});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.asset(widget.videoAssetPath);
    _chewieController = ChewieController(
      aspectRatio: 9 / 16,
      allowFullScreen: true,
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping:
          true, // You can set looping to false if you don't want the video to loop.
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChangeWallpaper(path: widget.videoAssetPath,)));
              },
              icon: Icon(Icons.change_circle))
        ],
      ),
      body: Center(
        child: Chewie(controller: _chewieController),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
