import 'package:flutter/material.dart';
import 'package:movie_app/config/theme/theme.dart';

enum SubscriptionPlan {
  basic,
  silver,
  gold;

  String toJson() => name;

  static SubscriptionPlan fromJson(String value) {
    return SubscriptionPlan.values.firstWhere(
      (e) => e.name == value,
      orElse: () => SubscriptionPlan.basic,
    );
  }

  bool get isBasic => this == SubscriptionPlan.basic;

  bool get isSilver => this == SubscriptionPlan.silver;

  bool get isGold => this == SubscriptionPlan.gold;

  String get displayName {
    switch (this) {
      case SubscriptionPlan.basic:
        return 'Basic';
      case SubscriptionPlan.silver:
        return 'Silver';
      case SubscriptionPlan.gold:
        return 'Gold';
    }
  }

  Color get color {
    switch (this) {
      case SubscriptionPlan.basic:
        return AppColor.greyScale500;
      case SubscriptionPlan.silver:
        return AppColor.greyScale200;
      case SubscriptionPlan.gold:
        return const Color(0xFFFFF1D5);
    }
  }

  IconData get icon {
    switch (this) {
      case SubscriptionPlan.basic:
        return Icons.star;
      case SubscriptionPlan.silver:
        return Icons.star;
      case SubscriptionPlan.gold:
        return Icons.star;
    }
  }
}
