enum SubscriptionPlan {
  basic,
  vip1,
  vip2;

  String toJson() => name;

  static SubscriptionPlan fromJson(String value) {
    return SubscriptionPlan.values.firstWhere(
      (e) => e.name == value,
      orElse: () => SubscriptionPlan.basic,
    );
  }
}