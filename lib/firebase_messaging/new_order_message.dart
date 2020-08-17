import 'dart:convert';

import 'package:kitchen/firebase_messaging/topic_message.dart';
import 'package:kitchen/models/order.dart';
import 'package:kitchen/scoped_models/scoped_order.dart';

import '../service_locator.dart';

class NewOrderMessage extends TopicMessage {
  static final String topic = "new_order";

  NewOrderMessage() : super(topic);

  @override
  void handleOnMessage(Map<String, dynamic> jsonMap) async {
    final scopedOrder = locator<ScopedOrder>();
    await scopedOrder.loadOrders();

    final newOrder = Order.fromJson(jsonMap);
    scopedOrder.addOrder(newOrder);
  }

}
