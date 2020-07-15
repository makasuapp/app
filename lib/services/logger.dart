import 'package:sentry/sentry.dart';
import '../env.dart';

class Logger {
  static final SentryClient sentry = new SentryClient(
      dsn:
          'https://547d447dc4fa47068b254b47082ea311:3e1fa8fe27ce48d98a40e8db5e5f5beb@o340561.ingest.sentry.io/5338625');

  static void info(String msg) {
    if (EnvironmentConfig.ENV == "dev") {
      print(msg);
    } else {
      sentry.capture(
          event: Event(message: msg, environment: EnvironmentConfig.ENV));
    }
  }

  static void error(dynamic err) {
    if (EnvironmentConfig.ENV == "dev") {
      print(err.toString());
    } else {
      sentry.captureException(exception: err);
    }
  }
}
