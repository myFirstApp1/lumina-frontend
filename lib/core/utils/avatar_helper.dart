class AvatarHelper {

  static const Map<String, String> avatars = {

    "avatar1": "assets/avatars/avatar1.png",

    "avatar2": "assets/avatars/avatar2.png",

    "avatar3": "assets/avatars/avatar3.png",

    "avatar4": "assets/avatars/avatar4.png",

    "avatar5": "assets/avatars/avatar5.png",

    "avatar6": "assets/avatars/avatar6.png",

    "avatar7": "assets/avatars/avatar7.png",

    "avatar8": "assets/avatars/avatar8.png",

    "avatar9": "assets/avatars/avatar9.png",

    "avatar10": "assets/avatars/avatar10.png",

  };

  static String getAvatarPath(String? avatarId) {
    return avatars[avatarId] ??
        "assets/images/defaultProfile.png";
  }
}