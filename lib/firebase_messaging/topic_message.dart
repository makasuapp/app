import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:kitchen/firebase_messaging/local_notification_handler.dart';

abstract class TopicMessage {
  final topicName;
  final title;
  final BuildContext context;
  final FirebaseMessaging firebaseMessaging;
  final String notificationSoundPathAndroid;
  final String notificationSoundPathIos;
  LocalNotificationHandler notificationHandler;

  TopicMessage(this.topicName, this.title, this.context, this.firebaseMessaging,
      {this.notificationSoundPathIos, this.notificationSoundPathAndroid}) {
    notificationHandler = new LocalNotificationHandler(firebaseMessaging, title,
        onSelectNotification: onNotificationSelect,
        notificationSoundPathAndroid: this.notificationSoundPathAndroid,
        notificationSoundPathIos: this.notificationSoundPathIos);
  }

  void showNotification(String message){
    this.notificationHandler.showNotification(message);
  }

  void handleOnMessage(Map<String, dynamic> jsonMap) {
    throw UnimplementedError("Unimplemented handleOnMessage");
  }

  void handleOnLaunch(Map<String, dynamic> jsonMap) {
    throw UnimplementedError("Unimplemented handleOnLaunch");
  }

  void handleOnResume(Map<String, dynamic> jsonMap) {
    throw UnimplementedError("Unimplemented handleOnResume");
  }

  void handleBackgroundDataMessage(Map<String, dynamic> jsonMap) {
    throw UnimplementedError("Unimplemented handleBackgroundDataMessage");
  }

  void handleBackgroundNotification(Map<String, dynamic> jsonMap) {
    throw UnimplementedError("Unimplemented handleBackgroundNotification");
  }

  Future<dynamic> onNotificationSelect(String payload) {
    throw UnimplementedError("Unimplemented onMessageNotificationSelect");
  }
}
