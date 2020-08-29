import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './topic_message.dart';
import 'package:kitchen/models/order.dart';
import 'package:kitchen/scoped_models/scoped_order.dart';
import 'package:kitchen/screens/orders/upcoming_orders.dart';
import '../../service_locator.dart';

class NewOrderMessage extends TopicMessage {
  static final String topic = "new_order";
  static final String topicTitle = "New Order";
  final BuildContext context;
  final FirebaseMessaging firebaseMessaging;

  NewOrderMessage(this.context, this.firebaseMessaging)
      : super(topic, topicTitle, context, firebaseMessaging,
            notificationSoundPathAndroid: "@raw/cash_register_purchase",
            notificationSoundPathIos: "cash_register_purchase.wav");

  @override
  void handleOnMessage(Map<String, dynamic> jsonMap) {
    final scopedOrder = locator<ScopedOrder>();
    final newOrder = Order.fromJson(jsonMap);
    scopedOrder.addOrder(newOrder);

    this.showNotification("Order ID: ${newOrder.id}");
  }

  @override
  Future onNotificationSelect(String payload) {
    Navigator.pushNamed(this.context, UpcomingOrdersPage.routeName);

    return Future.value();
  }
}
