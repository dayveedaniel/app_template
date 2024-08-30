import 'package:new_project_template/util/helpers.dart';

class UserAuthData {
  final String userId;
  final String email;
  final String? verifyToken;
  final String name;

  UserAuthData({
    required this.userId,
    required this.email,
    required this.name,
    this.verifyToken,
  });

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "email": email,
        "name": name,
        "verifyToken": verifyToken
      }..removeNull();
}

class UserModel {
  final String userId;
  final String email;
  final String name;
  final List<String> currentSubscriptionId;
  final List<String> restrictedScreens;
  final DateTime activeTariffEndDate;

  UserModel({
    required this.userId,
    required this.email,
    required this.name,
    required this.activeTariffEndDate,
    required this.currentSubscriptionId,
    required this.restrictedScreens,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json["userId"],
        email: json["email"],
        name: json["name"],
        activeTariffEndDate: DateTime.parse(json["activeTariffEndDate"]),
        currentSubscriptionId: List<dynamic>.from(json["appleSubscriptionId"])
            .map((e) => e["subscriptionId"].toString())
            .toList(),
        restrictedScreens: List<String>.from(json["restrictedScreens"]),
      );
}
