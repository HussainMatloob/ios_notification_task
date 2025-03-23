import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:ios_notification_task/services/storage_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationController extends GetxController {
  //final Util util = Get.put(Util());
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String? deviceToken;

/*----------------------------------------------------------------*/
/*          Handle notifications for  ios and android             */
/*----------------------------------------------------------------*/
//Get device token
  Future<void> getDeviceToken() async {
    try {
      String? token = await messaging.getToken();
      if (token != null) {
        deviceToken = token;
        update();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Token Not Generated',
        colorText: Colors.black,
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.TOP,
        onTap: (SnackBar) {},
      );
    }
  }

//refresh device token
  Future<void> isTokenRefresh() async {
    try {
      messaging.onTokenRefresh.listen((event) {
        print('Token refreshed: $event');
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Token Not Refreshed',
        colorText: Colors.black,
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.TOP,
        onTap: (SnackBar) {},
      );
    }
  }

//request notification permission for ios
  void requestIOSPermissions() async {
    if (Platform.isIOS) {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        if (kDebugMode) {
          print("User granted permission for notifications on iOS");
        }
      } else {
        if (kDebugMode) {
          print(
              "User declined or has not granted permission for notifications on iOS");
        }
      }
    }
  }

//  For ios forground notification
  Future foregroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

//initilize local notification
  void initLocalNotification(
      BuildContext context, RemoteMessage message) async {
    var androidInitialization =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitialization = const DarwinInitializationSettings();
    var initializationSetting = InitializationSettings(
      android: androidInitialization,
      iOS: iosInitialization,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (payload) {
        handleMessage(context, message);
      },
    );
  }

// Show notification when app in forground
  void firebaseInIt(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message.notification?.title.toString());
        print(message.notification?.body.toString());
        print(message.data.toString());
        print(message.data['type'].toString());
        print(message.data['id'].toString());
      }
      if (Platform.isAndroid) {
        //The initLocalNotification function run when android app is in foreground
        initLocalNotification(context, message);
        showNotification(message);
      } else if (Platform.isIOS) {
        // Handle iOS-specific notification
        foregroundMessage();
        showNotification(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    try {
      final tag = DateTime.now().millisecondsSinceEpoch.toString();
      AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        "Important Notifications",
        importance: Importance.max,
      );
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      // For Android
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
              channel.id.toString(), channel.name.toString(),
              channelDescription: 'Your Channel description',
              importance: Importance.high,
              priority: Priority.high,
              playSound: true,
              ticker: 'ticker',
              sound: channel.sound,
              tag: tag);

      // For iOS
      DarwinNotificationDetails darwinNotificationDetails =
          DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        presentBadge: true,
      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
      );

      await _flutterLocalNotificationsPlugin.show(
        tag.hashCode,
        message.notification?.title ?? '',
        message.notification?.body ?? '',
        notificationDetails,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error showing notification: $e');
      }
    }
  }

//Trigrer notification automatically When app in background or terminated
  Future<void> setupInteractionMessage(BuildContext context) async {
    //When app is Terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }
    // When app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'msg') {
      //when click on notification then Move to app specific screen
      //util.bottomNavIndex(1);
    }
  }

  static Future<String> getAccessToken() async {
    final serviceAccountJson = {};

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    //get the access token
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );
    client.close();
    return credentials.accessToken.data;
  }

  void sendNotificationToSelectedDevice(String deviceToken,
      BuildContext context, String title, String subtitle) async {
    final String serverAccessTokenKey = await getAccessToken();
    String endPointCloudFirebaseMessaging =
        "https://fcm.googleapis.com/v1/projects/breathin-24eff/messages:send";
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Map<String, dynamic> message = {
      'message': {
        'token': deviceToken,
        'notification': {
          'title': '${title}',
          'body': '${subtitle}',
          //'sound': 'default',
          //'tag':time
        },
        'data': {'type': 'msg', 'id': time}
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endPointCloudFirebaseMessaging),
      headers: <String, String>{
        'Content-Type': 'application/json',
        //This is Server key
        'Authorization': 'Bearer $serverAccessTokenKey'
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print("Notification send successfully");
    } else {
      print("Your Notification not send");
    }
  }

  /*----------------------------------------------------------------*/
  /*                 Upload and download file                       */
  /*----------------------------------------------------------------*/

  var isUploading = false.obs;
  var isDownloading = false.obs;
  var downloadProgress = 0.0.obs; // For real-time progress tracking

  // Upload File
  Future<void> uploadFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        File file = File(result.files.single.path!);
        String fileName = result.files.single.name;

        isUploading.value = true; // Show progress
        await StorageServices.uploadFileOnStorge(file, fileName);

        isUploading.value = false; // Hide progress

        sendNotificationToSelectedDevice(deviceToken ?? "", context, "Success",
            "File Uploaded Successfully");
      }
    } catch (e) {
      sendNotificationToSelectedDevice(
          deviceToken ?? "", context, "Error", e.toString());
    }
  }

  // Download File
  Future<void> downloadFile(String fileName, BuildContext context) async {
    try {
      Reference ref = FirebaseStorage.instance.ref().child("uploads/$fileName");

      Directory? dir;
      if (Platform.isAndroid) {
        if (await Permission.storage.request().isGranted ||
            await Permission.manageExternalStorage.request().isGranted) {
          dir = Directory(
              "/storage/emulated/0/Download"); // Android Downloads folder
        } else {
          sendNotificationToSelectedDevice(
              deviceToken ?? "", context, "Error", "Storage permission denied");
          return;
        }
      } else if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory(); // iOS private storage
      }

      if (dir == null) {
        sendNotificationToSelectedDevice(
            deviceToken ?? "", context, "Error", "Directory not found");
        return;
      }

      File file = File("${dir.path}/$fileName");

      isDownloading.value = true;
      downloadProgress.value = 0.0;

      DownloadTask task = ref.writeToFile(file);
      task.snapshotEvents.listen((TaskSnapshot snapshot) {
        if (snapshot.totalBytes > 0) {
          downloadProgress.value =
              snapshot.bytesTransferred / snapshot.totalBytes;
        }
      });

      await task;

      isDownloading.value = false;
      downloadProgress.value = 1.0;

      sendNotificationToSelectedDevice(deviceToken ?? "", context, "Success",
          "File downloaded to ${file.path}");
    } on FirebaseException catch (e) {
      sendNotificationToSelectedDevice(
          deviceToken ?? "", context, "Error", "Database error: ${e.message}");
    } on TimeoutException {
      sendNotificationToSelectedDevice(deviceToken ?? "", context, "Error",
          "Request timed out. Please check your internet connection.");
    } on SocketException {
      sendNotificationToSelectedDevice(deviceToken ?? "", context, "Error",
          "Network issue detected. Please try again.");
    } catch (e) {
      sendNotificationToSelectedDevice(deviceToken ?? "", context, "Error",
          "Something went wrong: ${e.toString()}");
    }
  }
}
