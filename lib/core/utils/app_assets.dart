class AppAssets {
  static const String avatar0 = "assets/avatar/avatar_0.png";
  static const String avatar1 = "assets/avatar/avatar_1.png";
  static const String avatar2 = "assets/avatar/avatar_2.png";
  static const String avatar3 = "assets/avatar/avatar_3.png";
  static const String avatar4 = "assets/avatar/avatar_4.png";
  static const String avatar5 = "assets/avatar/avatar_5.png";
  static const String avatar6 = "assets/avatar/avatar_6.png";
  static const String avatar7 = "assets/avatar/avatar_7.png";
  static const String avatar8 = "assets/avatar/avatar_8.png";
  static const String avatar9 = "assets/avatar/avatar_9.png";
  static const String avatar10 = "assets/avatar/avatar_10.png";
  static const String avatar11 = "assets/avatar/avatar_11.png";

  static const List<String> avatars = [
    avatar0,
    avatar1,
    avatar2,
    avatar3,
    avatar4,
    avatar5,
    avatar6,
    avatar7,
    avatar8,
    avatar9,
    avatar10,
    avatar11,
  ];

  static String getAvatarPath(int avatarIndex) {
    if (avatarIndex < 0 || avatarIndex >= avatars.length) {
      return avatars[0];
    }
    return avatars[avatarIndex];
  }
}
