import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ChangeWallpaper extends StatefulWidget {

  final String path;
  const ChangeWallpaper({super.key, required this.path});

  @override
  State<ChangeWallpaper> createState() => ChangeWallpaperState();
}

class ChangeWallpaperState extends State<ChangeWallpaper> {


  String _platformVersion = 'Unknown';
  String _liveWallpaper = 'Unknown';

  // Update the asset path to match your video asset.
  late String assetVideoPath;

  late bool goToHome;
  String tempVideoFileName = 'temp_video.mp4'; // Unique temporary file name

  @override
  void initState() {
    super.initState();
    goToHome = false;
    initPlatformState();
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
    assetVideoPath = widget.path;

    setState(() {
      _liveWallpaper = 'Loading';
    });
    String result;

    try {
      // Generate a unique temporary file name for each video.
      final appDocumentsDirectory = await getApplicationDocumentsDirectory();
      final tempVideoFile = File('${appDocumentsDirectory.path}/$tempVideoFileName');

      if (!tempVideoFile.existsSync() || assetVideoPath != tempVideoFileName) {
        // Clear cache and copy the new video asset to the temporary file.
        final ByteData data = await rootBundle.load(assetVideoPath);
        final List<int> bytes = data.buffer.asUint8List();
        await tempVideoFile.writeAsBytes(bytes);
      }

      // Check if the file exists before trying to delete it.
      if (tempVideoFile.existsSync()) {
        // Use the path of the temporary video file to set the wallpaper.
        result = await AsyncWallpaper.setLiveWallpaper(
          filePath: tempVideoFile.path,
          goToHome: goToHome,
          toastDetails: ToastDetails.success(),
          errorToastDetails: ToastDetails.error(),
        )
            ? 'Wallpaper set'
            : 'Failed to set wallpaper.';
      } else {
        result = 'File not found.';
      }
    } on PlatformException {
      result = 'Failed to set wallpaper.';
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            child: Column(
              children: [
                Center(
                  child: Text('Running on: $_platformVersion\n'),
                ),
                SwitchListTile(
                    title: const Text('Go to home'),
                    value: goToHome,
                    onChanged: (value) {
                      setState(() {
                        goToHome = value;
                      });
                    }),
                ElevatedButton(
                  onPressed: setLiveWallpaper,
                  child: _liveWallpaper == 'Loading'
                      ? const CircularProgressIndicator()
                      : const Text('Set live wallpaper'),
                ),
                Center(
                  child: Text('Wallpaper status: $_liveWallpaper\n'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
