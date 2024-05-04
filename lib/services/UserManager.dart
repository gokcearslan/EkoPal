class UserManager {
  static final UserManager _instance = UserManager._internal();
  factory UserManager() => _instance;

  UserManager._internal();

  String? userId;

  void login(String id) {
    userId = id;
  }

  void logout() {
    userId = null;
  }
}
