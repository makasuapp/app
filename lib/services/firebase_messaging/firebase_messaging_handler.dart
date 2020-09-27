import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kitchen/service_locator.dart';
import './new_order_message.dart';
import './topic_message.dart';

class FirebaseMessagingHandler {
  static Map<String, TopicMessage> topicMessageMap;

  static void init(BuildContext context) {
    final firebaseMessaging = locator<FirebaseMessaging>();
    firebaseMessaging.requestNotificationPermissions();

    _initTopicMessageMap(context, firebaseMessaging);
    _initMessageHandlers(firebaseMessaging);
  }

  static void subscribeToTopics(int kitchenId) {
    //TODO: clear past subscriptions - delete needs to reauth after..?
    // firebaseMessaging.deleteInstanceID();

    final firebaseMessaging = locator<FirebaseMessaging>();
    firebaseMessaging.subscribeToTopic("orders_$kitchenId");
  }

  static Future<dynamic> _onBackgroundFunction(Map<String, dynamic> message) {
    //what if has both data and notification?
    if (message.containsKey('data')) {
      final dynamic data = message['data'];
      print(data);
      _getTopicMessage(message, topicMessageMap)
          .handleBackgroundDataMessage(_getJsonDecodedMap(message));
    } else if (message.containsKey('notification')) {
      final dynamic notification = message['notification'];
      print(notification);
      _getTopicMessage(message, topicMessageMap)
          .handleBackgroundNotification(_getJsonDecodedMap(message));
    }

    return Future.value(message);
  }

  static void _initMessageHandlers(FirebaseMessaging firebaseMessaging) {
    firebaseMessaging.configure(
        onMessage: (message) {
          print("onMessage: $message");
          _getTopicMessage(message, topicMessageMap)
              .handleOnMessage(_getJsonDecodedMap(message));

          return Future.value(message);
        },
        //apparently background message doesn't work in ios..?
        onBackgroundMessage: Platform.isIOS ? null : _onBackgroundFunction,
        onResume: (message) {
          print("onResume: $message");
          _getTopicMessage(message, topicMessageMap)
              .handleOnResume(_getJsonDecodedMap(message));
          return Future.value(message);
        },
        onLaunch: (message) {
          print("onLaunch: $message");
          _getTopicMessage(message, topicMessageMap)
              .handleOnLaunch(_getJsonDecodedMap(message));
          return Future.value(message);
        });
  }

  static Map<String, TopicMessage> _initTopicMessageMap(
      BuildContext context, FirebaseMessaging firebaseMessaging) {
    final List<TopicMessage> topics = [
      NewOrderMessage(context, firebaseMessaging)
    ];
    topicMessageMap = Map<String, TopicMessage>();

    topics.forEach((topic) {
      topicMessageMap[topic.topicName] = topic;
      topic.notificationHandler.initNotificationHandler();
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
