import 'package:live_video_apps/app/data/models/token_from_request.dart';
import 'package:live_video_apps/app/data/models/user.dart';

class UserInfo {
  User? user;
  String? token;
  TokenFromRequest? tokenFromRequest;

  UserInfo({this.user, this.token, this.tokenFromRequest});

  UserInfo.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    token = json['token'];
    tokenFromRequest = json['tokenFromRequest'] != null
        ? new TokenFromRequest.fromJson(json['tokenFromRequest'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['token'] = this.token;
    if (this.tokenFromRequest != null) {
      data['$tokenFromRequest'] = this.tokenFromRequest!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return "User: ${user}, Token: ${token}, TokenFromrequest: ${tokenFromRequest}";
  }
}
