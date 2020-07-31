import 'package:scoped_model/scoped_model.dart';
import '../services/web_api.dart';
import '../service_locator.dart';

abstract class ScopedApiModel extends Model {
  bool isLoading = false;
  WebApi api;
  DateTime _lastLoaded;

  ScopedApiModel({WebApi api}) {
    this.api = api ?? locator<WebApi>();
  }

  Future<void> loadData(Future<void> Function() fetchData,
      {forceLoad = false}) async {
    final now = DateTime.now();
    final lastMidnight = new DateTime(now.year, now.month, now.day);

    if (forceLoad ||
        this._lastLoaded == null ||
        this._lastLoaded.millisecondsSinceEpoch <
            lastMidnight.millisecondsSinceEpoch) {
      this.isLoading = true;
      notifyListeners();

      await fetchData();

      this.isLoading = false;
      this._lastLoaded = now;

      notifyListeners();
    }
  }
}
