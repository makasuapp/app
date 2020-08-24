import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationHandler {
  final FlutterLocalNotificationsPlugin localNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  final SelectNotificationCallback onSelectNotification;
  final FirebaseMessaging firebaseMessaging;
  final String title;
  final String notificationSoundPathAndroid;
  final String notificationSoundPathIos;

  LocalNotificationHandler(this.firebaseMessaging, this.title,
      {this.onSelectNotification, this.notificationSoundPathAndroid, this.notificationSoundPathIos});

  Future<void> initNotificationHandler() async {
    firebaseMessaging.requestNotificationPermissions();

    final androidInitSettings =
        new AndroidInitializationSettings('@mipmap/makasu');
    final iosInitSettings = new IOSInitializationSettings(
        requestAlertPermission: true,
        requestSoundPermission: true,
        requestBadgePermission: true);
    await localNotificationsPlugin.initialize(
        InitializationSettings(androidInitSettings, iosInitSettings),
        onSelectNotification: this.onSelectNotification);
    var result = await localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void showNotification(String message) async {
    final androidNotificationDetails = AndroidNotificationDetails(
      title,
      "Makasu",
      message,
      importance: Importance.High,
      priority: Priority.High,
      sound: RawResourceAndroidNotificationSound(this.notificationSoundPathAndroid)
    );

    final iosNotificationDetails = IOSNotificationDetails(
        sound: this.notificationSoundPathIos);

    final notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);

    await this
        .localNotificationsPlugin
        .show(0, title, message, notificationDetails);
  }
}
