import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ios_notification_task/Controllers/notification_controller.dart';
import 'package:ios_notification_task/screens/widgets.dart/custom_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  final NotificationController notificationController =
      Get.put(NotificationController());
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationController.getDeviceToken();
    notificationController.requestIOSPermissions();
    notificationController.foregroundMessage();
    notificationController.firebaseInIt(context);
    notificationController.setupInteractionMessage(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("File Upload & Download")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Upload File
            InkWell(
              onTap: () {
                notificationController.uploadFile(context);
              },
              child: Obx(() => Container(
                    height: 60.h,
                    width: 200.w,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: notificationController.isUploading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : CustomText(
                              "Upload File",
                              color: Colors.white,
                            ),
                    ),
                  )),
            ),
            SizedBox(height: 30.h),

            // Download File
            InkWell(
              onTap: () {
                notificationController.downloadFile(
                    "hussain_resume.pdf", context);
              },
              child: Obx(() => Container(
                    height: 60,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: notificationController.isDownloading.value
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: notificationController
                                      .downloadProgress.value,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 5),
                                CustomText(
                                  "${(notificationController.downloadProgress.value * 100).toStringAsFixed(1)}%",
                                  color: Colors.white,
                                ),
                              ],
                            )
                          : CustomText(
                              "Download File",
                              color: Colors.white,
                            ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
