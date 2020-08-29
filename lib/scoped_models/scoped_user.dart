import 'dart:convert';
import 'package:kitchen/api/verify_user_response.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/services/hive_db.dart';
import 'package:kitchen/models/user.dart';

class ScopedUser extends Model {
  User currentUser;
  String apiToken;
  String kitchenToken;
  int kitchenId;
  HiveDb db;

  ScopedUser({db}) {
    this.db = db ?? HiveDb("user");
  }

  Future<int> getKitchenId() {
    return this.kitchenId != null
        ? Future.value(this.kitchenId)
        : this.db.get("kitchenId");
  }

  Future<String> getKitchenToken() {
    return this.kitchenToken != null
        ? Future.value(this.kitchenToken)
        : this.db.get("token");
  }

  Future<void> setKitchenId(int kitchenId) {
    this.kitchenId = kitchenId;
    return this.db.add("kitchenId", kitchenId);
  }

  Future<void> setKitchenToken(String token) {
    this.kitchenToken = token;
    return this.db.add("token", token);
  }

  void setFromResponse(dynamic responseStr) {
    final decodedResp = json.decode(responseStr);
    final response = VerifyUserResponse.fromJson(decodedResp);

    this.currentUser = response.user;
    this.apiToken = response.apiToken;
  }

  Future<void> clear() async {
    this.currentUser = null;
    this.apiToken = null;
    this.kitchenId = null;
    this.kitchenToken = null;

    await this.db.delete("kitchenId");
    await this.db.delete("token");
  }
}
