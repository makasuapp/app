import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kitchen/firebase_messaging/new_order_message.dart';
import 'package:kitchen/firebase_messaging/topic_message.dart';

class FirebaseMessagingHandler extends StatefulWidget {
  final BuildContext context;

  FirebaseMessagingHandler(this.context);

  @override
  State<StatefulWidget> createState() {
    return _FirebaseMessagingHandler();
  }
}

class _FirebaseMessagingHandler extends State<FirebaseMessagingHandler> {
  static Map<String, TopicMessage> topicMessageMap;
  static FirebaseMessaging firebaseMessaging;

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void initState() {
    super.initState();
    firebaseMessaging = _getFirebaseMessaging();
    topicMessageMap = _getTopicMessageMap(this.context, firebaseMessaging);
    topicMessageMap.forEach((key, value) {
      value.notificationHandler.initNotificationHandler();
    });
    handleMessages();
  }

  static Future<dynamic> _onBackgroundFunction(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      final dynamic data = message['data'];
      print(data);
      _getTopicMessage(message, topicMessageMap)
          .handleBackgroundDataMessage(_getJsonDecodedMap(message));
    }

    if (message.containsKey('notification')) {
      final dynamic notification = message['notification'];
      print(notification);
      _getTopicMessage(message, topicMessageMap)
          .handleBackgroundNotification(_getJsonDecodedMap(message));
    }

    return Future.value();
  }

  void handleMessages() {
    firebaseMessaging.configure(
        onMessage: (message) {
          print("onMessage: $message");
          _getTopicMessage(message, topicMessageMap)
              .handleOnMessage(_getJsonDecodedMap(message));

          return Future.value();
        },
        onBackgroundMessage: _onBackgroundFunction,
        onResume: (message) {
          print("onResume: $message");
          _getTopicMessage(message, topicMessageMap)
              .handleOnResume(_getJsonDecodedMap(message));
          return Future.value();
        },
        onLaunch: (message) {
          print("onLaunch: $message");
          _getTopicMessage(message, topicMessageMap)
              .handleOnLaunch(_getJsonDecodedMap(message));
          return Future.value();
        });

    //TODO(multi-kitchen): put in actual kitchen id
    firebaseMessaging.subscribeToTopic("orders_1");
  }

  static FirebaseMessaging _getFirebaseMessaging() {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    firebaseMessaging.requestNotificationPermissions();

    return firebaseMessaging;
  }

  static Map<String, TopicMessage> _getTopicMessageMap(
      BuildContext context, FirebaseMessaging firebaseMessaging) {
    final List<TopicMessage> topics = [
      NewOrderMessage(context, firebaseMessaging)
    ];
    var topicMessageMap = Map<String, TopicMessage>();

    topics.forEach((element) {
      topicMessageMap[element.topicName] = element;
    });

    return topicMessageMap;
  }

  static dynamic _getMessageData(message) {
    //iOS for whatever reason has a different format. it's not nested under 'data'
    return message['data'] ?? message;
  }

  static Map<String, dynamic> _getJsonDecodedMap(message) {
    final messageData = _getMessageData(message);
    if (messageData['content'] != null) {
      return Map<String, dynamic>.from(jsonDecode(messageData['content']));
    } else {
      throw Exception("Map cannot be extracted from message $message");
    }
  }

  static TopicMessage _getTopicMessage(
      message, Map<String, TopicMessage> topicMessageMap) {
    final messageData = _getMessageData(message);
    final topicName = messageData['type'];
    if (topicName != null && topicMessageMap[topicName] != null) {
      return topicMessageMap[topicName];
    } else {
      throw Exception("Topic is $topicName. Topic must be non-null and valid");
    }
  }
}
