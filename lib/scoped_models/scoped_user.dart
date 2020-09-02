import 'dart:convert';
import 'package:kitchen/api/verify_user_response.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/services/hive_db.dart';
import 'package:kitchen/models/user.dart';

class ScopedUser extends Model {
  User _currentUser;
  String _apiToken;
  String _kitchenToken;
  int _kitchenId;
  HiveDb _db;

  ScopedUser({db}) {
    if (db != null) {
      this._db = db;
    }
  }

  Future<void> initDb() {
    if (this._db != null) {
      return Future.value();
    } else {
      return HiveDb.init("user").then((openedDb) => this._db = openedDb);
    }
  }

  int getKitchenId() {
    return this._kitchenId != null
        ? this._kitchenId
        : this._db.get("kitchenId");
  }

  String getKitchenToken() {
    return this._kitchenToken != null
        ? this._kitchenToken
        : this._db.get("token");
  }

  User getUser() {
    return this._currentUser;
  }

  String getApiToken() {
    return this._apiToken;
  }

  void setKitchenId(int kitchenId) {
    this._kitchenId = kitchenId;
    return this._db.add("kitchenId", kitchenId);
  }

  void setKitchenToken(String token) {
    this._kitchenToken = token;
    return this._db.add("token", token);
  }

  void setFromResponse(dynamic responseStr) {
    final decodedResp = json.decode(responseStr);
    final response = VerifyUserResponse.fromJson(decodedResp);

    this._currentUser = response.user;
    this._apiToken = response.apiToken;
  }

  void clear() {
    this._currentUser = null;
    this._apiToken = null;
    this._kitchenId = null;
    this._kitchenToken = null;

    this._db.delete("kitchenId");
    this._db.delete("token");
  }
}
