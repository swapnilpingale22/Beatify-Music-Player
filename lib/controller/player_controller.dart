import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();

  @override
  void onInit() {
    super.onInit();
    // checkPermission();
  }

  checkPermission() async {
    PermissionStatus perm = await Permission.storage.request();

    if (perm.isGranted) {
      // Permission granted, proceed with your logic here
      // loadAudioData();
    } else if (perm.isDenied || perm.isPermanentlyDenied) {
      // Permission denied, show an alert dialog
      showPermissionAlert();
    } else {
      // Permission is blocked, handle this case as needed
    }
  }

  showPermissionAlert() {
    Get.defaultDialog(
      title: "Permission Required",
      middleText: "Storage permission is required to use this music player.",
      textConfirm: "Allow",
      textCancel: "Deny",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        if (await openAppSettings()) {
          // The user opened the app settings, handle as needed
        }
      },
      onCancel: () {
        // The user denied the permission, handle as needed
        Get.back(); // Close the dialog
        Get.close(1); // Close the entire app
      },
    );
  }

  // loadAudioData() async {
  //   // Use the audioQuery object to query and load audio data
  //   // For example: audioQuery.querySongs()
  // }
}
