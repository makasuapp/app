import 'package:kitchen/models/day_prep.dart';
import 'package:kitchen/scoped_models/scoped_day_prep.dart';
import 'package:kitchen/services/web_api.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:kitchen/service_locator.dart';

class MockApi extends Mock implements WebApi {}

void main() {
  setupLocator();

  //TODO: test sorting

  //TODO: test building dependency map
}