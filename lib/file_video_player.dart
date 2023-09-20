import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:video_wallpaper/change_wallpaper.dart';

class VideoPlayerScreen2 extends StatefulWidget {
  final VideoPlayerController controller;
  final String path;

  VideoPlayerScreen2({required this.controller, required this.path});

  @override
  _VideoPlayerScreen2State createState() => _VideoPlayerScreen2State();
}

class _VideoPlayerScreen2State extends State<VideoPlayerScreen2> {
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    // Do not initialize ChewieController here
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize the Chewie controller in the didChangeDependencies method
    _initializeChewieController();
  }

  void _initializeChewieController() {
    double aspectRatio = 16 / 9; // Default aspect ratio, you can adjust it

    // Calculate the aspect ratio based on screen dimensions
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      // Portrait mode
      aspectRatio = MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;
    } else {
      // Landscape mode
      aspectRatio = MediaQuery.of(context).size.height / MediaQuery.of(context).size.width;
    }

    _chewieController = ChewieController(
      videoPlayerController: widget.controller,
      autoPlay: true,
      looping: false,
      aspectRatio: aspectRatio, // Set the aspect ratio here
      // Add more customization options here as needed.
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ChewieController when building the widget
    if (_chewieController == null) {
      _initializeChewieController();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeWallpaper(path: widget.path
              ,)));
          }, icon: Icon(Icons.change_circle))
        ],
      ),
      body: Center(
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _chewieController.dispose();
    widget.controller.dispose();
    super.dispose();
  }
}
