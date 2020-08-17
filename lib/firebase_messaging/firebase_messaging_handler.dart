import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kitchen/firebase_messaging/new_order_message.dart';
import 'package:kitchen/firebase_messaging/topic_message.dart';
import 'package:kitchen/models/order.dart';
import 'package:kitchen/scoped_models/scoped_order.dart';

enum MessageAction {
  onMessage,
  onLaunch,
  onResume,
  onBackgroundDataMessage,
  onBackgroundNotification
}

class FirebaseMessagingHandler {
  static Future<dynamic> _handleBackgroundMessage(
      Map<String, dynamic> message) {
    final topicMessageMap = _getTopicMessageMap();

    if (message.containsKey('data')) {
      final dynamic data = message['data'];
      print(data);
      _handleMessageAction(message, topicMessageMap, MessageAction.onBackgroundDataMessage, jsonDecodedMap: message);
    }

    if (message.containsKey('notification')) {
      final dynamic notification = message['notification'];
      print(notification);
      _handleMessageAction(message, topicMessageMap, MessageAction.onBackgroundNotification, jsonDecodedMap: message);

    }

    return Future.value();
  }

  static void handleMessages() {

    final topicMessageMap = _getTopicMessageMap();

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.configure(
        onMessage: (message) {
          print("onMessage: $message");
          _handleMessageAction(
              message, topicMessageMap, MessageAction.onMessage);
          return Future.value();
        },
        onBackgroundMessage: _handleBackgroundMessage,
        onResume: (message) {
          print("onResume: $message");
          _handleMessageAction(
              message, topicMessageMap, MessageAction.onResume);
          return Future.value();
        },
        onLaunch: (message) {
          print("onLaunch: $message");
          _handleMessageAction(
              message, topicMessageMap, MessageAction.onLaunch);
          return Future.value();
        });
    //when we move to multi-kitchen, this will subscribe to just the kitchen's topic
    _firebaseMessaging.subscribeToTopic("orders");
  }
  
  static Map<String, TopicMessage> _getTopicMessageMap(){
    final List<TopicMessage> topics = [NewOrderMessage()];
    var topicMessageMap = Map<String, TopicMessage>();

    topics.forEach((element) {
      topicMessageMap[element.topicName] = element;
    });
    
    return topicMessageMap;
  }

  static Map<String, dynamic> _getJsonDecodedMap(message) {
    if (message['data'] != null && message['data']['data'] != null) {
      return Map<String, dynamic>.from(jsonDecode(message['data']['data']));
    } else {
      throw Exception("Map cannot be extracted from message $message");
    }
  }

  static void _handleMessageAction(message,
      Map<String, TopicMessage> topicMessageMap,
      MessageAction action,
      {Map<String, dynamic> jsonDecodedMap}) {
    final jsonMap = jsonDecodedMap ?? _getJsonDecodedMap(message);
    final topicName = message['data']['type'];
    if (topicName != null && topicMessageMap[topicName] != null) {
      TopicMessage topicMessage = topicMessageMap[topicName];
      switch (action) {
        case MessageAction.onMessage :
          topicMessage.handleOnMessage(jsonMap);
          break;
        case MessageAction.onLaunch :
          topicMessage.handleOnLaunch(jsonMap);
          break;
        case MessageAction.onResume :
          topicMessage.handleOnResume(jsonMap);
          break;
        case MessageAction.onBackgroundDataMessage :
          topicMessage.handleBackgroundDataMessage(jsonMap);
          break;
        case MessageAction.onBackgroundNotification :
          topicMessage.handleBackgroundNotification(jsonMap);
          break;
        default:
          throw Exception("Unregistered MessageAction action");
      }
    } else {
      throw Exception(
          "Message type is $topicName. Message type must be non-null and valid");
    }
  }
}
