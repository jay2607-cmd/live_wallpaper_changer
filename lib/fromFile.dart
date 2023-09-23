import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';

import 'file_video_player.dart';

class FromFile extends StatefulWidget {
  const FromFile({super.key});

  @override
  State<FromFile> createState() => _FromFileState();
}

class _FromFileState extends State<FromFile> {
  Future<void> pickVideo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp4'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        // You can access the selected video file using file.path
        final filePath = file.path;
        if (filePath != null) {
          print("Selected video: ${file.name}, path: $filePath");
          VideoPlayerController controller = VideoPlayerController.file(
            File(filePath),
          );

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerScreen2(controller: controller, path: filePath),
            ),
          );
        } else {
          // Handle the case where filePath is null (should not happen)
        }
      } else {
        // User canceled the file picker
      }
    } catch (e) {
      // Handle errors
      print("Error picking video: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              pickVideo();
            },
            child: Text("Pick File"),
          ),
        ),
      ),
    );
  }
}
