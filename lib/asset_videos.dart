import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'asset_videoplayer.dart';
import 'model/video_item.dart';

class AssetVideos extends StatefulWidget {
  const AssetVideos({super.key});

  @override
  State<AssetVideos> createState() => _AssetVideosState();
}

class _AssetVideosState extends State<AssetVideos> {
  List<VideoItem> videoItems = [
    VideoItem(name: 'Video 1', assetPath: 'assets/videos/vid_1.mp4'),
    VideoItem(name: 'Video 2', assetPath: 'assets/videos/vid_2.mp4'),
    VideoItem(name: 'Video 3', assetPath: 'assets/videos/vid_3.mp4'),
    VideoItem(name: 'Video 4', assetPath: 'assets/videos/vid_4.mp4'),
    VideoItem(name: 'Video 5', assetPath: 'assets/videos/vid_5.mp4'),
    VideoItem(name: 'Video 6', assetPath: 'assets/videos/vid_6.mp4'),
    VideoItem(name: 'Video 7', assetPath: 'assets/videos/vid_7.mp4'),
    VideoItem(name: 'Video 8', assetPath: 'assets/videos/vid_8.mp4'),
    VideoItem(name: 'Video 9', assetPath: 'assets/videos/vid_9.mp4'),
    // Add the remaining videos here
  ];

  VideoPlayerController? _controller;

  void _playVideo(String assetPath) {
    if (_controller != null) {
      _controller!.dispose();
    }

    _controller = VideoPlayerController.asset(assetPath)
      ..initialize().then((_) {
        setState(() {});
        _controller!.play();
      });
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller!.dispose();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: videoItems.length,
        itemBuilder: (context, index) {
          final videoItem = videoItems[index];
          return ListTile(
            title: Text(videoItem.name),
            onTap: () {
              // Handle video playback here
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(videoAssetPath: videoItem.assetPath),
                ),
              );

            },
          );
        },
      ),
    );
  }
}
