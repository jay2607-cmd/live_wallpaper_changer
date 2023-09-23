import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  String _platformVersion = 'Unknown';
  String _liveWallpaper = 'Unknown';

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

    _chewieController = ChewieController(
      videoPlayerController: widget.controller,
      autoPlay: true,
      looping: false,
      // Add more customization options here as needed.
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await AsyncWallpaper.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> setLiveWallpaper() async {
    setState(() {
      _liveWallpaper = 'Loading';
    });
    String result;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await AsyncWallpaper.setLiveWallpaper(
        filePath: widget.path,
        goToHome: false,
        toastDetails: ToastDetails.success(),
        errorToastDetails: ToastDetails.error(),
      )
          ? 'Wallpaper set'
          : 'Failed to set wallpaper.';
    } on PlatformException {
      result = 'Failed to set wallpaper.';
      Fluttertoast.showToast(
          msg: "This Device Doesn't Support Live Wallpaper!",
          toastLength: Toast.LENGTH_SHORT);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _liveWallpaper = result;
    });
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
          IconButton(
              onPressed: setLiveWallpaper, icon: Icon(Icons.change_circle))
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
