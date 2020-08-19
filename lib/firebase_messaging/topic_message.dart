import 'package:kitchen/models/order.dart';
import 'package:kitchen/scoped_models/scoped_order.dart';

import '../service_locator.dart';

abstract class TopicMessage {
  final topicName;

  TopicMessage(this.topicName);

  void handleOnMessage(Map<String, dynamic> jsonMap){
    throw UnimplementedError();
  }

  void handleOnLaunch(Map<String, dynamic> jsonMap){
    throw UnimplementedError();
  }

  void handleOnResume(Map<String, dynamic> jsonMap){
    throw UnimplementedError();
  }

  void handleBackgroundDataMessage(Map<String, dynamic> jsonMap){
    throw UnimplementedError();
  }

  void handleBackgroundNotification(Map<String, dynamic> jsonMap){
    throw UnimplementedError();
  }
}
