import 'package:flutter/material.dart';
import 'package:video_wallpaper/asset_videos.dart';
import 'package:video_wallpaper/change_wallpaper.dart';
import 'package:video_wallpaper/fromFile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AssetVideos()));
                  },
                  child: Text("Live Wallpaper")),

              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FromFile()));
                  },
                  child: Text("From File"))
            ],
          ),
        ),
      ),
    );
  }
}
